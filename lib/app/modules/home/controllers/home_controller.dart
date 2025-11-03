// ignore_for_file: unnecessary_overrides, depend_on_referenced_packages, avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  late TabController tabController, tabloginController;
  RxInt tabRegisterControllerIndex = 0.obs;

  RxList<PollModel> currentPolls = <PollModel>[].obs;
  RxList<PollModel> pastPolls = <PollModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxBool isLoadingCompletedPolls = false.obs;
  RxBool isRefreshingCompletedPolls = false.obs;
  final api = ApiService();

  int currentPage = 1;
  bool hasMorePolls = true;
  int completedPollsCurrentPage = 1;
  bool hasMoreCompletedPolls = true;

  final scrollController = ScrollController();
  final completedPollsScrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    loadPollsFromLocal();
    loadCompletedPollsFromLocal();
    fetchPolls(reset: true); // Fetch fresh after local data shows
    fetchCompletedPolls(reset: true);
    updateFCMToken();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300 && !isLoading.value && hasMorePolls) {
        fetchPolls();
      }
    });

    completedPollsScrollController.addListener(() {
      if (completedPollsScrollController.position.pixels >= completedPollsScrollController.position.maxScrollExtent - 300 &&
          !isLoadingCompletedPolls.value &&
          hasMoreCompletedPolls) {
        fetchCompletedPolls();
      }
    });
  }

  Future<void> loadPollsFromLocal() async {
    final stored = await LocalStorageService.getData('cached_polls');
    if (stored != null && stored["polls"] != null) {
      List<dynamic> pollData = stored["polls"];
      currentPolls.value = pollData.map((e) => PollModel.fromJson(e)).toList();
    }
  }

  Future<void> loadCompletedPollsFromLocal() async {
    final stored = await LocalStorageService.getData('completed_polls');
    if (stored != null && stored["polls"] != null) {
      List<dynamic> pollData = stored["polls"];
      pastPolls.value = pollData.map((e) => PollModel.fromJson(e)).toList();
    }
  }

  Future<void> fetchPolls({bool reset = false, isLike = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    final token = await LocalStorageService.getString('token');

    if (reset) {
      currentPage = 1;
      hasMorePolls = true;

      currentPolls.clear();
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}poll/active_polls?page=$currentPage'),
        headers: {
          'Authorization': 'Bearer ${token}',
          'Cookie': 'fpw_zbt=6p0ijcojqckn4blvrdag47ladcmb8vp9',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print("response data = ${responseBody}");
        List<dynamic> pollData = jsonDecode(response.body)["data"];
        List<PollModel> fetchedPolls = pollData.map((e) => PollModel.fromJson(e)).toList();

        currentPolls.addAll(fetchedPolls);
        currentPage++;

        // Update hasMorePolle correctly
        final pagination = responseBody["pagination"];
        hasMorePolls = pagination["has_next_page"] ?? false;

        // Save to local storage
        List<Map<String, dynamic>> jsonList = currentPolls.map((e) => e.toJson()).toList();
        await LocalStorageService.saveData('cached_polls', {
          "polls": jsonList,
        });
      } else {
        print("Failed to fetch polls: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> fetchCompletedPolls({bool reset = false}) async {
    if (isLoadingCompletedPolls.value) return;
    isLoadingCompletedPolls.value = true;
    final token = await LocalStorageService.getString('token');

    if (reset) {
      completedPollsCurrentPage = 1;
      hasMoreCompletedPolls = true;
      pastPolls.clear();
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}poll/completed_polls?page=$completedPollsCurrentPage'),
        headers: {
          'Authorization': 'Bearer ${token}',
          'Cookie': 'fpw_zbt=6p0ijcojqckn4blvrdag47ladcmb8vp9',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        List<dynamic> pollData = responseBody["data"];
        List<PollModel> fetchedPolls = pollData.map((e) => PollModel.fromJson(e)).toList();

        pastPolls.addAll(fetchedPolls);
        completedPollsCurrentPage++;

        // Update hasMoreCompletedPolls correctly
        final pagination = responseBody["pagination"];
        hasMoreCompletedPolls = pagination["has_next_page"] ?? false;

        // Save locally
        List<Map<String, dynamic>> jsonList = pastPolls.map((e) => e.toJson()).toList();
        await LocalStorageService.saveData('completed_polls', {
          "polls": jsonList,
        });
      } else {
        print("Failed to fetch polls: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingCompletedPolls.value = false;
      isRefreshingCompletedPolls.value = false;
    }
  }

  Future<void> refreshPolls() async {
    isRefreshing.value = true;
    await fetchPolls(reset: true);
  }

  Future<void> refreshCompleltedPolls() async {
    isRefreshingCompletedPolls.value = true;
    await fetchCompletedPolls(reset: true);
  }

  void likePoll(int? id, {isPastPoll = false}) async {
    final response = await homeController.api.postLikeFormData(
      poll_id: id.toString(),
    );
    if (response['status'] == 200) {
      final data = response["data"];
      if (data != null) {
        updatePollAfterLike(id, isPastPoll: isPastPoll, likeCount: data['likes_count']);
      }
    } else {
      CustomSnackbar.error("Error", response['message']);
    }
  }

  void updatePollAfterLike(pollId, {isPastPoll = false, required int likeCount}) {
    if (isPastPoll) {
      final pollIndex = pastPolls.indexWhere((poll) => poll.id == pollId);
      print("poll index = ${pollIndex}");
      if (pollIndex == -1) return;

      final poll = pastPolls[pollIndex];
      poll.isLiked = !(poll.isLiked ?? false);
      print("Like COunt = ${likeCount}");
      poll.likesCount = likeCount;
      pastPolls[pollIndex] = poll;
      pastPolls.refresh();
    } else {
      final pollIndex = currentPolls.indexWhere((poll) => poll.id == pollId);
      print("poll index = ${pollIndex}");
      if (pollIndex == -1) return;

      final poll = currentPolls[pollIndex];
      poll.isLiked = !(poll.isLiked ?? false);
      poll.likesCount = likeCount;
      currentPolls[pollIndex] = poll;

      currentPolls.refresh();
    }
  }

  void updatePollAfterVote(PollModel poll_details, int pollId, int selectedOptionId) {
    final pollIndex = currentPolls.indexWhere((poll) => poll.id == pollId);
    if (pollIndex == -1) return;

    final poll = currentPolls[pollIndex];

    // Update vote count and mark selected option
    for (var option in poll.options!) {
      if (option.id == selectedOptionId) {
        option.voteCount = (option.voteCount ?? 0) + 1;
        option.isVoted = true;
      } else {
        option.isVoted = false;
      }
    }

    // Recalculate totalVotes
    int totalVotes = poll_details.totalVotes ?? poll.options!.fold(0, (sum, o) => sum + (o.voteCount ?? 0));
    poll.totalVotes = poll_details.totalVotes ?? totalVotes;

    // Recalculate percentages
    for (var option in poll.options!) {
      final count = option.voteCount ?? 0;
      option.percentage = totalVotes == 0 ? 0 : ((count * 100) ~/ totalVotes);
    }

    // Update vote flags
    poll.options = poll_details.options;
    for (Options pollOption in poll.options ?? []) {
      print("POLL OPTION TEXT = ${pollOption.text}, PER = ${pollOption.percentage}, isVoted = ${pollOption.isVoted}");
    }
    poll.canVote = false;
    poll.hasVoted = true;
    currentPolls[pollIndex] = poll;
    currentPolls.refresh();
  }

  void updatePollAfterUndoVote(PollModel poll_details, int pollId, int selectedOptionId) {
    final pollIndex = currentPolls.indexWhere((poll) => poll.id == pollId);
    if (pollIndex == -1) return;

    final poll = currentPolls[pollIndex];

    // Remove vote from selected option
    for (var option in poll.options!) {
      if (option.id == selectedOptionId) {
        option.voteCount = (option.voteCount ?? 1) - 1;
        if (option.voteCount! < 0) option.voteCount = 0;
        option.isVoted = false;
      }
    }

    // Recalculate totalVotes
    print("VotaeCount ::: ${poll.totalVotes}");
    int totalVotes = poll_details.totalVotes ?? poll.options!.fold(0, (sum, o) => sum + (o.voteCount ?? 0));
    poll.totalVotes = poll_details.totalVotes ?? totalVotes;

    // Recalculate percentages
    for (var option in poll.options!) {
      final count = option.voteCount ?? 0;
      option.percentage = totalVotes == 0 ? 0 : ((count * 100) ~/ totalVotes);
    }

    // Update vote flags
    poll.options = poll_details.options;
    poll.canVote = true;
    poll.hasVoted = false;

    currentPolls[pollIndex] = poll;
    currentPolls.refresh();
  }

  Future<void> removePollFromLocalStorage(int pollId) async {
    try {
      final response = await api.postDeletePollFormData(poll_id: pollId.toString());

      if (response['status'] == 200) {
        pastPolls.removeWhere((element) => element.id == pollId);
        pastPolls.refresh();
        await LocalStorageService.saveData('completed_polls', {
          'polls': pastPolls.map((e) => e.toJson()).toList(),
        });

        currentPolls.removeWhere((element) => element.id == pollId);
        currentPolls.refresh();

        await LocalStorageService.saveData('cached_polls', {
          'polls': currentPolls.map((e) => e.toJson()).toList(),
        });

        CustomSnackbar.success("Success", response['message'] ?? "Poll deleted successfully.");
      } else {
        CustomSnackbar.error("Error", response['message']);
      }
    } catch (e) {
      CustomSnackbar.error("Error", e.toString());
    }
  }

  Future<void> onFollow(int userID) async {
    try {
      final response = await api.postFollowFormData(userId: userID.toString());

      if (response['status'] == 200) {
        // Simulate API call (replace this with actual API call)
        await Future.delayed(Duration(milliseconds: 300));

        // Update in currentPolls
        for (var poll in currentPolls) {
          if (poll.creator?.id == userID) {
            poll.creator?.isFollowing = true;
          }
        }

        // Update in pastPolls
        for (var poll in pastPolls) {
          if (poll.creator?.id == userID) {
            poll.creator?.isFollowing = true;
          }
        }

        currentPolls.refresh();
        pastPolls.refresh();

        // Increment following count in user model
        if (user.value != null) {
          user.value!.followingCount += 1;
          user.refresh();

          // Save updated user to local storage
          await LocalStorageService.saveData(
            'logged_in_user',
            user.value!.toJson(),
          );
        }
        final data = await LocalStorageService.getData('logged_in_user');
        if (data != null) {
          user.value = UserModel.fromJson(data);
          profileController.user.value = UserModel.fromJson(data);
          profileController.user.refresh();
        }
        print("User ds :${user.value?.followingCount}");
      } else {
        CustomSnackbar.error("Error", response['message']);
      }
    } catch (e) {
      CustomSnackbar.error("Error", e.toString());
    }
  }

  Future<void> onUnFollow(int userID) async {
    try {
      final response = await api.postUnFollowFormData(userId: userID.toString());

      if (response['status'] == 200) {
        // Simulate API call (replace this with actual API call)
        await Future.delayed(Duration(milliseconds: 300));

        // Update in currentPolls
        for (var poll in currentPolls) {
          if (poll.creator?.id == userID) {
            poll.creator?.isFollowing = false;
          }
        }

        // Update in pastPolls
        for (var poll in pastPolls) {
          if (poll.creator?.id == userID) {
            poll.creator?.isFollowing = false;
          }
        }

        currentPolls.refresh();
        pastPolls.refresh();

        if (user.value != null && user.value!.followingCount > 0) {
          user.value!.followingCount -= 1;
          user.refresh();

          await LocalStorageService.saveData(
            'logged_in_user',
            user.value!.toJson(),
          );
        }
        final data = await LocalStorageService.getData('logged_in_user');
        if (data != null) {
          profileController.user.value = UserModel.fromJson(data);

          profileController.user.refresh();
        }

        // final data = await LocalStorageService.getData('logged_in_user');
        // if (data != null) {
        //   user.value = UserModel.fromJson(data);
        // }
      } else {
        CustomSnackbar.error("Error", response['message']);
      }
    } catch (e) {
      CustomSnackbar.error("Error", e.toString());
    }
  }

  updateFCMToken() async {
    final fcmToken = await LocalStorageService.getString('fcm_token');
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${ApiService.baseUrl}profile/update_fcm_token');

    var request = http.MultipartRequest('POST', uri)..fields['fcm_token'] = fcmToken ?? "";

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("FCM UPDATE TOKEN: ${response.body}");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

//await LocalStorageService.remove('cached_polls');

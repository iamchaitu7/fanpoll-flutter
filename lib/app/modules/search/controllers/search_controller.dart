// ignore_for_file: unnecessary_overrides

import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utills/appServices.dart';
import '../../../utills/custom_snackbar.dart';
import '../../../utills/module_controllers.dart';

class SearchController extends GetxController {
  final count = 0.obs;

  final RxString initialQuery = ''.obs;
  final searchParam = ''.obs;
  final hashtagParam = ''.obs;

  RxList<PollModel> searchResults = <PollModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxBool hasMoreResults = true.obs;
  int currentPage = 1;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print("ARGUMENTS::$args");
    if (args != null && args is Map) {
      searchParam.value = args['search'] ?? '';
      hashtagParam.value = args['hashtag'] ?? '';
      print('Received search: ${searchParam.value}, hashtag: ${hashtagParam.value}');

      fetchSearchResults(reset: true);
    }

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (hasMoreResults.value && !isLoading.value) {
        fetchSearchResults();
      }
    }
  }

  Future<void> fetchSearchResults({bool reset = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    if (reset) {
      currentPage = 1;
      hasMoreResults.value = true;
      searchResults.clear();
    }

    try {
      final token = await LocalStorageService.getString('token');
      final uri = Uri.parse('${ApiService.baseUrl}poll/active_polls?page=${currentPage}&search&hashtag=${hashtagParam}');

      print('Search API URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Cookie': 'fpw_zbt=t2d0kq2mlengrg673j3u7q21d3qsljgd',
        },
      );

      print('Search API Response Status: ${response.statusCode}');
      print('Search API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<dynamic> pollData = responseBody["data"];
        final List<PollModel> fetchedPolls = pollData.map((e) => PollModel.fromJson(e)).toList();

        if (reset) {
          searchResults.assignAll(fetchedPolls);
        } else {
          searchResults.addAll(fetchedPolls);
        }

        currentPage++;
        final pagination = responseBody["pagination"];
        hasMoreResults.value = pagination["has_next_page"] ?? false;

        print('Fetched ${fetchedPolls.length} polls, hasMore: ${hasMoreResults.value}');
      } else {
        print("Failed to fetch search results: ${response.statusCode}");
        print("Error response: ${response.body}");
      }
    } catch (e) {
      print("Error fetching search results: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void likePoll(int? id) async {
    final response = await homeController.api.postLikeFormData(
      poll_id: id.toString(),
    );
    if (response['status'] == 200) {
      final data = response['data'];
      updatePollAfterLike(id, likesCount: data['likes_count']);
    } else {
      CustomSnackbar.error("Error", response['message']);
    }
  }

  void updatePollAfterLike(pollId, {required int likesCount}) {
    final pollIndex = searchResults.indexWhere((poll) => poll.id == pollId);

    if (pollIndex == -1) return;

    final poll = searchResults[pollIndex];
    poll.isLiked = !(poll.isLiked ?? false);
    poll.likesCount = likesCount;
    searchResults[pollIndex] = poll;
    searchResults.refresh();
  }

  Future<void> refreshSearch() async {
    isRefreshing.value = true;
    await fetchSearchResults(reset: true);
  }

  void performSearch(String query) {
    searchParam.value = query;
    fetchSearchResults(reset: true);
  }

  void performHashtagSearch(String hashtag) {
    hashtagParam.value = hashtag;
    fetchSearchResults(reset: true);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}

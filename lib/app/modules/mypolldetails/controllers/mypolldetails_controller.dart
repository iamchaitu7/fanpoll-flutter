// lib/app/modules/mypolldetails/controllers/mypolldetails_controller.dart

// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';

import '../../../utills/appServices.dart';
import '../../../utills/custom_snackbar.dart';
import '../../../utills/module_controllers.dart';

class MypolldetailsController extends GetxController {
  Rxn<PollModel> poll = Rxn<PollModel>();
  int pollId = 0;
  RxBool isLoading = false.obs;

  final selectedIndex = RxnInt();
  final optionId = RxnInt();
  final screenshotController = ScreenshotController();

  @override
  void onInit() {
    super.onInit();
    pollId = Get.arguments['poll_id'] ?? 0;
    print("poll_id: $pollId");
    fetchPollDetails();
  }

  Future<void> fetchPollDetails({isHideLoading = false}) async {
    try {
      if (!isHideLoading) {
        isLoading.value = true;
      }

      final url = Uri.parse('${ApiService.baseUrl}poll/view/$pollId');
      final token = await LocalStorageService.getString('token');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("poll_id 13: $data");
        poll.value = PollModel.fromJson(data['data']);
      } else {
        print('Failed to load poll details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching poll: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void likePoll(int? id) async {
    final response = await homeController.api.postLikeFormData(
      poll_id: id.toString(),
    );
    if (response['status'] == 200) {
      final data = response['data'];

      if (data != null) {
        updatePollAfterLike(id, likesCount: data['likes_count']);
      }
    } else {
      CustomSnackbar.error("Error", response['message']);
    }
  }

  void updatePollAfterLike(pollId, {required int likesCount}) {
    poll.value?.isLiked = !(poll.value?.isLiked ?? false);
    poll.value?.likesCount = likesCount;
    print("like count ${likesCount}");
    poll.refresh();
  }
}

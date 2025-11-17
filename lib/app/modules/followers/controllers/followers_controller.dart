// followers_controller.dart

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FollowersController extends GetxController {
  final followers = <FollowerModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchFollowers() async {
    try {
      isLoading.value = true;
      final uri = Uri.parse('${ApiService.baseUrl}user/followers/');
      final token = await LocalStorageService.getString('token');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<FollowerModel> loadedFollowers = (jsonData['data'] as List).map((item) => FollowerModel.fromJson(item)).toList();
        followers.assignAll(loadedFollowers);
      } else {
        Get.snackbar("Error", "Failed to fetch followers");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchFollowers();
  }
}

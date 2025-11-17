// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utills/appServices.dart';

class FollowingController extends GetxController {
  RxList<UserFollowModel> followingList = <UserFollowModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchFollowingUsers() async {
    isLoading.value = true;
    try {
      final token = await LocalStorageService.getString('token');
      final uri = Uri.parse('${ApiService.baseUrl}user/following/');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<UserFollowModel> list = (body['data'] as List).map((item) => UserFollowModel.fromJson(item)).toList();
        followingList.value = list;
      }
    } catch (e) {
      print("Error fetching following: $e");
    } finally {
      isLoading.value = false;
    }
  }

//   Future<void> toggleFollowStatus(int index) async {
//   final user = followingList[index];
//   final token = await LocalStorageService.getString('token');
//   final uri = Uri.parse(
//     user.isFollowing.value
//         ? 'https://fpw.zbit.ltd/api/user/unfollow/${user.id}'
//         : 'https://fpw.zbit.ltd/api/user/follow/${user.id}',
//   );

//   final response = await http.post(uri, headers: {
//     'Authorization': 'Bearer $token',
//   });

//   if (response.statusCode == 200) {
//     user.isFollowing.value = !user.isFollowing.value;

//     // Optional: Update current user in LocalStorage
//     final currentUser = await LocalStorageService.getData('logged_in_user');
//     if (currentUser != null) {
//       int currentCount = currentUser['following_count'] ?? 0;
//       currentUser['following_count'] =
//           user.isFollowing.value ? currentCount + 1 : currentCount - 1;
//       await LocalStorageService.saveData('logged_in_user', currentUser);
//     }
//   } else {
//     print("Failed to toggle follow status");
//   }
// }

  @override
  void onInit() {
    fetchFollowingUsers();
    super.onInit();
  }
}

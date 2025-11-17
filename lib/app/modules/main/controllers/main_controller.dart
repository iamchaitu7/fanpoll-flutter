import 'package:fan_poll/app/modules/notification/views/notification_view.dart';
import 'package:fan_poll/app/modules/createpoll/views/createpoll_view.dart';
import 'package:fan_poll/app/modules/profile/controllers/profile_controller.dart';
import 'package:fan_poll/app/modules/profile/views/profile_view.dart';
import 'package:fan_poll/app/modules/home/views/home_view.dart';
import 'package:fan_poll/app/modules/search_tab/views/search_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
    print("chanding tab");
  }

  Widget get currentPage {
    switch (currentIndex.value) {
      case 0:
        return const HomeView();
      case 1:
        return const SearchTabView();
      case 2:
        return CreatepollView();
      case 3:
        return NotificationView();
      case 4:
        // Dispose previous ProfileController instance before creating new
        Get.delete<ProfileController>();
        return const ProfileView();
      default:
        return const HomeView();
    }
  }
}

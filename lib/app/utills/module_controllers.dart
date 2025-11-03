import 'package:fan_poll/app/modules/comment/controllers/comment_controller.dart';
import 'package:fan_poll/app/modules/followers/controllers/followers_controller.dart';
import 'package:fan_poll/app/modules/following/controllers/following_controller.dart';
import 'package:fan_poll/app/modules/forgotpassword/controllers/forgotpassword_controller.dart';
import 'package:fan_poll/app/modules/home/controllers/home_controller.dart';
import 'package:fan_poll/app/modules/login/controllers/login_controller.dart';
import 'package:fan_poll/app/modules/main/controllers/main_controller.dart';
import 'package:fan_poll/app/modules/profile/controllers/profile_controller.dart';
import 'package:fan_poll/app/modules/register/controllers/register_controller.dart';
import 'package:fan_poll/app/modules/search_tab/controllers/search_tab_controller.dart';
import 'package:fan_poll/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

HomeController homeController = Get.put(HomeController());
SplashController splashController = Get.put(SplashController());
LoginController loginController = Get.put(LoginController());
RegisterController registerController = Get.put(RegisterController());
CommentController commentController = Get.put(CommentController());
MainController mainController = Get.put(MainController());
ForgotpasswordController forgotpasswordController =
    Get.put(ForgotpasswordController());
ProfileController profileController = Get.put(ProfileController());
FollowersController followersController = Get.put(FollowersController());
FollowingController followingController = Get.put(FollowingController());
SearchController searchController = Get.put(SearchController());
SearchTabController searchTabController = Get.put(SearchTabController());

// ignore_for_file: avoid_print

import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/following_controller.dart';

class FollowingView extends GetView<FollowingController> {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FollowingController());

    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        title: Text(
          'Following',
          style: CustomText.semiBold18(AppColor.SecondryColor),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchFollowingUsers(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.followingList.length,
            // separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = controller.followingList[index];
              return Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePicture),
                        radius: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullName,
                                style: CustomText.semiBold16(
                                    AppColor.SecondryColor)),
                            Text(user.bio ?? '',
                                style: CustomText.regular12(
                                    AppColor.LightGrayColor)),
                          ],
                        ),
                      ),
                      Obx(() => TextButton(
                            onPressed: () {
                              user.isFollowing.value = !user.isFollowing.value;

                              if (user.isFollowing.value) {
                                //unfollow
                                if (int.tryParse(user.id) != null) {
                                  homeController.onFollow(int.parse(user.id));
                                  print("Follow :: ${user.isFollowing.value}");
                                  print("Invalid ID: ${user.id}");
                                }
                              } else {
                                //follow
                                if (int.tryParse(user.id) != null) {
                                  homeController.onUnFollow(int.parse(user.id));
                                  print("Follow :: ${user.isFollowing.value}");
                                }
                                print("Follow :: ${user.isFollowing.value}");
                              }
                            },
                            child: Text(
                              user.isFollowing.value ? "Unfollow" : "+ Follow",
                              style:
                                  CustomText.semiBold12(AppColor.PrimaryColor),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Divider(
                    color: AppColor.LightGrayColor,
                    height: 0.5,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}

// followers_view.dart

// ignore_for_file: prefer_if_null_operators

import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/utills/utils.dart';
import '../controllers/followers_controller.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FollowersView extends GetView<FollowersController> {
  const FollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        title: Text(
          'Followers',
          style: CustomText.semiBold18(const Color(0xff22212F)),
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
          onRefresh: controller.fetchFollowers,
          child: controller.followers.isEmpty
              ? const Center(child: Text("No followers found."))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.followers.length,
                  // separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final follower = controller.followers[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage:
                                NetworkImage(follower.profilePicture),
                          ),
                          title: Text(
                            follower.fullName,
                            style:
                                CustomText.semiBold16(AppColor.SecondryColor),
                          ),
                          subtitle: Text(
                            "${follower.bio == null ? Utils.formatDate(follower.followedSince) : follower.bio}",
                            style: CustomText.regular12(AppColor.RedColor),
                          ),
                        ),
                        Divider(
                          color: AppColor.LightGrayColor,
                          height: 0.5,
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

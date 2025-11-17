// ignore_for_file: use_super_parameters

import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/utills/color.dart';
import '../controllers/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        title: Text(
          'Settings',
          style: CustomText.semiBold18(const Color(0xff22212F)),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 6, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            AnimatedSettingTile(
              label: "Edit Profile",
              onTap: () async {
                final result = await Get.toNamed("/editprofile");
                if (result == true) {
                  profileController.fetchUserData();
                }
              },
            ),
            // AnimatedSettingTile(
            //   label: "My Poll",
            //   onTap: () {
            //     Get.toNamed("/mypoll");
            //   },
            // ),
            AnimatedSettingTile(
              label: "Logout",
              onTap: () {
                Get.defaultDialog(
                  title: "Logout",
                  middleText: "Are you sure you want to logout?",
                  textCancel: "Cancel",
                  textConfirm: "Logout",
                  confirmTextColor: Colors.white,
                  
                  onConfirm: () async {
                    await LocalStorageService.remove('cached_polls');
                    await LocalStorageService.remove('completed_polls');
                    await LocalStorageService.remove('token');
                    loginController.signOut();
                    Get.offAllNamed("/login");
                  },
                  onCancel: () {},
                );
              },
            ),
            AnimatedSettingTile(
              label: "Delete Account",
              onTap: () {
                Get.defaultDialog(
                  title: "Delete Account",
                  middleText: "Are you sure you want to delete account?",
                  textCancel: "Cancel",
                  textConfirm: "Delete Account",
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    await LocalStorageService.remove('token');
                    await LocalStorageService.remove('cached_polls');
                    await LocalStorageService.remove('completed_polls');
                    loginController.signOut();
                    Get.offAllNamed("/login");
                  },
                  onCancel: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedSettingTile extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const AnimatedSettingTile({Key? key, required this.label, this.onTap})
      : super(key: key);

  @override
  State<AnimatedSettingTile> createState() => _AnimatedSettingTileState();
}

class _AnimatedSettingTileState extends State<AnimatedSettingTile> {
  double scale = 1.0;

  void _onTapDown(_) => setState(() => scale = 0.92);
  void _onTapUp(_) => setState(() => scale = 1.0);
  void _onTapCancel() => setState(() => scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.WhiteColor,
            border: Border.all(width: 1, color: const Color(0xffEEEFF6)),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColor.SplashColor,
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              widget.label,
              style: CustomText.regular14(Color(0xff22212F)),
            ),
          ),
        ),
      ),
    );
  }
}

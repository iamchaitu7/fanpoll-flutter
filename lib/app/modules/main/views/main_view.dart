// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/color.dart';
import '../controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.WhiteColor,
      // body: Obx(() => mainController.pages[mainController.currentIndex.value]),
      body: Obx(() => mainController.currentPage),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CustomBottomNavigationBar(controller: controller),
        ),
      ),
      // floatingActionButton: ClipRRect(
      //   borderRadius: BorderRadius.circular(28),
      //   child: Container(
      //     width: 56,
      //     height: 56,
      //     color: AppColor.PrimaryColor,
      //     child: IconButton(
      //       icon: const Icon(Icons.add, size: 30, color: Colors.white),
      //       onPressed: () => controller.changeTabIndex(2),
      //     ),
      //   ),
      // ),
      floatingActionButton: Builder(builder: (context) {
        final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
        return Visibility(
          visible: !isKeyboardOpen,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 56,
              height: 56,
              color: AppColor.PrimaryColor,
              child: IconButton(
                icon: const Icon(Icons.add, size: 30, color: Colors.white),
                onPressed: () => Get.toNamed("createpoll"),
              ),
            ),
          ),
        );
      }),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final MainController controller;

  const CustomBottomNavigationBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          // color: AppColor.GreenColor,
          // borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Obx(
          () => BottomAppBar(
            color: AppColor.WhiteColor,
            elevation: 10,
            shape: CircularNotchedRectangle(inverted: false),
            notchMargin: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                // color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTabIcon(0),
                    buildTabIcon(1),
                    SizedBox(width: 40),
                    buildTabIcon(3),
                    buildTabIcon(4),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  //
  Widget buildTabIcon(int index) {
    String iconPath;

    switch (index) {
      case 0:
        iconPath = controller.currentIndex.value == 0
            ? AssetPath.ActHomeIcon
            : AssetPath.InActHomeIcon;
        break;
      case 1:
        iconPath = controller.currentIndex.value == 1
            ? AssetPath.ActSearchIcon
            : AssetPath.InActSearchIcon;
        break;
      case 3:
        iconPath = controller.currentIndex.value == 3
            ? AssetPath.ActNotificationIcon
            : AssetPath.InActNotificationIcon;
        break;
      case 4:
        iconPath = controller.currentIndex.value == 4
            ? AssetPath.ActPersonIcon
            : AssetPath.InActPerasonIcon;
        break;
      default:
        iconPath = AssetPath.InActHomeIcon;
    }

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => controller.changeTabIndex(index),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}

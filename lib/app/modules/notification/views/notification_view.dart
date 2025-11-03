// // ignore_for_file: deprecated_member_use

// import 'package:fan_poll/app/utills/image_path.dart';
// import '../controllers/notification_controller.dart';
// import 'package:fan_poll/app/utills/textsyles.dart';
// import 'package:fan_poll/app/utills/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NotificationView extends GetView<NotificationController> {
//   const NotificationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.WhiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.WhiteColor,
//         surfaceTintColor: AppColor.WhiteColor,
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 4),
//                   child: Image.asset(AssetPath.AppIcon, height: 24, width: 24),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Fan Poll World",
//                   style: TextStyle(
//                     color: AppColor.SecondryColor,
//                     fontSize: 18,
//                     fontFamily: "Poppins",
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: sampleNotifications.length,
//         itemBuilder: (context, index) {
//           final item = sampleNotifications[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (index != 0)
//                 Divider(
//                   color: AppColor.LightGrayColor,
//                   height: 0.5,
//                 ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 12, bottom: 12),
//                 child: RichText(
//                   text: TextSpan(
//                     style: CustomText.medium13(Colors.black.withOpacity(0.5)),
//                     children: [
//                       TextSpan(
//                         text: item.name,
//                         style: CustomText.medium14(AppColor.PrimaryColor),
//                       ),
//                       TextSpan(
//                         text: " ${item.title}",
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// // Sample model
// class NotificationItem {
//   final String name;
//   final String title;

//   NotificationItem(this.name, this.title);
// }

// // Sample data
// final List<NotificationItem> sampleNotifications = [
//   NotificationItem("Maureen Robel", "has voted on your poll."),
//   NotificationItem("Kim Bayer", "has commented on your poll."),
//   NotificationItem("Richard Runolfsson", "has commented on your poll. has commented on your poll has commented on your poll"),
//   NotificationItem("Jared Moen", "has voted on your poll."),
//   NotificationItem("Saul Windler", "has commented on your poll."),
//   NotificationItem("Viola Krajcik", "has voted on your poll."),
//   NotificationItem("Julian Gislason", "has commented on your poll."),
//   NotificationItem("Kenny Bins", "has voted on your poll."),
//   NotificationItem("Kay Wilkinson PhD", "has voted on your poll."),
//   NotificationItem("Miss Marc Harvey", "has commented on your poll."),
// ];
// views/notification_view.dart

// ignore_for_file: deprecated_member_use

import 'package:fan_poll/app/utills/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import '../controllers/notification_controller.dart';

// class NotificationView extends GetView<NotificationController> {
//   const NotificationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NotificationController());

//     return Scaffold(
//       backgroundColor: AppColor.WhiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.WhiteColor,
//         surfaceTintColor: AppColor.WhiteColor,
//         title: Row(
//           children: [
//             Image.asset(AssetPath.AppIcon, height: 24, width: 24),
//             const SizedBox(width: 8),
//             Text(
//               "Fan Poll World",
//               style: CustomText.semiBold18(AppColor.SecondryColor),
//             ),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: IconButton(
//               onPressed: () {
//                 Get.toNamed("/setting");
//               },
//               icon: SvgPicture.asset(
//                 AssetPath.Setting,
//                 height: 24,
//                 width: 24,
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.notifications.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refreshList,
//           child: controller.notifications.isEmpty
//                       ? ListView(
//                           children: const [
//                             SizedBox(
//                                 height:
//                                     200), 
//                             Center(
//                               child: Text(
//                                 "Notification list is empty ",
//                                 style:
//                                     TextStyle(fontSize: 18, color: Colors.grey),
//                               ),
//                             ),
//                           ],
//                         )
//                       :  ListView.builder(
//             controller: controller.scrollController,
//             itemCount: controller.notifications.length,
//             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 180),
//             itemBuilder: (context, index) {
//               final item = controller.notifications[index];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // if (index != 0)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       // mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(item.sender.avatar),
//                           radius: 20,
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: RichText(
//                             text: TextSpan(
//                               style: CustomText.light13(
//                                   Colors.black.withOpacity(0.5)),
//                               children: [
//                                 TextSpan(
//                                   text: item.sender.name,
//                                   style: CustomText.medium14(
//                                       AppColor.PrimaryColor),
//                                 ),
//                                 TextSpan(text: " ${item.message}"),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               Utils.formatNotificationTime(item.createdAt),
//                               style: CustomText.light10(AppColor.SecondryColor),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(color: AppColor.LightGrayColor, height: 0.5),
//                 ],
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }

// import 'package:fan_poll/app/utills/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:fan_poll/app/utills/textsyles.dart';
// import 'package:fan_poll/app/utills/color.dart';
// import 'package:fan_poll/app/utills/image_path.dart';
// import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        title: Row(
          children: [
            Image.asset(AssetPath.AppIcon, height: 24, width: 24),
            const SizedBox(width: 8),
            Text(
              "Fan Poll World",
              style: CustomText.semiBold18(AppColor.SecondryColor),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                Get.toNamed("/setting");
              },
              icon: SvgPicture.asset(
                AssetPath.Setting,
                height: 24,
                width: 24,
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshList,
          child: controller.notifications.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 200),
                    Center(
                      child: Text(
                        "Notification list is empty",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.notifications.length,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 50 + MediaQuery.of(context).padding.bottom),
                  itemBuilder: (context, index) {
                    final item = controller.notifications[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(item.sender.avatar),
                                radius: 20,
                              ),
                              const SizedBox(width: 12),

                              // Message + Time
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name + Message
                                    RichText(
                                      text: TextSpan(
                                        style: CustomText.light13(Colors.black
                                            .withOpacity(0.7)),
                                        children: [
                                          TextSpan(
                                            text: item.sender.name,
                                            style: CustomText.medium14(
                                                AppColor.PrimaryColor),
                                          ),
                                          TextSpan(text: " ${item.message}"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    // Time
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        Utils.formatNotificationTime(
                                            item.createdAt),
                                        style: CustomText.light10(
                                            AppColor.SecondryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                            height: 0.5, color: AppColor.LightGrayColor),
                      ],
                    );
                  },
                ),
        );
      }),
    );
  }
}

// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import 'package:get/get.dart';

import '../controllers/mypoll_controller.dart';

class MypollView extends GetView<MypollController> {
  const MypollView({super.key});
  List<Widget> get _pastPolls => List.generate(
        5,
        (index) => PollCard(
          pollId: index + 1, 
          title: "Past Poll #$index",
          description: "This is a past poll.",
          options: [
            PollOption(label: "A", percentage: 40, title: "Option A"),
            PollOption(label: "B", percentage: 20, title: "Option B"),
            PollOption(label: "C", percentage: 30, title: "Option C"),
            PollOption(label: "D", percentage: 10, title: "Option D"),
          ],
          date: "10 Apr, 2025",
          daysLeft: "Ended",
          likes: 250,
          comments: 45,
          isPast: true,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        title: Text(
          'My Poll',
          style: CustomText.semiBold18(const Color(0xff22212F)),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          ...(_pastPolls),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class PollOption {
  final String label;
  final int percentage;
  final bool isSelected;
  final String title;

  PollOption(
      {required this.label,
      required this.percentage,
      this.isSelected = false,
      required this.title});
}

class PollCard extends StatelessWidget {
  final String title;
  final String description;
  final List<PollOption> options;
  final String date;
  final String daysLeft;
  final int likes;
  final int comments;
  final bool isPast;
  final int? pollId;

  PollCard(
      {super.key,
      required this.title,
      required this.description,
      required this.options,
      required this.date,
      required this.daysLeft,
      required this.likes,
      required this.comments,
      required this.isPast,
      this.pollId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.WhiteColor,
        border: Border.all(width: 1, color: Color(0xffEEEFF6)),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: CustomText.semiBold14(Color(0xff22212F))),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.78,
              child: Text(description,
                  style: CustomText.regular14(Color(0x8022212F))),
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Color(0x80DDDDDD)),
            const SizedBox(height: 20),
            
            Column(
              children: List.generate(options.length, (index) {
                return _PollOptionTile(
                    option: options[index], isSelected: false);
              }),
            ),
            
            const SizedBox(height: 12),
            _buildPastFooter()
          ],
        ),
      ),
    );
  }

  Widget _buildPastFooter() {
      print("✅ Share triggered successfsfdsfdsully");
    return Row(
      
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date, style: CustomText.regular14(AppColor.PrimaryColor)),
        Row(children: [
          InkWell(
            onTap: () => CustomSnackbar.error("Error".tr,
                "This feature is currently unavailable. Please try again later."),
            child: Row(
              children: [
                SvgPicture.asset(AssetPath.Download, height: 24, width: 24),
                Text("Download", style: CustomText.medium14(Color(0x8022212F))),
              ],
            ),
          ),
          const SizedBox(width: 10),
           InkWell(
            onTap: () {
              print("✅ Share triggered successfully-111");
              final link = "https://fanpoll.app/poll/${pollId ?? 0}";
               try {
      Share.share("Check this poll! $link");
      print("✅ Share triggered successfully");
    } catch (e) {
      print("❌ Error while sharing: $e");
    }
            },
            child: Row(
              children: [
                SvgPicture.asset(AssetPath.Share, height: 24, width: 24),
                const SizedBox(width: 4),
                Text("Share",
                    style: CustomText.medium14(const Color(0x8022212F))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          
          SvgPicture.asset(AssetPath.LightDashboard, height: 24, width: 24),
          Text('$likes', style: CustomText.regular14(Color(0x8022212F))),
          const SizedBox(width: 10),
          SvgPicture.asset(AssetPath.LightComment, height: 24, width: 24),
          Text('$comments', style: CustomText.regular14(Color(0x8022212F))),
        ]),
      ],
    );
  }
}

class _PollOptionTile extends StatelessWidget {
  final PollOption option;
  final bool isSelected;

  const _PollOptionTile({required this.option, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.PrimaryColor : AppColor.WhiteColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isSelected ? AppColor.PrimaryColor : const Color(0x1A22212F),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? Colors.white : AppColor.PrimaryColor,
            child: Text(
              option.label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(option.title,
                          style: CustomText.regular14(
                              isSelected ? Colors.white : Color(0x8022212F))),
                      Text("${option.percentage}%",
                          style: CustomText.regular14(
                              isSelected ? Colors.white : Color(0x8022212F))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double fullWidth = constraints.maxWidth;
                      double filledWidth =
                          fullWidth * (option.percentage / 100);
                      return Stack(
                        children: [
                          Container(
                            height: 4,
                            width: fullWidth,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xff5C6DFF)
                                  : Color(0xffF9F9F9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Container(
                            height: 4,
                            width: filledWidth,
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.white : Color(0xffDADEFF),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

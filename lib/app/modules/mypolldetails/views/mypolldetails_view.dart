// ignore_for_file: unused_import

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/modules/home/controllers/home_controller.dart';
import 'package:fan_poll/app/modules/home/views/home_view.dart';
import 'package:fan_poll/app/modules/profile/controllers/profile_controller.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/utills/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../controllers/mypolldetails_controller.dart';

class MypolldetailsView extends StatefulWidget {
  final int pollId;
  final RxnInt selectedIndex;
  final RxnInt? option_id;
  final ScreenshotController screenshotController;

  const MypolldetailsView({
    super.key,
    required this.pollId,
    required this.selectedIndex,
    this.option_id,
    required this.screenshotController,
  });

  @override
  State<MypolldetailsView> createState() => _MypolldetailsViewState();
}

class _MypolldetailsViewState extends State<MypolldetailsView> {
  final controller = Get.find<MypolldetailsController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex.value == null) {
      final votedIndex = controller.poll.value?.options?.indexWhere((o) => o.isVoted ?? false);
      if (votedIndex != -1) {
        final optionId = controller.poll.value?.options?[votedIndex!].id;
        widget.selectedIndex.value = votedIndex;
        widget.option_id?.value = optionId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'My Poll Details',
            style: CustomText.semiBold18(const Color(0xff22212F)),
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.poll.value == null) {
                return const Center(child: Text("Poll not found."));
              }

              final poll = controller.poll.value!;
              return PollCard(
                key: ValueKey(poll.id),
                creator: poll.creator ?? Creator(),
                poll_id: poll.id ?? 0,
                title: poll.title ?? "",
                description: poll.description ?? "",
                hashtags: poll.hashtags ?? "",
                websiteUrl: poll.url ?? "",
                imageUrl: poll.imageUrl ?? "",
                isLiked: poll.isLiked ?? false,
                options: poll.options?.map((e) {
                      print("E OPTIONS = ${e}");

                      return PollOption(
                        label: String.fromCharCode(65 + (e.order ?? 0)),
                        text: e.text ?? "",
                        percentage: e.percentage?.toDouble() ?? 0.0,
                        is_voted: e.isVoted ?? false,
                        vote_count: e.voteCount ?? 0,
                        id: e.id ?? 0,
                      );
                    }).toList() ??
                    [],
                onUpdateOption: () {
                  controller.fetchPollDetails(isHideLoading: true);
                },
                date: Utils.formatDate(poll.createdAt ?? ""),
                daysLeft: Utils.calculateDaysLeft(poll.expiresAt ?? ""),
                likes: poll.totalVotes ?? 0,
                comments: poll.commentsCount ?? 0,
                isPast: poll.isExpired ?? false,
                can_vote: poll.canVote ?? true,
                is_own_poll: poll.isOwnPoll ?? false,
                onDelete: () async {
                  print("Deleting poll and popping with true");
                  Navigator.of(context).pop(true);
                },
                onLike: () {
                  controller.likePoll(poll.id);
                },
                likesCount: poll.likesCount ?? 0,
              );
            }),
          ],
        ),
      ),
    );
  }
}

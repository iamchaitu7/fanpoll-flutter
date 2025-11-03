import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/modules/home/views/home_view.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/utills/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart' as search_controller;

class SearchView extends GetView<search_controller.SearchController> {
  final String searchParam;
  final String hashtagParam;
  const SearchView({super.key, required this.searchParam, required this.hashtagParam});

  @override
  Widget build(BuildContext context) {
    print("search PAram::$hashtagParam");

    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Image.asset(AssetPath.AppIcon, height: 24, width: 24),
              const SizedBox(width: 8),
              Text(
                "Fan Poll World",
                style: CustomText.semiBold18(AppColor.SecondryColor),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
        ),
      ),
      body: Column(
        children: [
          // Search header showing current search
          if (searchParam.isNotEmpty || hashtagParam.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColor.PrimaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      searchParam.isNotEmpty ? 'Searching for: "$searchParam"' : 'Hashtag: "$hashtagParam"',
                      style: CustomText.regular14(AppColor.SecondryColor),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.searchResults.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchResults.isEmpty) {
                return const Center(
                  child: Text(
                    'No polls found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshSearch,
                child: ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.searchResults.length + 1,
                  padding: EdgeInsets.only(bottom: 50 + MediaQuery.of(context).padding.bottom),
                  itemBuilder: (context, index) {
                    if (index < controller.searchResults.length) {
                      final poll = controller.searchResults[index];

                      print("SEARCH TEXT WORKING");

                      return PollCard(
                        key: ValueKey(poll.id),
                        creator: poll.creator ?? Creator(),
                        poll_id: poll.id ?? 0,
                        title: poll.title ?? "",
                        description: poll.description ?? "",
                        hashtags: poll.hashtags ?? "",
                        websiteUrl: poll.url ?? "",
                        imageUrl: poll.imageUrl ?? "",
                        options: poll.options?.map((e) {
                              return PollOption(
                                  label: String.fromCharCode(65 + (e.order ?? 0)),
                                  text: e.text ?? "",
                                  percentage: e.percentage?.toDouble() ?? 0,
                                  is_voted: e.isVoted ?? false,
                                  vote_count: (e.voteCount ?? 0).toInt(),
                                  id: e.id ?? 0);
                            }).toList() ??
                            [],
                        date: Utils.formatDate(poll.createdAt ?? ""),
                        daysLeft: Utils.calculateDaysLeft(poll.expiresAt ?? ""),
                        likes: poll.totalVotes ?? 0,
                        comments: poll.commentsCount ?? 0,
                        isPast: poll.isExpired ?? false,
                        can_vote: poll.canVote ?? true,
                        is_own_poll: poll.isOwnPoll ?? false,
                        isLiked: poll.isLiked ?? false,
                        onLike: () {
                          controller.likePoll(poll.id);
                        },
                        likesCount: poll.likesCount ?? 0,
                      );
                    } else if (controller.hasMoreResults.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

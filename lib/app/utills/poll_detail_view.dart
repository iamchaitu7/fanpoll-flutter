// modules/poll_detail/views/poll_detail_view.dart
import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/modules/home/views/home_view.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fan_poll/app/modules/home/controllers/home_controller.dart';

class PollDetailView extends StatelessWidget {
  final int pollId;
  final bool isGuest;

  const PollDetailView({super.key, required this.pollId, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Poll Details"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<PollModel?>(
        future: homeController.fetchPollById(pollId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Poll not found"));
          }
          
          final poll = snapshot.data!;
          final isPollActive = !(poll.isExpired ?? true);
          
          // Use your existing PollCard but with guest mode support
          return PollCard(
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
                      percentage: e.percentage!.toDouble(),
                      is_voted: e.isVoted ?? false,
                      vote_count: e.voteCount ?? 0,
                      id: e.id ?? 0);
                }).toList() ?? [],
            date: "Today", // Use your date formatting
            daysLeft: "5 days", // Use your days calculation
            likes: poll.totalVotes ?? 0,
            comments: poll.commentsCount ?? 0,
            isPast: !isPollActive,
            can_vote: isPollActive && !isGuest && (poll.canVote ?? true),
            is_own_poll: poll.isOwnPoll ?? false,
            isLiked: poll.isLiked ?? false,
            onLike: () {
              if (isGuest) {
                CustomSnackbar.error("Login Required", "Please login to like polls");
                return;
              }
              // Call your like method
            },
            likesCount: poll.likesCount ?? 0,
            isGuest: isGuest, // ADD THIS
          );
        },
      ),
    );
  }
}
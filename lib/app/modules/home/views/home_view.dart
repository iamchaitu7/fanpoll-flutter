// ignore_for_file: unnecessary_import, must_be_immutable, avoid_unnecessary_containers, deprecated_member_use, unused_element, prefer_interpolation_to_compose_strings, unused_import, unnecessary_null_comparison, non_constant_identifier_names, avoid_print
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/modules/comment/views/comment_view.dart';
import 'package:fan_poll/app/modules/home/controllers/home_controller.dart';
import 'package:fan_poll/app/routes/app_pages.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/utills/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  int selectedTabIndex = 0;
  late AnimationController _controller;
  late Animation<double> _indicatorPosition;
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _indicatorPosition = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void _changeTab(int index) {
    setState(() {
      selectedTabIndex = index;
      _indicatorPosition = Tween<double>(
        begin: _indicatorPosition.value,
        end: index.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    });
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _changeTab(index),
      child: Container(
        width: 82,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.SecondryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColor.WhiteColor : AppColor.SecondryColor.withOpacity(0.8),
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.WhiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.WhiteColor,
          surfaceTintColor: AppColor.WhiteColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Image.asset(AssetPath.AppIcon, height: 24, width: 24),
                  ),
                  const SizedBox(width: 8),
                  Text("Fan Poll World",
                      style: const TextStyle(color: AppColor.SecondryColor, fontSize: 18, fontFamily: "Poppins", fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColor.WhiteColor /* AppColor.WhiteColor */,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTab("Current", 0),
                  _buildTab("Past", 1),
                ],
              ),
            ),
          ],
        ),
        body: selectedTabIndex == 0
            ? Obx(() => RefreshIndicator(
                  onRefresh: homeController.refreshPolls,
                  child: homeController.currentPolls.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 200),
                            Center(
                              child: Text(
                                "No Current  Polls",
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: homeController.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 50 + MediaQuery.of(context).padding.bottom),
                          itemCount: homeController.currentPolls.length + 1,
                          itemBuilder: (context, index) {
                            if (index < homeController.currentPolls.length) {
                              final poll = homeController.currentPolls[index];
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
                                          percentage: e.percentage!.toDouble(),
                                          is_voted: e.isVoted ?? false,
                                          vote_count: e.voteCount ?? 0,
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
                                  homeController.likePoll(poll.id);
                                },
                                likesCount: poll.likesCount ?? 0,
                              );
                            } else if (homeController.hasMorePolls) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                ))
            : Obx(() => RefreshIndicator(
                  onRefresh: homeController.refreshCompleltedPolls,
                  child: homeController.pastPolls.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 200),
                            Center(
                              child: Text(
                                "No Past Polls",
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: homeController.completedPollsScrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 50 + MediaQuery.of(context).padding.bottom),
                          itemCount: homeController.pastPolls.length + 1,
                          itemBuilder: (context, index) {
                            if (index < homeController.pastPolls.length) {
                              final poll = homeController.pastPolls[index];
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
                                          percentage: e.percentage!.toDouble(),
                                          is_voted: e.isVoted ?? false,
                                          vote_count: e.voteCount ?? 0,
                                          id: e.id ?? 0);
                                    }).toList() ??
                                    [],
                                date: Utils.formatDate(poll.createdAt ?? ""),
                                daysLeft: Utils.calculateDaysLeft(poll.expiresAt ?? ""),
                                likes: poll.totalVotes ?? 0,
                                comments: poll.commentsCount ?? 0,
                                isPast: true,
                                can_vote: poll.canVote ?? true,
                                is_own_poll: poll.isOwnPoll ?? false,
                                isLiked: poll.isLiked ?? false,
                                onLike: () {
                                  homeController.likePoll(poll.id, isPastPoll: true);
                                },
                                likesCount: poll.likesCount ?? 0,
                              );
                            } else if (homeController.hasMoreCompletedPolls) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PollOption {
  final String text;
  final String label;
  final int id;
  final int vote_count;
  final double percentage;
  final bool is_voted;

  PollOption({required this.text, required this.percentage, required this.is_voted, required this.label, required this.vote_count, required this.id});
}

class PollCard extends StatefulWidget {
  final Creator creator;
  final String title;
  final String description;
  final List<PollOption> options;
  final String date;
  final String daysLeft;
  final String hashtags;
  final String websiteUrl;
  final String imageUrl;
  final bool isLiked;
  final int likes;
  final int likesCount;
  final int comments;
  final int poll_id;
  final bool isPast;
  final bool can_vote;
  final bool is_own_poll;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdateOption;
  final VoidCallback? onComment;
  final VoidCallback? onFollow;

  const PollCard({
    super.key,
    required this.creator,
    required this.title,
    required this.description,
    required this.options,
    required this.date,
    required this.daysLeft,
    required this.likes,
    required this.comments,
    required this.poll_id,
    required this.hashtags,
    required this.websiteUrl,
    required this.imageUrl,
    required this.can_vote,
    required this.isPast,
    required this.is_own_poll,
    this.onDelete,
    this.onUpdateOption,
    required this.isLiked,
    required this.onLike,
    required this.likesCount,
    this.onComment,
    this.onFollow,
  });

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  final RxnInt selectedIndex = RxnInt();
  late RxInt likes;
  late RxInt likesCount;
  late RxInt comments;
  final RxnInt poll_id = RxnInt();
  final RxnInt option_id = RxnInt();
  final ScreenshotController screenshotController = ScreenshotController();
  String selectedTag = ""; // maintain this in your state
  List<String> tags = [];
  @override
  void initState() {
    super.initState();
    likes = widget.likes.obs;
    likesCount = widget.likesCount.obs;
    comments = widget.comments.obs;

    if (selectedIndex.value == null) {
      final votedIndex = widget.options.indexWhere((o) => o.is_voted);
      if (votedIndex != -1) {
        final optionId = widget.options[votedIndex].id;
        selectedIndex.value = votedIndex;
        option_id.value = optionId;
        poll_id.value = widget.poll_id;
      }
    }
    if (widget.hashtags.isNotEmpty) {
      selectedTag = ""; // maintain this in your state
      tags = widget.hashtags.split(',').map((e) => e.trim()).toList();
    }
  }

  void selectOption(int index) {
    selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.WhiteColor,
        border: Border.all(width: 1, color: const Color(0xffEEEFF6)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(54.h / 2), // half of height for circle
                          child: widget.creator.avatar == null || widget.creator.avatar!.isEmpty
                              ? Image.asset(
                                  AssetPath.Person,
                                  height: 48.h,
                                  width: 48.h,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.creator.avatar!,
                                  height: 48.h,
                                  width: 48.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Text(
                        widget.creator.name ?? "",
                        style: CustomText.semiBold14(AppColor.SecondryColor),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 8,
                        ),
                      ),
                      // Obx(()=>{})
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: widget.is_own_poll
                            ? IconButton(
                                icon: Icon(Icons.delete, color: AppColor.RedColor, size: 20),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Delete Poll"),
                                      content: Text("Are you sure you want to delete this poll?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () => Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: Text("Delete"),
                                          onPressed: () => Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    homeController.removePollFromLocalStorage(widget.poll_id);
                                    profileController.fetchPolls(refresh: true);
                                    if (widget.onDelete != null) {
                                      widget.onDelete!();
                                    }
                                  }
                                },
                              )
                            : TextButton(
                                onPressed: () async {
                                  if (widget.onFollow != null) {
                                    widget.onFollow!();
                                    return;
                                  }
                                  if (widget.creator.isFollowing ?? false) {
                                    await homeController.onUnFollow(widget.creator.id ?? 0);
                                    setState(() {
                                      widget.creator.isFollowing = false;
                                    });
                                  } else {
                                    homeController.onFollow(widget.creator.id ?? 0);
                                    setState(() {
                                      widget.creator.isFollowing = true;
                                    });
                                  }
                                },
                                child: Text(
                                  (widget.creator.isFollowing ?? false) ? "Unfollow" : "+ Follow",
                                  style: CustomText.semiBold12(AppColor.PrimaryColor),
                                ),
                              ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(widget.title, style: CustomText.semiBold14(AppColor.SecondryColor)),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.78,
                          child: Linkify(
                            text: widget.description,
                            style: CustomText.regular14(AppColor.SecondryColor),
                            onOpen: (link) async {
                              String url = 'https://${link.url}';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                print("REDIRECT URL  : ${url}");
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              } else {
                                // Handle error
                              }
                            },
                            options: LinkifyOptions(humanize: false, looseUrl: true),
                          ),
                        ),
                        tags.isNotEmpty ? const SizedBox(height: 12) : const SizedBox.shrink(),
                        tags.isNotEmpty
                            ? Container(
                                alignment: Alignment.centerLeft,
                                child: ChipsChoice<String>.single(
                                  value: selectedTag,
                                  padding: EdgeInsets.zero,
                                  onChanged: (val) {
                                    setState(() => selectedTag = val);
                                    Get.toNamed(
                                      "/search",
                                      arguments: {"hashtag": val, "search": ""},
                                    );
                                  },
                                  choiceItems: C2Choice.listFrom<String, String>(
                                    source: tags,
                                    value: (index, item) => item,
                                    label: (index, item) => "#$item", // prefix with #
                                    tooltip: (index, item) => item,
                                  ),
                                  choiceCheckmark: false,
                                  choiceStyle: C2ChipStyle.filled(
                                    borderRadius: const BorderRadius.all(Radius.circular(25)), // capsule shape
                                    color: AppColor.chipColor,
                                    foregroundStyle: CustomText.semiBold12(
                                      AppColor.SecondryColor.withOpacity(0.5),
                                    ),
                                    selectedStyle: const C2ChipStyle(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        widget.websiteUrl.isNotEmpty ? SizedBox(height: 6) : const SizedBox.shrink(),
                        widget.websiteUrl.isNotEmpty
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.websiteUrl,
                                      style: CustomText.regular12(
                                        AppColor.SecondryColor.withOpacity(0.8),
                                        isUnderline: true,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          var normURL = normalizeUrl(widget.websiteUrl);
                                          final Uri url = Uri.parse(normURL);
                                          print("URL REDIRECT CHECK : ${url}");
                                          //if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                          // } else {
                                          //   CustomSnackbar.error("Could not launch", widget.websiteUrl);
                                          // }
                                        },
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 8,
                        ),
                        widget.imageUrl == null || widget.imageUrl.isEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 329 / 230,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => FullScreenImageView(
                                              imageUrl: widget.imageUrl,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        widget.imageUrl,
                                        height: 230,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        widget.imageUrl == null || widget.imageUrl.isEmpty ? SizedBox.shrink() : const SizedBox(height: 14),
                        Container(height: 1, color: AppColor.LightGrayColor),
                        const SizedBox(height: 14),
                        widget.isPast
                            ? Column(
                                children: List.generate(widget.options.length, (index) {
                                  return _PollOptionTile(
                                    option: widget.options[index],
                                    isSelected: true,
                                    isPast: true,
                                  );
                                }),
                              )
                            : Obx(() {
                                return Column(children: [
                                  ...List.generate(widget.options.length, (index) {
                                    final isSelected = selectedIndex.value == index;
                                    return GestureDetector(
                                      onTap: () async {
                                        if (selectedIndex.value == null) {
                                          selectOption(index);
                                          poll_id.value = widget.poll_id;
                                          option_id.value = widget.options[index].id;
                                          try {
                                            final response = await homeController.api.postVoteFormData(
                                              poll_id: widget.poll_id.toString(),
                                              option_id: widget.options[index].id.toString(),
                                            );
                                            if (response['status'] == 200) {
                                              homeController.updatePollAfterVote(
                                                  PollModel.fromJson(response['poll']), widget.poll_id, widget.options[index].id);
                                              likes.value = response['poll']['total_votes'];
                                              if (widget.onUpdateOption != null) {
                                                widget.onUpdateOption!();
                                              }
                                            }
                                          } catch (e) {
                                            print("Vote Error: $e");
                                          }
                                        }
                                      },
                                      child: selectedIndex.value == null
                                          ? _NotSelectedPollOptionTile(
                                              option: widget.options[index],
                                              isSelected: false,
                                            )
                                          : _PollOptionTile(
                                              option: widget.options[index],
                                              isSelected: isSelected,
                                              isPast: false,
                                            ),
                                    );
                                  }),
                                  if (selectedIndex.value != null)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          selectedIndex.value = null;
                                          try {
                                            final response = await homeController.api.postUndoVoteFormData(
                                              poll_id: poll_id.value.toString(),
                                            );
                                            if (response['status'] == 200) {
                                              homeController.updatePollAfterUndoVote(
                                                  PollModel.fromJson(response['poll']), poll_id.value!, option_id.value!);
                                              likes.value = response['poll']['total_votes'];
                                            }
                                            if (widget.onUpdateOption != null) {
                                              widget.onUpdateOption!();
                                            }
                                          } catch (e) {
                                            print("Undo Vote Error: $e");
                                          }
                                        },
                                        child: Text(
                                          "Undo Vote",
                                          style: CustomText.semiBold12(AppColor.PrimaryColor),
                                        ),
                                      ),
                                    )
                                ]);
                              }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          widget.isPast
              ? _buildPastFooter(
                  date: widget.date,
                  daysLeft: widget.daysLeft,
                  likes: likes.value,
                  comments: comments.value,
                  poll_id: widget.poll_id,
                  onDownload: () => Utils().captureAndGeneratePDF(screenshotController, widget.poll_id.toString()),
                  likesCount: widget.likesCount,
                )
              : Obx(
                  () => _buildActiveFooter(
                    date: widget.date,
                    daysLeft: widget.daysLeft,
                    likes: likes.value,
                    comments: comments.value,
                    poll_id: widget.poll_id,
                    isLiked: widget.isLiked,
                    likesCount: widget.likesCount,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPastFooter({
  required String date,
  required String daysLeft,
  required int likes,
  required int likesCount,
  required int comments,
  required int poll_id,
  required void Function() onDownload,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 0, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date, style: CustomText.regular12(AppColor.PrimaryColor)),
            Text(daysLeft, style: CustomText.regular12(AppColor.SecondryColor.withOpacity(0.5))),
          ],
        ),
      ),
      Container(height: 1, color: AppColor.LightGrayColor),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              if (widget.onLike != null) {
                widget.onLike!();
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(widget.isLiked ? AssetPath.icLikeSelected : AssetPath.icLike, height: 24, width: 24),
                Text('$likesCount', style: CustomText.regular14(widget.isLiked ? AppColor.PrimaryColor : AppColor.SecondryColor.withOpacity(0.8))),
              ],
            ),
          ),
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          InkWell(
            onTap: () {
              if (widget.onComment != null) {
                widget.onComment!();
              } else {
                Get.toNamed(
                  "/comment",
                  arguments: {"poll_id": poll_id},
                );
              }
            },
            child: Row(
              children: [
                SvgPicture.string(
                  '''<svg viewBox="0 0 24 24" 
  xmlns="http://www.w3.org/2000/svg"
  fill="black">
  <path d="M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z"/>
</svg>''',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  '$comments',
                  style: CustomText.regular14(AppColor.SecondryColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          Row(
            children: [
              SvgPicture.asset(AssetPath.LightDashboard, height: 24, width: 24),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: CustomText.regular14(AppColor.SecondryColor.withOpacity(0.8)),
              ),
            ],
          ),
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          InkWell(
            onTap: onDownload,
            child: Row(
              children: [
                SvgPicture.asset(AssetPath.Download, height: 24, width: 24),
                const SizedBox(width: 4),
                Text(
                  "Download",
                  style: CustomText.medium14(AppColor.SecondryColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          // Add Share Button at the end
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          InkWell(
            onTap: () {
              final link = "https://fanpollworld.com/share/poll/${widget.poll_id}";
              try {
                Share.share("Check this poll! $link");
              } catch (e) {
                print("Error while sharing: $e");
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(AssetPath.Share, height: 24, width: 24),
                const SizedBox(width: 4),
                Text(
                  "Share",
                  style: CustomText.medium14(AppColor.SecondryColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildActiveFooter({
  required String date,
  required String daysLeft,
  required bool isLiked,
  required int likes,
  required int likesCount,
  required int comments,
  required int poll_id,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 0, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date, style: CustomText.regular12(AppColor.PrimaryColor)),
            Text(daysLeft, style: CustomText.regular12(AppColor.SecondryColor.withOpacity(0.5))),
          ],
        ),
      ),
      Container(height: 1, color: AppColor.LightGrayColor),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              if (widget.onLike != null) {
                widget.onLike!();
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(widget.isLiked ? AssetPath.icLikeSelected : AssetPath.icLike, height: 24, width: 24),
                Text('$likesCount', style: CustomText.regular14(widget.isLiked ? AppColor.PrimaryColor : AppColor.SecondryColor.withOpacity(0.8))),
              ],
            ),
          ),
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          InkWell(
            onTap: () {
              if (widget.onComment != null) {
                widget.onComment!();
              } else {
                Get.toNamed(
                  "/comment",
                  arguments: {"poll_id": poll_id},
                );
              }
            },
            child: Row(
              children: [
                SvgPicture.string(
                  '''<svg viewBox="0 0 24 24" 
  xmlns="http://www.w3.org/2000/svg"
  fill="black">
  <path d="M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z"/>
</svg>''',
                  width: 24,
                  height: 24,
                ),
                Text('$comments', style: CustomText.regular14(AppColor.SecondryColor.withOpacity(0.8))),
              ],
            ),
          ),
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          Row(
            children: [
              SvgPicture.asset(AssetPath.Dashboard, height: 24, width: 24),
              Text('$likes', style: CustomText.regular14(AppColor.SecondryColor.withOpacity(0.8))),
            ],
          ),
          // Add Share Button at the end
          Container(height: 61, width: 1, color: AppColor.LightGrayColor),
          InkWell(
            onTap: () {
              final link = "https://fanpollworld.com/share/poll/${widget.poll_id}";
              try {
                Share.share("Check this poll! $link");
              } catch (e) {
                print("Error while sharing: $e");
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(AssetPath.Share, height: 24, width: 24),
                const SizedBox(width: 4),
                Text(
                  "Share",
                  style: CustomText.medium14(AppColor.SecondryColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
}

class _NotSelectedPollOptionTile extends StatelessWidget {
  final PollOption option;
  final bool isSelected;

  const _NotSelectedPollOptionTile({required this.option, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.WhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.PrimaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double fullWidth = constraints.maxWidth;
          double filledWidth = fullWidth * (option.percentage / 100);

          return IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  width: filledWidth,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.PrimaryColor : AppColor.WhiteColor,
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: isSelected
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                option.text,
                                style: CustomText.regular14(AppColor.WhiteColor),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Text("${option.percentage}%", style: CustomText.regular14(AppColor.WhiteColor)),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(option.text,
                                    softWrap: true,
                                    // maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: CustomText.regular14(AppColor.PrimaryColor)),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PollOptionTile extends StatelessWidget {
  final PollOption option;
  final bool isSelected;
  final bool isPast;

  const _PollOptionTile({required this.option, required this.isSelected, required this.isPast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.WhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.PrimaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double fullWidth = constraints.maxWidth;
          double filledWidth = fullWidth * (option.percentage / 100);

          return IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  width: filledWidth,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? isPast
                            ? const Color(0xffF1F2FF)
                            : AppColor.PrimaryColor.withOpacity(0.3)
                        : AppColor.deSelectColor,
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                // Foreground: Row with wrapped text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          option.text,
                          softWrap: true,
                          // maxLines: 1,
                          overflow: TextOverflow.visible,
                          style: CustomText.regular14(
                            isPast ? AppColor.PrimaryColor : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${option.percentage}%",
                        style: CustomText.regular14(
                          isPast ? AppColor.PrimaryColor : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        enableRotation: false,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}

String normalizeUrl(String url) {
  if (!url.startsWith(RegExp(r'https?://'))) {
    return 'https://$url';
  }
  return url;
}
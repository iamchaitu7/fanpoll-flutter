// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import '../controllers/comment_controller.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
class CommentView extends GetView<CommentController> {
  final int pollId;
  const CommentView({Key? key, required this.pollId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        title: Text('Comments', style: CustomText.semiBold18(AppColor.SecondryColor)),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AssetPath.BackArrow),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => RefreshIndicator(
                  onRefresh: controller.refreshComments,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.symmetric(horizontal:  16),
                    itemCount: controller.comments.length + (controller.hasNextPage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && controller.hasNextPage) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox.shrink(),
                          ),
                        );
                      }

                      final comment = controller.comments[index - (controller.hasNextPage ? 1 : 0)];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(comment.userName,
                                  style: CustomText.semiBold14(AppColor.PrimaryColor)),
                              Text(controller.getTimeAgo(comment.createdAt),
                                  style: CustomText.medium12(AppColor.SecondryColor.withOpacity(0.4))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(comment.comment,
                              style: CustomText.light13(AppColor.SecondryColor.withOpacity(0.6))),
                          const SizedBox(height: 12),
                          Divider(color: AppColor.LightGrayColor),
                        ],
                      );
                    },
                  ),
                )),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: AppColor.PrimaryColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              onSubmitted: (_) => controller.addComment(),
              textInputAction: TextInputAction.send,
              cursorColor: AppColor.PrimaryColor,
              decoration: const InputDecoration(
                hintText: "Type comment...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(AssetPath.Send, height: 24, width: 24),
            onPressed: controller.addComment,
          )
        ],
      ),
    );
  }
}

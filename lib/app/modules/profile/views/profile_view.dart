// ignore_for_file: unused_local_variable, deprecated_member_use, sized_box_for_whitespace, await_only_futures
import 'package:fan_poll/app/modules/login/controllers/login_controller.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());
  final LoginController loginController = Get.put(LoginController());
  final ScrollController scrollController = ScrollController();
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        scrollOffset = scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double get fadeValue {
    if (scrollOffset <= 0) return 1.0;
    if (scrollOffset >= 100) return 0.0;
    return 1.0 - scrollOffset / 100;
  }

  @override
  Widget build(BuildContext context) {
    print("profileController.polls :: ${profileController.polls.toString()}");
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Image.asset(AssetPath.AppIcon, height: 24, width: 24),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Fan Poll World",
                  style: TextStyle(
                    color: AppColor.SecondryColor,
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () async {
                final result = await Get.toNamed("/setting");
                if (result == true) {
                  await profileController.fetchUserData();
                }
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
      body: RefreshIndicator(
        onRefresh: () async {
          await profileController.fetchUserData();
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColor.WhiteColor,
              pinned: false,
              expandedHeight: 170,
              flexibleSpace: FlexibleSpaceBar(
                background: Obx(() {
                  final imageUrl = profileController.user.value?.profilePicture ?? '';
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        if (imageUrl.isNotEmpty) {
                          Get.to(() => FullScreenImageView(imageUrl: imageUrl));
                        }
                      },
                      child: imageUrl.isNotEmpty
                          ? SizedBox(
                              width: 150,
                              height: 150,
                              child: ClipOval(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 65.r,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: AssetImage(AssetPath.UserImage) as ImageProvider,
                            ),
                    ),
                  );
                }),
              ),
            ),

            // Profile Details that fade out
            SliverToBoxAdapter(
              child: AnimatedOpacity(
                opacity: fadeValue,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Obx(() => Text(
                          profileController.user.value?.fullName ?? '',
                          style: CustomText.bold14(AppColor.SecondryColor),
                        )),
                    Obx(() => Text(
                          profileController.user.value?.email ?? '',
                          style: CustomText.regular14(AppColor.SecondryColor),
                        )),
                    SizedBox(
                      height: 14,
                    ),
                    Container(height: 1, color: AppColor.LightGrayColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => {Get.toNamed("/followers")},
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Followers",
                                style: CustomText.regular14(AppColor.SecondryColor),
                              ),
                              Obx(() => Text(
                                    profileController.user.value?.followersCount.toString() ?? '',
                                    style: CustomText.bold24(AppColor.SecondryColor),
                                  )),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Container(height: 85, width: 1, color: AppColor.LightGrayColor),
                        GestureDetector(
                          onTap: () => {Get.toNamed("/following")},
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Following",
                                style: CustomText.regular14(AppColor.SecondryColor),
                              ),
                              Obx(() => Text(
                                    profileController.user.value?.followingCount.toString() ?? '',
                                    style: CustomText.bold24(AppColor.SecondryColor),
                                  )),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(height: 1, color: AppColor.LightGrayColor),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),

            // Poll List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Polls", style: CustomText.bold14(AppColor.SecondryColor)),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (!profileController.isDataLoaded.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (profileController.polls.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text("No polls found."),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: profileController.polls.length,
                    itemBuilder: (context, index) {
                      final poll = profileController.polls[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InkWell(
                          onTap: () async {
                            final pollId = int.tryParse(poll.id.toString()) ?? 0;
                            print("POLL :: $pollId");

                            final result = Get.toNamed('/mypolldetails', arguments: {"poll_id": pollId});
                            if (result == true) {
                              await profileController.fetchPolls(refresh: true);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                poll.title,
                                style: CustomText.semiBold14(AppColor.SecondryColor),
                              ),
                              Text(
                                poll.description,
                                style: CustomText.regular14(AppColor.SecondryColor.withOpacity(0.5)),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: AppColor.LightGrayColor, height: 0.5),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
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

import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/search_tab_controller.dart';

class SearchTabView extends GetView<SearchTabController> {
  const SearchTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchTabController());
    final RxString searchText = ''.obs;

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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Center content
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Color(0xFF22212F).withOpacity(0.5), width: 0.5)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Color(0xFF22212F).withOpacity(0.5), width: 0.5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Color(0xFF22212F).withOpacity(0.5), width: 0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Color(0xFF22212F).withOpacity(0.5), width: 0.5)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: SvgPicture.asset(AssetPath.Search, height: 24, width: 24),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                controller: controller.searchController,
                onChanged: (value) => searchText.value = value,
                onSubmitted: (value) {
                  // if (value.trim().isNotEmpty) {
                  //   Get.toNamed(
                  //     "/search",
                  //     arguments: {"search": value.trim()},
                  //   );
                  // }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              "/search",
                              arguments: {"hashtag": "", "search": controller.searchController.text.trim()},
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(poll.title ?? "", style: CustomText.regular14(AppColor.SecondryColor)),
                              ),
                              Container(height: 1, color: AppColor.LightGrayColor),
                            ],
                          ),
                        ),
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

// ignore_for_file: duplicate_import, unnecessary_brace_in_string_interps, use_key_in_widget_constructors, deprecated_member_use, avoid_print, library_private_types_in_public_api
import 'package:dotted_border/dotted_border.dart';
import 'package:fan_poll/app/modules/home/controllers/home_controller.dart';
import 'package:fan_poll/app/modules/main/controllers/main_controller.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/widget/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../controllers/createpoll_controller.dart';

class CreatepollView extends GetView<CreatepollController> {
  CreatepollView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // ⬅ Hides the keyboard
      },
      child: Scaffold(
        backgroundColor: AppColor.WhiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.WhiteColor,
          surfaceTintColor: AppColor.WhiteColor,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Create Poll',
              style: CustomText.semiBold18(const Color(0xff22212F)),
            ),
          ),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
          ),
        ),
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add this after the app bar in your build method
                  _buildTemplateSelection(),
                  const SizedBox(height: 20),
                  // Poll Question Section
                  _buildSectionHeader("Poll Question"),
                  const SizedBox(height: 10),
                  _buildPollQuestionField(),
                  const SizedBox(height: 20),
                  
                  // Description Section
                  _buildSectionHeader("Description", optional: true),
                  const SizedBox(height: 10),
                  _buildDescriptionField(),
                  const SizedBox(height: 20),
                  
                  // Tags Section
                  _buildSectionHeader("Tags"),
                  const SizedBox(height: 10),
                  HashtagsWidget(controller: controller.hashtagsChipController),
                  const SizedBox(height: 20),
                  
                  // Add Media Section
                  _buildSectionHeader("Add Media", optional: true),
                  const SizedBox(height: 10),
                  _buildMediaSection(),
                  const SizedBox(height: 20),
                  
                  // Source Link Section
                  _buildSectionHeader("Source Link", optional: true),
                  const SizedBox(height: 10),
                  _buildSourceLinkField(),
                  const SizedBox(height: 20),
                  
                  // Poll Options Section
                  _buildSectionHeader("Poll Options"),
                  const SizedBox(height: 10),
                  _buildPollOptions(),
                  const SizedBox(height: 20),
                  
                  // Poll Settings Section
                  _buildSectionHeader("Poll Settings"),
                  const SizedBox(height: 10),
                  _buildPollSettings(),
                  const SizedBox(height: 30),
                  
                  // Publish Button
                  _buildPublishButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool optional = false}) {
    return Row(
      children: [
        Text(
          title,
          style: CustomText.semiBold14(AppColor.SecondryColor),
        ),
        if (optional)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Optional",
              style: CustomText.regular12(Colors.grey),
            ),
          ),
      ],
    );
  }
  Widget _buildTemplateSelection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionHeader("Choose Template"),
      const SizedBox(height: 10),
      
      // Side by side template options
      Row(
        children: [
          // Yes/No Template
          Expanded(
            child: _buildTemplateOption(
              title: "Yes/No",
              subtitle: "Simple binary choice poll",
              isSelected: controller.selectedTemplate.value == 'yesno',
              onTap: () {
                controller.selectedTemplate.value = 'yesno';
                controller.applyYesNoTemplate();
              },
            ),
          ),
          const SizedBox(width: 12),
          // Multiple Choice Template
          Expanded(
            child: _buildTemplateOption(
              title: "Multiple Choice",
              subtitle: "Choose from several options",
              isSelected: controller.selectedTemplate.value == 'multiple',
              onTap: () {
                controller.selectedTemplate.value = 'multiple';
                controller.applyMultipleChoiceTemplate();
              },
            ),
          ),
        ],
      ),
      
      const SizedBox(height: 12),
      
      // Template Preview
      if (controller.selectedTemplate.value.isNotEmpty)
        _buildTemplatePreview(),
    ],
  );
}

Widget _buildTemplateOption({
  required String title,
  required String subtitle,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      // Remove fixed height and let content determine the height
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColor.PrimaryColor : const Color(0x8022212F),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? AppColor.PrimaryColor.withOpacity(0.05) : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: CustomText.semiBold14(
              isSelected ? AppColor.PrimaryColor : AppColor.SecondryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: CustomText.regular12(Colors.grey), // Changed from 10 to 12 for better readability
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          if (isSelected)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(Icons.check_circle, color: AppColor.PrimaryColor, size: 16),
            ),
        ],
      ),
    ),
  );
}

Widget _buildTemplatePreview() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0x8022212F), width: 0.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Template Preview",
          style: CustomText.semiBold14(AppColor.SecondryColor),
        ),
        const SizedBox(height: 8),
        
        if (controller.selectedTemplate.value == 'yesno')
          _buildYesNoPreview()
        else if (controller.selectedTemplate.value == 'multiple')
          _buildMultipleChoicePreview(),
      ],
    ),
  );
}

Widget _buildYesNoPreview() {
  return Column(
    children: [
      Text(
        "Do you like this feature?",
        style: CustomText.regular14(AppColor.SecondryColor),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.PrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.PrimaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Yes", style: CustomText.regular12(AppColor.PrimaryColor)),
                  Text("65%", style: CustomText.semiBold12(AppColor.PrimaryColor)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x8022212F)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("No", style: CustomText.regular12(AppColor.SecondryColor)),
                  Text("35%", style: CustomText.semiBold12(AppColor.SecondryColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildMultipleChoicePreview() {
  return Column(
    children: [
      Text(
        "Which is your favorite programming language?",
        style: CustomText.regular14(AppColor.SecondryColor),
      ),
      const SizedBox(height: 8),
      _buildPreviewOption("Python", "35%"),
      _buildPreviewOption("JavaScript", "28%"),
      _buildPreviewOption("Dart", "22%", isHighlighted: true),
      _buildPreviewOption("Other", "15%"),
    ],
  );
}

Widget _buildPreviewOption(String option, String percentage, {bool isHighlighted = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: isHighlighted ? AppColor.PrimaryColor.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isHighlighted ? AppColor.PrimaryColor : Colors.transparent,
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Expanded(child: Text(option, style: CustomText.regular12(AppColor.SecondryColor))),
        Text(percentage, style: CustomText.semiBold12(AppColor.SecondryColor)),
      ],
    ),
  );
}



  Widget _buildPollQuestionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x8022212F), width: 0.5),
          ),
          child: TextFormField(
            controller: controller.titleController,
            style: CustomText.regular14(const Color(0xff22212F)),
            cursorColor: AppColor.PrimaryColor,
            maxLines: 3,
            minLines: 1,
            maxLength: 280,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: "What would you like to ask?",
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.5),
              ),
              counterText: "${controller.titleController.text.length}/280",
              counterStyle: CustomText.regular12(Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x8022212F), width: 0.5),
      ),
      child: TextFormField(
        controller: controller.descriptionController,
        style: CustomText.regular14(const Color(0xff22212F)),
        cursorColor: AppColor.PrimaryColor,
        maxLines: 4,
        minLines: 1,
        maxLength: 500,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          hintText: "Optional: add context or details for your poll",
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
            color: Colors.black.withOpacity(0.5),
          ),
          counterText: "${controller.descriptionController.text.length}/500",
          counterStyle: CustomText.regular12(Colors.grey),
        ),
      ),
    );
  }

Widget _buildMediaSection() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _buildMediaOption(
              icon: Icons.camera_alt,
              text: "Camera",
              onTap: () => controller.pickImageFromCamera(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMediaOption(
              icon: Icons.photo_library,
              text: "Gallery", 
              onTap: () => controller.pickImageFromGallery(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      
      // FIX: Use the proper image preview method
      Obx(() => controller.hasImageSelected
          ? _buildSelectedImagePreview()
          : _buildImagePlaceholder()),
    ],
  );
}

  Widget _buildMediaOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x8022212F), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColor.SecondryColor),
            const SizedBox(width: 8),
            Text(
              text,
              style: CustomText.regular14(AppColor.SecondryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x8022212F), width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Obx(() {
            if (kIsWeb) {
              return controller.selectedByteImage.value != null
                  ? Image.memory(
                      controller.selectedByteImage.value!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorState();
                      },
                    )
                  : _buildErrorState();
            } else {
              return controller.selectedImage.value != null
                  ? Image.file(
                      controller.selectedImage.value!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorState();
                      },
                    )
                  : _buildErrorState();
            }
          }),
        ),
      ),
      Positioned(
        top: 8,
        right: 8,
        child: GestureDetector(
          onTap: () => controller.removeImage(),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ),
      ),
    ],
  );
}

Widget _buildImagePlaceholder() {
  return GestureDetector(
    onTap: () {
      // Allow tapping the placeholder to select image
      controller.pickImageFromGallery();
    },
    child: Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x8022212F), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera, size: 50, color: Colors.grey[500]),
          const SizedBox(height: 8),
          Text(
            'Add Poll Image',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to select from gallery',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorState() {
  return Container(
    color: Colors.grey[100],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.red, size: 40),
        const SizedBox(height: 8),
        Text(
          'Failed to load image',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSourceLinkField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x8022212F), width: 0.5),
      ),
      child: TextFormField(
        controller: controller.websiteController,
        style: CustomText.regular14(const Color(0xff22212F)),
        cursorColor: AppColor.PrimaryColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          hintText: "Optional: https://example.com",
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
            color: Colors.black.withOpacity(0.5),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Text(
              "Source Link",
              style: CustomText.semiBold14(AppColor.SecondryColor),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }

  Widget _buildPollOptions() {
    return Column(
      children: [
        ...List.generate(
          controller.optionControllers.length,
          (index) {
            final optionNumber = index + 1;
            final isMandatory = index < 2;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      "$optionNumber",
                      style: CustomText.semiBold14(AppColor.SecondryColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOptionTextField(
                      controller: controller.optionControllers[index],
                      hintText: isMandatory ? 'Option ${String.fromCharCode(65 + index)}' : 'Option ${String.fromCharCode(65 + index)} (optional)',
                    ),
                  ),
                  if (!isMandatory)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () => controller.removeOption(index),
                    ),
                ],
              ),
            );
          },
        ),
        if (controller.optionControllers.length < 5)
          CustomButton(
            text: "+ Add Option",
            fillColor: const Color(0xff22212F),
            textcolor: const Color(0xffFFFFFF),
            bordercolor: const Color(0xff22212F),
            onTap: () async => controller.addOption(),
          ),
      ],
    );
  }

  Widget _buildOptionTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x8022212F), width: 0.5),
      ),
      child: TextFormField(
        controller: controller,
        style: CustomText.regular14(const Color(0xff22212F)),
        cursorColor: AppColor.PrimaryColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPollSettings() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x8022212F), width: 0.5),
      ),
      child: Column(
        children: [
          // Poll Duration
          _buildSettingItem(
            title: "Poll Duration",
            isChecked: controller.pollDurationEnabled.value,
            onChanged: (value) => controller.pollDurationEnabled.value = value ?? false,
            child: _buildDurationOptions(),
          ),
          const Divider(height: 1),
          
          // Visibility
           // Visibility setting in _buildPollSettings()
          _buildSettingItemWithIcon(
            icon: Icons.visibility,
            title: "Visibility",
            isActive: controller.visibilityEnabled.value,
            onChanged: (value) => controller.visibilityEnabled.value = value ?? false,
            child: Text(
              controller.visibilityEnabled.value 
                  ? "Anyone can see and vote" 
                  : "Only you can see",
              style: CustomText.regular14(AppColor.SecondryColor),
              ),
            ),
          const Divider(height: 1),
          
          // Notifications
          _buildSettingItem(
            title: "Notifications",
            isChecked: controller.notificationsEnabled.value,
            onChanged: (value) => controller.notificationsEnabled.value = value ?? false,
            child: Text(
              "Get notified about votes and comments",
              style: CustomText.regular14(AppColor.SecondryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItemWithIcon({
  required IconData icon,
  required String title,
  required bool isActive,
  required ValueChanged<bool?>? onChanged,
  required Widget child,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColor.SecondryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomText.semiBold14(AppColor.SecondryColor),
              ),
              const SizedBox(height: 8),
              if (isActive) child,
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: isActive,
          onChanged: onChanged,
          activeColor: AppColor.PrimaryColor,
        ),
      ],
    ),
  );
}

  Widget _buildSettingItem({
    required String title,
    required bool isChecked,
    required ValueChanged<bool?>? onChanged,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppColor.PrimaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomText.semiBold14(AppColor.SecondryColor),
                ),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOptions() {
  final durations = [
    {'label': '1 Hour', 'days': 0}, // Use 0 for hours, we'll handle conversion
    {'label': '6 Hours', 'days': 0},
    {'label': '1 Day', 'days': 1},
    {'label': '3 Days', 'days': 3},
    {'label': '7 Days', 'days': 7},
  ];

     return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: durations.asMap().entries.map((entry) {
      final index = entry.key;
      final duration = entry.value;
      final isSelected = controller.selectedDurationIndex.value == index;
      
      return GestureDetector(
        onTap: () {
          controller.selectedDurationIndex.value = index;
          controller.selectedDurationDays.value = duration['days'] as int;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.PrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColor.PrimaryColor : const Color(0x8022212F),
            ),
          ),
          child: Text(
            duration['label'] as String,
            style: CustomText.regular14(
              isSelected ? Colors.white : AppColor.SecondryColor,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildPublishButton() {
  return Obx(() => CustomButton(
        text: "Publish Poll",
        isLoading: controller.isLoading.value,
        onTap: () async {
          final tags = controller.hashtagsChipController.getTags ?? [];
          final homeController = Get.find<HomeController>();
          final MainController mainController = Get.find<MainController>();
          
          // FIX: Remove or properly define profileController
          // final profileController = Get.find<ProfileController>(); // If you have one
          
          if (controller.validateForm()) {
            controller.isLoading.value = true;
            try {
              int expiresInDays = controller.calculateExpirationDays();
              
              final response = await ApiService().postCreatePoll(
                title: controller.titleController.text.trim(),
                description: controller.descriptionController.text.trim(),
                url: controller.websiteController.text.trim(),
                hashtags: tags.join(',').toString(),
                options: controller.optionControllers.map((e) => e.text.trim()).where((text) => text.isNotEmpty).toList(),
                expiresInDays: expiresInDays,
                imageFile: controller.selectedImage.value,
                webImageBytes: controller.selectedByteImage.value,
              );
              
              if (response['status'] == 200) {
                Get.back();
                CustomSnackbar.success("Success", response['message'] ?? "Poll created successfully");
                await Future.delayed(const Duration(milliseconds: 300));

                controller.resetForm();
                controller.scrollToTop();
                homeController.refreshPolls();
                // FIX: Remove or fix this line
                // profileController.loadProfileAndPolls();
                mainController.changeTabIndex(0);
                controller.isLoading.value = false;
              } else {
                controller.isLoading.value = false;
                CustomSnackbar.error("Error", response['message']);
              }
            } catch (e) {
              print("Poll Creation Error: $e");
              CustomSnackbar.error("Error", e.toString());
              controller.isLoading.value = false;
            }
          }
        },
      ));
}



Widget HashtagsWidget({
  required StringTagController controller,
}) {
  return TextFieldTags(
    textfieldTagsController: controller,
    textSeparators: const [" ", ","],
    letterCase: LetterCase.normal,
    inputFieldBuilder: (context, inputFieldValues) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x8022212F), width: 0.5),
        ),
        child: Column(
          children: [
            // Tags display
            if (inputFieldValues.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: inputFieldValues.tags.map((String tag) {
                    return Chip(
                      label: Text(tag, style: CustomText.light14(AppColor.WhiteColor)),
                      backgroundColor: AppColor.SecondryColor,
                      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                      onDeleted: () => inputFieldValues.onTagRemoved(tag),
                    );
                  }).toList(),
                ),
              ),
            // Input with Add button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputFieldValues.textEditingController,
                      focusNode: inputFieldValues.focusNode,
                      onSubmitted: inputFieldValues.onTagSubmitted,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add a tag",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: CustomButton(
                      text: "Add",
                      fillColor: AppColor.PrimaryColor,
                      textcolor: AppColor.WhiteColor,
                      bordercolor: AppColor.PrimaryColor,
                      onTap: () async {
                        final text = inputFieldValues.textEditingController.text.trim();
                        if (text.isNotEmpty) {
                          inputFieldValues.onTagSubmitted(text);
                          inputFieldValues.textEditingController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
}
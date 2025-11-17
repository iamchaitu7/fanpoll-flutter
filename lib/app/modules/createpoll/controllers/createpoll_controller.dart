// ignore_for_file: prefer_is_empty, unnecessary_null_comparison

import 'dart:io';

import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreatepollController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hashtagsController = TextEditingController();
  final StringTagController hashtagsChipController = StringTagController();
  final TextEditingController websiteController = TextEditingController();
  var optionControllers = <TextEditingController>[TextEditingController(), TextEditingController()].obs;
  var pollDurationEnabled = false.obs;
  var selectedDurationDays = 7.obs; // Default 7 days (int instead of double)
  var notificationsEnabled = true.obs;

   var selectedDurationIndex = 4.obs; // Default to 7 Days (index 4)

    var selectedTemplate = ''.obs;
  var visibilityEnabled = true.obs;

  
  void applyYesNoTemplate() {
    // Clear existing options but keep exactly 2
    while (optionControllers.length > 2) {
      optionControllers.removeLast();
    }
    while (optionControllers.length < 2) {
      optionControllers.add(TextEditingController());
    }
    
    // Set Yes/No options
    optionControllers[0].text = "Yes";
    optionControllers[1].text = "No";
    
    // Set a sample question
    titleController.text = "Do you like this feature?";
  }
  
  void applyMultipleChoiceTemplate() {
    // Ensure we have 4 options for multiple choice
    while (optionControllers.length < 4) {
      optionControllers.add(TextEditingController());
    }
    while (optionControllers.length > 4) {
      optionControllers.removeLast();
    }
    
    // Set sample options
    optionControllers[0].text = "Python";
    optionControllers[1].text = "JavaScript";
    optionControllers[2].text = "Dart";
    optionControllers[3].text = "Other";
    
    // Set a sample question
    titleController.text = "Which is your favorite programming language?";
  }
  
  
  
  
  
  // Add this missing method:
  int calculateExpirationDays() {
    if (!pollDurationEnabled.value) {
      return 7; // Default 7 days if duration not enabled
    }
    
    // Handle based on selected duration index
    switch (selectedDurationIndex.value) {
      case 0: // 1 Hour
        return 1; // Return at least 1 day
      case 1: // 6 Hours  
        return 1; // Return at least 1 day
      case 2: // 1 Day
        return 1;
      case 3: // 3 Days
        return 3;
      case 4: // 7 Days
        return 7;
      default:
        return 7;
    }
  }
  
  Uint8List? webImageBytes;
  final picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> selectedByteImage = Rx<Uint8List?>(null);
  Rx<DateTime?> selectedExpireDate = Rx<DateTime?>(null);

  final ImagePicker _imagePicker = ImagePicker();

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          selectedByteImage.value = bytes;
        } else {
          selectedImage.value = File(image.path);
        }
      }
    } catch (e) {
      print("Camera error: $e");
      CustomSnackbar.error("Error", "Failed to capture image");
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          selectedByteImage.value = bytes;
        } else {
          selectedImage.value = File(image.path);
        }
      }
    } catch (e) {
      print("Gallery error: $e");
      CustomSnackbar.error("Error", "Failed to pick image from gallery");
    }
  }

  // Keep your existing pickImage method for backward compatibility
  Future<void> pickImage() async {
    await pickImageFromGallery();
  }

   void removeImage() {
    selectedImage.value = null;
    selectedByteImage.value = null;
  }

  var isLoading = false.obs;
  void addOption() {
    if (optionControllers.length < 5) {
      optionControllers.add(TextEditingController());
    }
  }

  void removeOption(int index) {
    if (optionControllers.length > 1) {
      optionControllers.removeAt(index);
    }
  }

  final scrollController = ScrollController();

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    websiteController.clear();
    hashtagsController.clear();
    selectedImage.value = null;
    pollDurationEnabled.value = false;
    selectedDurationDays.value = 7.0 as int;
    notificationsEnabled.value = true;
    for (var controller in optionControllers) {
      controller.clear();
    }

    // Optionally reset to two empty options
    // optionControllers.clear();
    // optionControllers.addAll([
    //   TextEditingController(),
    //   TextEditingController(),
    // ]);
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  

  Future<ImageSource> _selectImageSource() async {
    ImageSource? source;
    await Get.defaultDialog(
      title: "Select Source",
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              source = ImageSource.camera;
              Get.back();
            },
            child: const Text("Camera"),
          ),
          SizedBox(
            height: kIsWeb ? 10 : 0,
          ),
          ElevatedButton(
            onPressed: () {
              source = ImageSource.gallery;
              Get.back();
            },
            child: const Text("Gallery"),
          ),
        ],
      ),
    );
    return source ?? ImageSource.gallery;
  }

  int calculateDaysDifference() {
    final selectedDate = selectedExpireDate.value!;
    final now = DateTime.now();
    return selectedDate.difference(now).inDays;
  }

  // Add these methods to check if image is selected
bool get hasImageSelected {
  return kIsWeb ? selectedByteImage.value != null : selectedImage.value != null;
}

// Get the image for preview
dynamic get imageForPreview {
  if (kIsWeb) {
    return selectedByteImage.value;
  } else {
    return selectedImage.value;
  }
}

// Get image file for upload
Future<File?> get imageFileForUpload async {
  if (kIsWeb) {
    // For web, you'll need to handle the Uint8List differently
    return null;
  } else {
    return selectedImage.value;
  }
}

bool validateForm() {
  if (titleController.text.trim().isEmpty) {
    Get.snackbar('Error', 'Please enter poll question');
    return false;
  }
  
  // Check if at least two options are filled
  final filledOptions = optionControllers
      .where((controller) => controller.text.trim().isNotEmpty)
      .length;
  
  if (filledOptions < 2) {
    Get.snackbar('Error', 'Please enter at least two options');
    return false;
  }
  
  // Check expiry date - if using date picker OR poll duration
  if (selectedExpireDate.value == null && !pollDurationEnabled.value) {
    Get.snackbar('Error', 'Please select an expiry date or enable poll duration');
    return false;
  }
  
  return true;
}

  @override
  void onClose() {
    resetForm();
    // scrollToTop();
    isLoading.value = false;
    titleController.clear();
    descriptionController.clear();
    websiteController.clear();
    hashtagsController.clear();
    selectedImage.value = null;
    selectedExpireDate.value = null;
    for (var controllerField in optionControllers) {
      controllerField.clear();
    }
    super.onClose();
  }
}

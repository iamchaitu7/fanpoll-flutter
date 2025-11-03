// ignore_for_file: unnecessary_null_comparison, avoid_print, depend_on_referenced_packages

import 'dart:io';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditprofileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  Rx<UserModel?> user = Rx<UserModel?>(null);
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> selectedByteImage = Rx<Uint8List?>(null);
  var isLoading = false.obs;

  final picker = ImagePicker();
  final api = ApiService();
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    final userData = await LocalStorageService.getData('logged_in_user');
    if (userData != null) {
      try {
        user.value = UserModel.fromJson(userData);
        userNameController.text = user.value?.fullName ?? "";
        bioController.text = user.value?.bio ?? "";
      } catch (e) {
        print("Failed to parse user: $e");
      }
    }
  }

  Future<void> pickImage() async {
    // final status = await Permission.photos.request();
    // print("IMAGE PERMISSTION STATUS:: $status");
    // if (status.isGranted) {
    final source = await _selectImageSource();
    if (source == null) return;

    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      selectedByteImage.value = await pickedFile.readAsBytes();
      selectedImage.value = File(pickedFile.path);
    }
    // } else if (status.isPermanentlyDenied) {
    //   Get.defaultDialog(
    //     title: "Permission Required",
    //     content: Text(
    //         "Photo access is permanently denied. Please allow access in app settings."),
    //     textCancel: "Cancel",
    //     textConfirm: "Open Settings",
    //     onConfirm: () async {
    //       await openAppSettings();
    //       Get.back(); // close dialog
    //     },
    //   );
    // } else {
    //   await openAppSettings();
    //   Get.snackbar("Permission", "Photo access is required");
    // }
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

  Future<void> validateAndSubmit() async {
    if (formKey.currentState!.validate()) {
      await onEditProfile();
    }
  }

  Future<void> onEditProfile() async {
    isLoading.value = true;
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${ApiService.baseUrl}profile/edit');
    final request = http.MultipartRequest('POST', uri);

    request.fields['full_name'] = userNameController.text.trim();
    request.fields['bio'] = bioController.text.trim();

    if (selectedImage.value != null) {
      // Add image if present
      if (kIsWeb) {
        if (selectedByteImage != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'profile_picture',
              selectedByteImage.value!,
              filename: 'image.jpg',
            ),
          );
        }
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          selectedImage.value!.path,
        ));
      }
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    try {
      final response = await request.send();
      final resBody = await http.Response.fromStream(response);

      if (resBody.statusCode == 200) {
        print("Response Body: ${resBody.body}");

        final profileResponse = await api.getProfile(token.toString());
        final userData = profileResponse['data'];

        await LocalStorageService.saveData('logged_in_user', userData);
        Get.back(result: true);
        CustomSnackbar.success("Success", "Profile updated successfully");
      } else {
        print("Response Body: ${resBody.body}");
        Get.snackbar("Error", "Failed to update: ${resBody.body}");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    userNameController.clear();
    bioController.clear();
    super.onClose();
  }
}

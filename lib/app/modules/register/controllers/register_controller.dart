// ignore_for_file: unnecessary_overrides, non_constant_identifier_names, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final api = ApiService();

  final emailFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  var emailControllerText = ''.obs;
  var nameControllerText = ''.obs;
  var passwordControllerText = ''.obs;

  var passwordseen = false.obs;
  var isLoading = false.obs;
  var isLoadingSocialAuth = false.obs;
  var isLoadingApple = false.obs;

  void PasswordSeenChange() {
    passwordseen.value = !passwordseen.value;
  }

  @override
  void onClose() {
    // emailFocusNode.dispose();
    // nameFocusNode.dispose();
    // passwordFocusNode.dispose();
    emailController.value.clear();
    passwordController.value.clear();
    nameController.value.clear();
    super.onClose();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  bool validateRegister() {
    final email = emailController.value.text.trim();
    final password = passwordController.value.text;
    final name = nameController.value.text;

    if (name.isEmpty) {
      CustomSnackbar.error("error".tr, "full_name_required".tr);
      return false;
    }

    if (email.isEmpty) {
      CustomSnackbar.error("error".tr, "email_required".tr);
      return false;
    }

    if (!EmailValidator.validate(email)) {
      CustomSnackbar.error("error".tr, "pls_enter_valid_email".tr);
      return false;
    }

    if (password.isEmpty) {
      CustomSnackbar.error("error".tr, "password_required".tr);
      return false;
    }

    if (password.length < 6) {
      CustomSnackbar.error("error".tr, "pls_enter_password".tr);
      return false;
    }

    return true;
  }

  void onRegister() async {
    try {
      final response = await api.postRegisterFormData(
          email: emailController.value.text.trim(), password: passwordController.value.text, full_name: nameController.value.text);

      if (response['status'] == 200) {
        final token = response['token'];
        await LocalStorageService.saveString('token', token);

        CustomSnackbar.success("Success", response['message'] ?? "Register successful");
        final profileResponse = await api.getProfile(token);
        final userData = profileResponse['data'];

        print("User Profile: $userData");

        // Save only 'data' part
        await LocalStorageService.saveData('logged_in_user', userData);

        Get.offAllNamed("/main");
        isLoading.value = false;
      } else {
        isLoading.value = false;
        CustomSnackbar.error("Error", response['message']);
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackbar.error("Error", e.toString());
    }
  }
}

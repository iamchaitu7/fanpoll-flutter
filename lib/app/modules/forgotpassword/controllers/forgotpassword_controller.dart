// ignore_for_file: non_constant_identifier_names, unnecessary_overrides, avoid_print

import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotpasswordController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final api = ApiService();
  var otp = ''.obs;

  // List<TextEditingController> controllers =
  //     List.generate(6, (index) => TextEditingController());
  // List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  // void updateOtp() {
  //   otp.value = controllers.map((c) => c.text).join();
  // }

  // void clearOtp() {
  //   for (var controller in controllers) {
  //     controller.clear();
  //   }
  //   otp.value = '';
  //   focusNodes[0].requestFocus();
  // }
// var otp = ''.obs;

  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  void updateOtp() {
    otp.value = controllers.map((e) => e.text).join();
  }

  void clearAll() {
    for (var c in controllers) {
      c.clear();
    }
    otp.value = '';
    focusNodes[0].requestFocus();
  }

  var passwordseen = false.obs;
  var newPasswordseen = true.obs;
  var emailControllerText = ''.obs;
  var passwordControllerText = ''.obs;
  var newPasswordControllerText = ''.obs;

  var otpResetKey = 0.obs;

  RxBool clean = false.obs;
  ClearEmail(change) {
    clean.value == change;
  }

  void PasswordSeenChange() {
    passwordseen.value = !passwordseen.value;
  }

  void NewPasswordSeenChange() {
    newPasswordseen.value = !newPasswordseen.value;
  }

  var isLoading = false.obs;
  RxInt currentStep = 0.obs;

  void goToNextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void resetSteps() {
    currentStep.value = 0;
  }

  final otpController = TextEditingController().obs;
  var isOTPTimerRunning = false.obs;
  var secondsRemaining = 60.obs;
  Timer? _timer;

  void startOTPTimer() {
    secondsRemaining.value = 60;
    isOTPTimerRunning.value = true;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
        isOTPTimerRunning.value = false;
      }
    });
  }

  void resendOTP() {
    CustomSnackbar.success("Success", "OTP resent successfully.");
    startOTPTimer();
  }

  bool validateLogin() {
    final email = emailController.value.text.trim();
    if (email.isEmpty) {
      CustomSnackbar.error("error".tr, "email_required".tr);
      return false;
    }
    if (!EmailValidator.validate(email)) {
      CustomSnackbar.error("error".tr, "pls_enter_valid_email".tr);
      return false;
    }
    return true;
  }

  bool validatePassword() {
    final newPassword = newPasswordController.value.text.trim();
    final confirmPassword = passwordController.value.text.trim();

    if (newPassword.isEmpty) {
      CustomSnackbar.error("error".tr, "New password is required.");
      return false;
    }

    if (newPassword.length < 6) {
      CustomSnackbar.error(
          "error".tr, "Please enter at least 6 characters for new password.");
      return false;
    }

    if (confirmPassword.isEmpty) {
      CustomSnackbar.error("error".tr, "Confirm password is required.");
      return false;
    }

    if (confirmPassword.length < 6) {
      CustomSnackbar.error("error".tr,
          "Please enter at least 6 characters for confirm password.");
      return false;
    }

    if (newPassword != confirmPassword) {
      CustomSnackbar.error(
          "error".tr, "New password and confirm password do not match.");
      return false;
    }

    return true;
  }

  void onSendOTP() async {
    // CustomSnackbar.success("Success", "Send OTP ");

    if (!validateLogin()) return;
    isLoading.value = true;
    try {
      final response = await api.postSendOTP(
        email: emailControllerText.toString(),
      );

      if (response['status'] == 200) {
        CustomSnackbar.success(
            "Success", response['message'] ?? "Login successful");
        isLoading.value = false;
        startOTPTimer();
        goToNextStep();
      } else {
        CustomSnackbar.error("Error", response['message']);
        isLoading.value = false;
      }
    } catch (e) {
      CustomSnackbar.error("Error", e.toString());
      isLoading.value = false;
    }
  }

  void onVerifyOTP() async {
    isLoading.value = true;

    final enteredOTP = otp.value.trim();
    if (enteredOTP.isEmpty) {
      CustomSnackbar.error("Error", "Please enter the OTP.");
      isLoading.value = false;
      return;
    }

    if (enteredOTP.length != 6) {
      CustomSnackbar.error("Error", "OTP must be 6 digits.");
      isLoading.value = false;
      return;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(enteredOTP)) {
      CustomSnackbar.error("Error", "OTP must contain only numbers.");
      isLoading.value = false;
      return;
    }
    // CustomSnackbar.success("Success", "OTP verified successfully.");
    isLoading.value = false;
    goToNextStep();
  }

  void onForgotPassword() async {
    isLoading.value = true;
    // CustomSnackbar.success("Success", "Forgot Password");
    if (!validatePassword()) return;
    try {
      print(
          "DATA************ ${emailControllerText.toString()}  ${otp.value.trim()} ${newPasswordControllerText.toString()}");
      final response = await api.postChnagePasswordFormData(
          email: emailControllerText.toString(),
          otp: otp.value.trim(),
          new_password: newPasswordControllerText.toString());

      if (response['status'] == 200) {
        CustomSnackbar.success(
            "Success", response['message'] ?? "Chnage password successfully");
        isLoading.value = false;
        Get.offAllNamed("/login");
      } else {
        CustomSnackbar.error("Error", response['message']);
        if (response['message'] == "Invalid or expired OTP") {
          resetSteps();
          emailController.value.clear();
          passwordController.value.clear();
          newPasswordController.value.clear();
          otpController.value.clear();
        }
        isLoading.value = false;
      }
    } catch (e) {
      CustomSnackbar.error("Error", e.toString());
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // emailFocusNode.();
    // passwordFocusNode.clear();
    emailController.value.clear();
    passwordController.value.clear();
    newPasswordController.value.clear();
    otpController.value.clear();
    super.onClose();
    super.onClose();
  }
}

// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final api = ApiService();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  var emailControllerText = ''.obs;
  var passwordControllerText = ''.obs;

  var passwordseen = false.obs;
  var isLoading = false.obs;
  var isLoadingGoogle = false.obs;
  var isLoadingApple = false.obs;

  void PasswordSeenChange() {
    passwordseen.value = !passwordseen.value;
  }

  @override
  void onClose() {
    // emailFocusNode.dispose();
    // passwordFocusNode.dispose();
    emailController.value.clear();
    passwordController.value.clear();
    super.onClose();
  }

  RxBool clean = false.obs;
  ClearEmail(change) {
    clean.value == change;
  }
  // final isLoading = false.obs;

  bool validateLogin() {
    final email = emailController.value.text.trim();
    final password = passwordController.value.text;

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

  void onLogin() async {
    isLoading.value = true;
    try {
      final response = await api.postLoginFormData(
        email: emailControllerText.toString(),
        password: passwordControllerText.toString(),
      );

      if (response['status'] == 200) {
        final token = response['token'];
        await LocalStorageService.saveString('token', token);

        CustomSnackbar.success("Success", response['message'] ?? "Login successful");

        final profileResponse = await api.getProfile(token);
        final userData = profileResponse['data'];

        print("User Profile: $userData");

        // Save only 'data' part
        await LocalStorageService.saveData('logged_in_user', userData);
        isLoading.value = false;
        Get.offAllNamed("/main");
      } else {
        isLoading.value = false;
        CustomSnackbar.error("Error", response['message']);
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackbar.error("Error", e.toString());
    }
  }

  Future<void> onAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      String appleId = credential.userIdentifier ?? "";
      String email = credential.email ?? "";
      String firstName = credential.givenName ?? "";
      String lastName = credential.familyName ?? "";

      if (email.isNotEmpty) {
        saveSecureDefault("apple_first_name", firstName);
        saveSecureDefault("apple_last_name", lastName);
        saveSecureDefault("apple_email_id", email);
        saveSecureDefault("apple_id", appleId);
      } else {
        email = await getSecureDefault("apple_email_id") ?? "";
        firstName = await getSecureDefault("apple_first_name") ?? "";
        lastName = await getSecureDefault("apple_last_name") ?? "";
      }
      loginWithSocialMedia(email, appleId, "$firstName $lastName", 'apple');
    } catch (error) {
      print(error);
    }
  }

  Future<void> onGoogleSignIn() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // ✅ Web sign-in using FirebaseAuth popup
        final googleProvider = GoogleAuthProvider();

        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // ✅ Mobile sign-in using google_sign_in package
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
                scopes: ["email"],
                clientId: Platform.isIOS
                    ? "301803721911-mhi1e68ujjn4cqurpd2qfj1oajfgko65.apps.googleusercontent.com"
                    : "301803721911-kdd6n18mhpuhu2086qj3r1g51k7l6evb.apps.googleusercontent.com")
            .signIn();

        if (googleUser == null) {
          CustomSnackbar.error("Error", "Google sign-in aborted");
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final user = userCredential.user;
      print("USER :: $user");
      if (user != null) {
        loginWithSocialMedia(user.email ?? "", user.uid ?? "", user.displayName ?? '', 'google');
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      CustomSnackbar.error("Google Sign-In Failed", e.toString());
    }
  }

  loginWithSocialMedia(String email, String uId, String fullName, String method) async {
    final response = await api.postGoogleFormData(
      email: email,
      auth_method: method,
      oauth_id: uId,
      full_name: fullName,
    );

    if (response['status'] == 200) {
      final token = response['token'];
      await LocalStorageService.saveString('token', token);

      final profileResponse = await api.getProfile(token);
      final userData = profileResponse['data'];

      await LocalStorageService.saveData('logged_in_user', userData);

      CustomSnackbar.success("Success", response['message'] ?? "Login successful");
      Get.offAllNamed("/main");
    } else {
      CustomSnackbar.error("Login Failed", response['message']);
    }
  }

  static void saveSecureDefault(String key, value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<String?> getSecureDefault(String key) async {
    const storage = FlutterSecureStorage();
    final value = await storage.read(key: key);
    return value;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}

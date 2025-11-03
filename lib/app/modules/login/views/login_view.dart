// ignore_for_file: unnecessary_import, body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_import, avoid_types_as_parameter_names
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/widget/button.dart';
import 'package:fan_poll/app/widget/divider.dart';
import 'package:fan_poll/app/widget/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColor.PrimaryColor),
              ),
              margin: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 16,
                left: 16,
                right: 16,
              ),
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.blue.shade100,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () => Get.toNamed("/register"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 9.sp),
                    child: Text(
                      "register".tr,
                      style: CustomText.regular14(AppColor.PrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 100.sp,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 115.h,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(AssetPath.Logo_Auth),
                      ),
                      // const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Color(0xffEEEFF6)),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.SplashColor,
                              blurRadius: 6,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "login_to_your_account".tr,
                                style: CustomText.semiBold18(AppColor.SecondryColor),
                              ),
                              SizedBox(height: 30.h),
                              Form(
                                child: Column(
                                  children: [
                                    Obx(
                                      () => TextFiledWidget(
                                        focusNode: loginController.emailFocusNode,
                                        onFieldSubmitted: (val) {
                                          FocusScope.of(context).requestFocus(loginController.passwordFocusNode);
                                        },
                                        textInputType: TextInputType.emailAddress,
                                        onchanged: (val) {
                                          loginController.emailControllerText.value = loginController.emailController.value.text;
                                        },
                                        suficesicon: loginController.emailControllerText.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(right: 16.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      loginController.emailController.value.clear();
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: AppColor.PrimaryColor,
                                                    )),
                                              )
                                            : SizedBox(),
                                        controller: loginController.emailController.value,
                                        hinttext: "enter_email".tr,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Obx(
                                      () => TextFiledWidget(
                                        focusNode: loginController.passwordFocusNode,
                                        onchanged: (value) {
                                          loginController.passwordControllerText.value = loginController.passwordController.value.text;
                                        },
                                        textInputType: TextInputType.text,
                                        suficesicon: Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: InkWell(
                                            onTap: () {
                                              loginController.PasswordSeenChange();
                                            },
                                            child: Icon(
                                              !loginController.passwordseen.value ? Icons.visibility : Icons.visibility_off,
                                              color: AppColor.PrimaryColor,
                                            ),
                                          ),
                                        ),
                                        controller: loginController.passwordController.value,
                                        obscuretext: loginController.passwordseen.value,
                                        hinttext: "enter_password".tr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed('/forgotpassword');
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: CustomText.medium12(AppColor.PrimaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Obx(() => CustomButton(
                                  text: "login".tr,
                                  isLoading: controller.isLoading.value,
                                  onTap: () async {
                                    if (!controller.validateLogin()) return;

                                    controller.onLogin();
                                  })),
                              SizedBox(height: 20.h),
                              DividerRow(text: "or".tr),
                              SizedBox(height: 20.h),
                              Obx(() => CustomButton(
                                    text: "login_with_google".tr,
                                    isGoogle: true,
                                    fillColor: Color(0xff22212F),
                                    textcolor: Color(0xffFFFFFF),
                                    bordercolor: Color(0xff22212F),
                                    isLoading: controller.isLoadingGoogle.value,
                                    onTap: () async {
                                      await GoogleSignIn().signOut();
                                      await FirebaseAuth.instance.signOut();
                                      controller.isLoadingGoogle.value = true;
                                      controller.onGoogleSignIn();
                                      controller.isLoadingGoogle.value = false;
                                    },
                                  )),
                              if (!kIsWeb && Platform.isIOS) ...[
                                SizedBox(height: 20.h),
                                Obx(
                                  () => CustomButton(
                                    text: "Login with Apple",
                                    isGoogle: true,
                                    image: AssetPath.icApple,
                                    fillColor: Color(0xff22212F),
                                    textcolor: Color(0xffFFFFFF),
                                    bordercolor: Color(0xff22212F),
                                    isLoading: controller.isLoadingApple.value,
                                    onTap: () async {
                                      controller.isLoadingApple.value = true;
                                      controller.onAppleSignIn();
                                      controller.isLoadingApple.value = false;
                                    },
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

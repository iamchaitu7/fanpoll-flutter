// ignore_for_file: body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers
import 'dart:io';

import 'package:fan_poll/app/modules/login/controllers/login_controller.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/widget/button.dart';
import 'package:fan_poll/app/widget/divider.dart';
import 'package:fan_poll/app/widget/textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController = Get.put(RegisterController());
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
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 9.sp),
                    child: Text("login".tr, style: CustomText.regular14(AppColor.PrimaryColor)),
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.sp,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 75.h,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Image.asset(AssetPath.Logo_Auth)),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.paddingOf(context).bottom + 50,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: const Color(0xffEEEFF6)),
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
                                "create_your_account".tr,
                                style: CustomText.semiBold18(AppColor.SecondryColor),
                              ),
                              SizedBox(height: 30.h),
                              Form(
                                child: Column(
                                  children: [
                                    TextFiledWidget(
                                      focusNode: registerController.nameFocusNode,
                                      textInputType: TextInputType.text,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).requestFocus(registerController.emailFocusNode);
                                      },
                                      controller: registerController.nameController.value,
                                      obscuretext: false,
                                      hinttext: "enter_full_name".tr,
                                    ),
                                    SizedBox(height: 8.h),
                                    Obx(() => TextFiledWidget(
                                          focusNode: registerController.emailFocusNode,
                                          textInputType: TextInputType.emailAddress,
                                          onchanged: (val) {
                                            registerController.emailControllerText.value = registerController.emailController.value.text;
                                          },
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(registerController.passwordFocusNode);
                                          },
                                          suficesicon: registerController.emailControllerText.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.only(right: 16.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      registerController.emailController.value.clear();
                                                      registerController.emailControllerText.value = '';
                                                    },
                                                    child: Icon(Icons.clear, color: AppColor.PrimaryColor),
                                                  ),
                                                )
                                              : SizedBox(),
                                          controller: registerController.emailController.value,
                                          hinttext: "enter_email".tr,
                                          obscuretext: false,
                                        )),
                                    SizedBox(height: 8.h),
                                    Obx(() => TextFiledWidget(
                                          focusNode: registerController.passwordFocusNode,
                                          textInputType: TextInputType.text,
                                          onchanged: (val) {},
                                          suficesicon: Padding(
                                            padding: const EdgeInsets.only(right: 16.0),
                                            child: InkWell(
                                              onTap: registerController.PasswordSeenChange,
                                              child: Icon(
                                                registerController.passwordseen.value ? Icons.visibility_off : Icons.visibility,
                                                color: AppColor.PrimaryColor,
                                              ),
                                            ),
                                          ),
                                          controller: registerController.passwordController.value,
                                          hinttext: "enter_password".tr,
                                          obscuretext: registerController.passwordseen.value,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Obx(() => CustomButton(
                                    text: "register".tr,
                                    isLoading: controller.isLoading.value,
                                    onTap: () async {
                                      if (!controller.validateRegister()) return;
                                      controller.isLoading.value = true;
                                      controller.onRegister();
                                      controller.isLoading.value = false;
                                    },
                                  )),
                              SizedBox(height: 20.h),
                              DividerRow(text: "or".tr),
                              SizedBox(height: 20.h),
                              Obx(() => CustomButton(
                                    text: "register_with_google".tr,
                                    isGoogle: true,
                                    fillColor: const Color(0xff22212F),
                                    textcolor: const Color(0xffFFFFFF),
                                    bordercolor: const Color(0xff22212F),
                                    isLoading: controller.isLoadingSocialAuth.value,
                                    onTap: () async {
                                      controller.isLoadingSocialAuth.value = true;
                                      await loginController.onGoogleSignIn();
                                      controller.isLoadingSocialAuth.value = false;
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
                                      await loginController.onAppleSignIn();
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

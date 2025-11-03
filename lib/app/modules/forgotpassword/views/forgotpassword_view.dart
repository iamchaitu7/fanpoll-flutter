// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_print, unused_import, use_key_in_widget_constructors, deprecated_member_use
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fan_poll/app/utills/module_controllers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/forgotpassword_controller.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/widget/textfield.dart';
import 'package:fan_poll/app/widget/button.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotpasswordView extends GetView<ForgotpasswordController> {
  const ForgotpasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _newFormKey = GlobalKey<FormState>();
    final ForgotpasswordController forgotpasswordController =
        Get.put(ForgotpasswordController());
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                    child:
                        Image.asset(AssetPath.AppIcon, height: 24, width: 24),
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            int step = forgotpasswordController.currentStep.value;
            return Column(
              children: [
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
                          "Forgot Password",
                          style: CustomText.semiBold18(AppColor.SecondryColor),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            3,
                            (index) => Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                height: 6,
                                decoration: BoxDecoration(
                                  color: index < step
                                      ? AppColor.PrimaryColor
                                      : AppColor.SplashColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        step == 0
                            ? Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Text(
                                      "Enter your registered email address and we’ll send you OTP to reset your password.",
                                      style: CustomText.regular14(
                                          Color(0xff22212F).withOpacity(0.5)),
                                    ),
                                    SizedBox(height: 18.h),
                                    Obx(
                                      () => TextFiledWidget(
                                        focusNode: forgotpasswordController
                                            .emailFocusNode,
                                        onFieldSubmitted: (val) {
                                          // FocusScope.of(context).requestFocus(
                                          //     forgotpasswordController
                                          //         .passwordFocusNode);
                                        },
                                        textInputType:
                                            TextInputType.emailAddress,
                                        onchanged: (val) {
                                          forgotpasswordController
                                                  .emailControllerText.value =
                                              forgotpasswordController
                                                  .emailController.value.text;
                                        },
                                        suficesicon: forgotpasswordController
                                                .emailControllerText.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      forgotpasswordController
                                                          .emailController.value
                                                          .clear();
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color:
                                                          AppColor.PrimaryColor,
                                                    )),
                                              )
                                            : SizedBox(),
                                        controller: forgotpasswordController
                                            .emailController.value,
                                        hinttext: "enter_email".tr,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : step == 1
                                ? Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Email and Edit Icon
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: CustomText.regular14(
                                                      Color(0xff22212F)
                                                          .withOpacity(0.5)),
                                                  children: [
                                                    const TextSpan(
                                                        text:
                                                            "We have sent a 4-digit code to "),
                                                    TextSpan(
                                                      text:
                                                          forgotpasswordController
                                                              .emailController
                                                              .value
                                                              .text,
                                                      style: CustomText
                                                          .semiBold13(AppColor
                                                              .SecondryColor),
                                                    ),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          forgotpasswordController
                                                              .goToPreviousStep();
                                                        },
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 18,
                                                          color: AppColor
                                                              .PrimaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text:
                                                            " email address. "),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        OtpFieldWidget(),
                                        SizedBox(
                                          height: forgotpasswordController
                                                      .secondsRemaining.value ==
                                                  0
                                              ? 0
                                              : 12.h,
                                        ),
                                        Obx(() => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                forgotpasswordController
                                                            .secondsRemaining
                                                            .value >
                                                        0
                                                    ? Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: CustomText
                                                                .light12(AppColor
                                                                    .SecondryColor),
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      "Didn't receive the code? Resend available in "),
                                                              TextSpan(
                                                                text:
                                                                    "0:${forgotpasswordController.secondsRemaining.value.toString().padLeft(2, '0')}",
                                                                style: CustomText
                                                                    .medium14(
                                                                        AppColor
                                                                            .PrimaryColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: Text(
                                                          "Didn't receive the code?",
                                                          style: CustomText
                                                              .light12(AppColor
                                                                  .SecondryColor),
                                                        ),
                                                      ),
                                                forgotpasswordController
                                                            .secondsRemaining
                                                            .value >
                                                        0
                                                    ? Text("")
                                                    : TextButton(
                                                        onPressed:
                                                            forgotpasswordController
                                                                        .secondsRemaining
                                                                        .value ==
                                                                    0
                                                                ? () {
                                                                    forgotpasswordController
                                                                        .resendOTP();
                                                                  }
                                                                : null,
                                                        child: Text(
                                                          "Resend OTP",
                                                          style: CustomText
                                                              .semiBold14(
                                                            forgotpasswordController
                                                                        .secondsRemaining
                                                                        .value ==
                                                                    0
                                                                ? AppColor
                                                                    .PrimaryColor
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                : Form(
                                    key: _newFormKey,
                                    child: Column(
                                      children: [
                                        Obx(
                                          () => TextFiledWidget(
                                            focusNode:
                                                controller.passwordFocusNode,
                                            onchanged: (value) {
                                              controller.passwordControllerText
                                                      .value =
                                                  controller.passwordController
                                                      .value.text;
                                            },
                                            textInputType: TextInputType.text,
                                            suficesicon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: InkWell(
                                                onTap: () {
                                                  controller
                                                      .PasswordSeenChange();
                                                },
                                                child: Icon(
                                                  controller.passwordseen.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: AppColor.PrimaryColor,
                                                ),
                                              ),
                                            ),
                                            controller: controller
                                                .passwordController.value,
                                            obscuretext:
                                                controller.passwordseen.value,
                                            hinttext: "Enter New Password",
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        Obx(
                                          () => TextFiledWidget(
                                            focusNode:
                                                controller.newPasswordFocusNode,
                                            onchanged: (value) {
                                              controller
                                                      .newPasswordControllerText
                                                      .value =
                                                  controller
                                                      .newPasswordController
                                                      .value
                                                      .text;
                                            },
                                            textInputType: TextInputType.text,
                                            suficesicon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: InkWell(
                                                onTap: () {
                                                  controller
                                                      .NewPasswordSeenChange();
                                                },
                                                child: Icon(
                                                  controller
                                                          .newPasswordseen.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: AppColor.PrimaryColor,
                                                ),
                                              ),
                                            ),
                                            controller: controller
                                                .newPasswordController.value,
                                            obscuretext: controller
                                                .newPasswordseen.value,
                                            hinttext: "Enter Confirm Password",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                        SizedBox(height: 20.h),
                        Obx(() => CustomButton(
                            text: step == 0
                                ? "Send OTP"
                                : step == 1
                                    ? "Verify OTP"
                                    : "Forgot Password",
                            isLoading: controller.isLoading.value,
                            onTap: () async {
                              step == 0
                                  ? controller.onSendOTP()
                                  : step == 1
                                      ? controller.onVerifyOTP()
                                      : controller.onForgotPassword();
                            })),
                        SizedBox(height: 20.h),
                        // DividerRow(text: "or".tr),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class OtpFieldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 45,
          child: TextField(
            cursorColor: AppColor.PrimaryColor,
            style: CustomText.bold14(AppColor.SecondryColor),
            controller: forgotpasswordController.controllers[index],
            focusNode: forgotpasswordController.focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              // Allow single digit input only
              if (value.length > 1) {
                forgotpasswordController.controllers[index].text = value[0];
                forgotpasswordController.controllers[index].selection =
                    TextSelection.collapsed(offset: 1);
              }

              forgotpasswordController.updateOtp();

              if (value.isNotEmpty && index < 5) {
                forgotpasswordController.focusNodes[index + 1].requestFocus();
              }
            },
            onTap: () {
              forgotpasswordController.controllers[index].selection =
                  TextSelection.collapsed(
                      offset: forgotpasswordController
                          .controllers[index].text.length);
            },
            decoration: InputDecoration(
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w300,
                  color: Colors.black38),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColor.PrimaryColor, width: 1)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColor.PrimaryColor, width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColor.PrimaryColor, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColor.PrimaryColor, width: 1)),
            ),
          ),
        );
      }),
    );
  }
}

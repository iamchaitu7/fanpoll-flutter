// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP, 
      duration:const Duration(seconds: 2), 
      backgroundColor: AppColor.GreenColor.withOpacity(0.6), 
      colorText: Colors.white, 
      borderRadius: 10, 
      margin:const EdgeInsets.all(10), 
      animationDuration:const Duration(milliseconds: 500), 
      barBlur: 10, 
      isDismissible: true, 
    );
  }
  static void error(String title, String message) {
   
    Get.snackbar(
      title,
      message, 
      snackPosition: SnackPosition.TOP, 
      duration:const Duration(seconds: 2), 
      backgroundColor: AppColor.RedColor.withOpacity(0.7), 
      colorText: Colors.white, 

      borderRadius: 10, 
      margin:const EdgeInsets.only(left: 16,right: 16,top: 20), 
      animationDuration:const Duration(milliseconds: 500), 
      barBlur: 10, 
      isDismissible: true, 
    );
  }
}

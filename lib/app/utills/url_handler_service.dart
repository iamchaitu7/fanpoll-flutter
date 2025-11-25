import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';

class UrlHandlerService {
  static UrlHandlerService get to => Get.find();

  Future<void> handleSharedUrl(String url) async {
    try {
      print("Handling URL: $url");
      final uri = Uri.parse(url);

      String? pollIdStr;

      if (uri.pathSegments.length >= 3 && uri.pathSegments[0] == 'share' && uri.pathSegments[1] == 'poll') {
        pollIdStr = uri.pathSegments[2];
      } else if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'poll') {
        pollIdStr = uri.pathSegments[1];
      }

      if (pollIdStr != null && pollIdStr.isNotEmpty) {
        final pollId = int.tryParse(pollIdStr);
        if (pollId != null) {
          print("Navigating to shared poll: $pollId");
          await navigateToSharedPoll(pollId);
          return;
        }
      }

      print("URL format not recognized: $url");
    } catch (e) {
      print('Error handling shared URL: $e');
    }
  }

  Future<void> navigateToSharedPoll(int pollId) async {
    final token = await LocalStorageService.getString('token');
    final isLoggedIn = token != null && token.isNotEmpty;

    print("User logged in: $isLoggedIn, Navigating to shared poll: $pollId");

    Get.offAllNamed('/shared-poll', arguments: {
      'pollId': pollId,
      'isGuest': !isLoggedIn,
    });
  }
}
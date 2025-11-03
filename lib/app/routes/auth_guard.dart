import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utills/localStorageService.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final token = LocalStorageService.prefs.getString('token');
    if (token!.isEmpty) {
      return const RouteSettings(name: '/login');
    }
    return null; // allow navigation
  }
}

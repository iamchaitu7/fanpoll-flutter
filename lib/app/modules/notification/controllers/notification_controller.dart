// controllers/notification_controller.dart // ignore_for_file: avoid_print,
// ignore_for_file: depend_on_referenced_packages, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utills/appServices.dart';

class NotificationController extends GetxController {
  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxBool hasNextPage = true.obs;
  final int perPage = 20;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && !isLoading.value && hasNextPage.value) {
        loadMore();
      }
    });
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      notifications.clear();
      hasNextPage.value = true;
    }

    isLoading.value = true;
    try {
      final token = await LocalStorageService.getString('token');
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}notification/list?page=${currentPage.value}'),
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<NotificationItem> fetched = (data['data'] as List).map((item) => NotificationItem.fromJson(item)).toList();

        notifications.addAll(fetched);
        hasNextPage.value = data['pagination']['has_next_page'];
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasNextPage.value) return;
    currentPage.value++;
    await fetchNotifications();
  }

  Future<void> refreshList() async {
    await fetchNotifications(refresh: true);
  }
}

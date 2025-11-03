// ignore_for_file: avoid_print, depend_on_referenced_packages, prefer_is_empty
import 'dart:convert';

import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utills/appServices.dart';

class CommentController extends GetxController {
  final comments = <CommentModel>[].obs;
  final scrollController = ScrollController();
  final textController = TextEditingController();

  int pollId = 0;
  int page = 1;
  bool hasNextPage = true;
  bool isFetching = false;

  @override
  void onInit() {
    super.onInit();
    pollId = Get.arguments['poll_id'] ?? 0;
    fetchComments();
    scrollController.addListener(_scrollListener);
  }

  Future<void> fetchComments({bool isRefresh = false}) async {
    if (isFetching || (!hasNextPage && !isRefresh)) return;

    isFetching = true;

    if (isRefresh) {
      page = 1;
      hasNextPage = true;
      comments.clear();
    }

    final token = await LocalStorageService.getString('token');
    print("TOKEN = ${token}");
    final url = Uri.parse("${ApiService.baseUrl}poll/comments?poll_id=$pollId&page=$page");

    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List newComments = data["data"];
      final pagination = data["pagination"];
      hasNextPage = pagination["has_next_page"];

      final List<CommentModel> mapped = newComments.map<CommentModel>((e) => CommentModel.fromJson(e)).toList();

      comments.insertAll(comments.length == 0 ? 0 : comments.length, mapped); // Add older comments to TOP of list
      page++;
    }

    isFetching = false;
  }

  void _scrollListener() {
    if (scrollController.offset <= 100 && scrollController.position.userScrollDirection == ScrollDirection.reverse && hasNextPage && !isFetching) {
      fetchComments();
    }
  }

  Future<void> addComment() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final token = await LocalStorageService.getString('token');
    final url = Uri.parse("${ApiService.baseUrl}poll/post_comment");

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['poll_id'] = pollId.toString()
      ..fields['comment'] = text;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        textController.clear();
        Get.focusScope?.unfocus();
        await refreshComments(scrollToBottom: false);
      } else {
        print("Failed to post comment: ${response.body}");
      }
    } catch (e) {
      print("Error posting comment: $e");
    }
  }

  String getTimeAgo(String dateTimeString) {
    final DateTime createdAt = DateTime.parse(dateTimeString);
    final Duration diff = DateTime.now().difference(createdAt);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  Future<void> refreshComments({bool scrollToBottom = false}) async {
    await fetchComments(isRefresh: true);
    if (scrollToBottom && scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 200));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  void onClose() {
    textController.clear();
    scrollController.dispose();
    super.onClose();
  }
}

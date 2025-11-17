// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/models.dart';
import '../../../utills/appServices.dart';
import '../../../utills/localStorageService.dart';

class SearchTabController extends GetxController {
  final count = 0.obs;

  int currentPage = 1;
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  RxList<PollModel> searchResults = <PollModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMoreResults = true.obs;
  RxBool isRefreshing = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);

    searchController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 200), () {
      final search = searchController.text.trimString();
      print("search = ${search.length}");

      if (search.isNotEmpty) {
        fetchSearchResults(reset: true);
      } else {
        print("Else case");
        searchResults.value = [];
        isLoading.value = false;
      }
    });
  }

  Future<void> refreshSearch() async {
    isRefreshing.value = true;
    await fetchSearchResults(reset: true);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (hasMoreResults.value && !isLoading.value) {
        fetchSearchResults();
      }
    }
  }

  Future<void> fetchSearchResults({bool reset = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    if (reset) {
      currentPage = 1;
      hasMoreResults.value = true;
      searchResults.clear();
    }
    final search = searchController.text.trim();
    try {
      final token = await LocalStorageService.getString('token');
      final uri = Uri.parse('${ApiService.baseUrl}poll/active_polls?page=1&search=${search}&hashtag');

      print('Search API URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Cookie': 'fpw_zbt=t2d0kq2mlengrg673j3u7q21d3qsljgd',
        },
      );

      print('Search API Response Status: ${response.statusCode}');
      print('Search API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<dynamic> pollData = responseBody["data"];
        final List<PollModel> fetchedPolls = pollData.map((e) => PollModel.fromJson(e)).toList();

        if (reset) {
          searchResults.assignAll(fetchedPolls);
        } else {
          searchResults.addAll(fetchedPolls);
        }

        currentPage++;
        final pagination = responseBody["pagination"];
        hasMoreResults.value = pagination["has_next_page"] ?? false;

        print('Fetched ${fetchedPolls.length} polls, hasMore: ${hasMoreResults.value}');
      } else {
        print("Failed to fetch search results: ${response.statusCode}");
        print("Error response: ${response.body}");
      }
    } catch (e) {
      print("Error fetching search results: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

extension StringExtension on String {
  String trimString() {
    return trim();
  }
}

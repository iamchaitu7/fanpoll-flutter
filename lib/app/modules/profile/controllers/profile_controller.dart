// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/models/models.dart';
import 'package:get/get.dart';

// 
class ProfileController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  final api = ApiService();

  RxList<MyPollModel> polls = <MyPollModel>[].obs;
  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;
  RxBool isLoading = false.obs;
  RxBool isDataLoaded = false.obs;


  @override
  void onInit() {
    super.onInit();
    loadProfileAndPolls();
  }

  Future<void> loadProfileAndPolls() async {
    await fetchUserData();
    await fetchPolls(refresh: true);
    isDataLoaded.value = true;
  }

  Future<void> fetchUserData() async {
    final token = await LocalStorageService.getString('token');
    final profileResponse = await api.getProfile(token ?? "");
    final userData = profileResponse['data'];

    if (userData != null) {
      await LocalStorageService.saveData('logged_in_user', userData);
      user.value = UserModel.fromJson(userData);
      fetchPolls(refresh: true); // Fetch polls when user data loads
    }
  }

  Future<void> fetchPolls({bool refresh = false}) async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;

    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
    }

    final token = await LocalStorageService.getString('token');
    final userId = user.value?.id;

    final response = await api.getUserPolls(
        token ?? "", userId.toString(), currentPage.value);
    print("RESPONSE :: $response");

    if (response['status'] == 200) {
      final List<dynamic> data = response['data'];
      print("DATA :: $data");
      final List<MyPollModel> fetchedPolls =
          data.map((e) => MyPollModel.fromJson(e)).toList();

      print("FETCHED POLLS :: $fetchedPolls");

      if (refresh) {
        polls.assignAll(fetchedPolls);
        update();
      } else {
        polls.addAll(fetchedPolls);
      }

      final pagination = response['pagination'];
      hasMore.value = pagination['has_next_page'];
      currentPage.value++;
    }

    isLoading.value = false;
  }
}

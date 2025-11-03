import 'package:fan_poll/app/modules/search_tab/controllers/search_tab_controller.dart';
import 'package:get/get.dart';

class SearchTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchTabController>(
      () => SearchTabController(),
    );
  }
}

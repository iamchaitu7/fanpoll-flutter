import 'package:get/get.dart';

import '../controllers/following_controller.dart';

class FollowingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowingController>(
      () => FollowingController(),
    );
  }
}

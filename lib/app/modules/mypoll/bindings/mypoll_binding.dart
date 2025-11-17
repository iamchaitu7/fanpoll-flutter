import 'package:get/get.dart';

import '../controllers/mypoll_controller.dart';

class MypollBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MypollController>(
      () => MypollController(),
    );
  }
}

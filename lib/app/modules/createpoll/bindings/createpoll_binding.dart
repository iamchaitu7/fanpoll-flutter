import 'package:get/get.dart';

import '../controllers/createpoll_controller.dart';

class CreatepollBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatepollController>(
      () => CreatepollController(),
    );
  }
}

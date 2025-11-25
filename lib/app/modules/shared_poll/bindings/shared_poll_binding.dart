import 'package:get/get.dart';
import '../controllers/shared_poll_controller.dart';

class SharedPollBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedPollController>(
      () => SharedPollController(),
    );
  }
}

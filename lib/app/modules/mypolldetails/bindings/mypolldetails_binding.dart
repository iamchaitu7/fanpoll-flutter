import 'package:get/get.dart';

import '../controllers/mypolldetails_controller.dart';

class MypolldetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MypolldetailsController>(
      () => MypolldetailsController(),
    );
  }
}

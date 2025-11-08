import 'package:get/get.dart';

import '../about/controller.dart';
import '../main/controller.dart';
import 'controller.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<AboutController>(() => AboutController());
    Get.lazyPut<MainController>(() => MainController());
  }
}

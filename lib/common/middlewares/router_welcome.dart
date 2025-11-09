import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routers/names.dart';
import '../store/index.dart';

class RouterWelcomeMiddleware extends GetMiddleware {
  @override
  // ignore: overridden_fields
  int? priority = 0;

  RouterWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (ConfigStore.to.isFirstOpen == true) {
      return null;
    } else if (UserStore.to.isLogin == true) {
      return RouteSettings(name: RouteNames.application);
    } else {
      return RouteSettings(name: RouteNames.signIn);
    }
  }
}

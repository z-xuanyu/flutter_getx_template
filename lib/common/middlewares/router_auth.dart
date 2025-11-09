import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../routers/names.dart';
import '../store/index.dart';

/// 检查是否登录
class RouteAuthMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  // ignore: overridden_fields
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin ||
        route == RouteNames.signIn ||
        route == RouteNames.signUp ||
        route == RouteNames.inital) {
      return null;
    } else {
      Future.delayed(
        Duration(seconds: 1),
        () => Get.snackbar("提示", "登录过期,请重新登录"),
      );
      return RouteSettings(name: RouteNames.signIn);
    }
  }
}

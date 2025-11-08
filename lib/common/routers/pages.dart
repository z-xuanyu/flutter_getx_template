import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/index.dart';
import 'index.dart';

class RoutePages {
  static const inital = RouteNames.inital;
  static List<String> history = [];
  static final RouteObserver<Route> observer = RouteObservers();
  // 列表
  static List<GetPage> list = [
    GetPage(name: RouteNames.inital, page: () => const WelcomePage()),
    GetPage(
      name: RouteNames.application,
      page: () => const ApplicationPage(),
      binding: ApplicationBinding(),
    ),
    GetPage(name: RouteNames.signIn, page: () => const SignInPage()),
  ];
}

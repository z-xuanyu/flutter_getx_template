import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/index.dart';
import '../middlewares/index.dart';
import 'index.dart';

class RoutePages {
  static const inital = RouteNames.inital;
  static List<String> history = [];
  static final RouteObserver<Route> observer = RouteObservers();
  // 列表
  static List<GetPage> list = [
    // 欢迎
    GetPage(
      name: RouteNames.inital,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [RouterWelcomeMiddleware(priority: 1)],
    ),
    // 主页
    GetPage(
      name: RouteNames.application,
      page: () => const ApplicationPage(),
      binding: ApplicationBinding(),
      middlewares: [RouteAuthMiddleware(priority: 1)],
    ),
    // 登录页面
    GetPage(
      name: RouteNames.signIn,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),
    // 注册页面
    GetPage(
      name: RouteNames.signUp,
      page: () => const SignUpPage(),
      binding: SignUpBinding(),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/models/user.dart';
import '../../common/routers/names.dart';
import '../../common/store/user.dart';
import 'index.dart';

class SignInController extends GetxController {
  SignInController();

  final state = SignInState();

  // email的控制器
  final TextEditingController emailController = TextEditingController();
  // 密码的控制器
  final TextEditingController passController = TextEditingController();

  // tap
  void handleTap(int index) {
    Get.snackbar("标题", "消息");
  }

  // 跳转 注册界面
  handleNavSignUp() {
    Get.toNamed(RouteNames.signUp);
  }

  // 登录
  handleSignIn() {
    UserStore.to.saveProfile(UserLoginResponseEntity());
    Get.offAndToNamed(RouteNames.application);
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}

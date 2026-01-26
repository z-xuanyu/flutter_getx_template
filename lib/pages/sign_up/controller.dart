import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SignUpController extends GetxController {
  SignUpController();

  final state = SignUpState();

  // 表单控制器
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;

  // 表单状态
  RxBool agreeTerms = false.obs;
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  /// 处理注册
  void handleSignUp() {
    if (_validateForm()) {
      Get.snackbar(
        "成功",
        "注册成功！",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF2D9CDB),
      );
    }
  }

  /// 验证表单
  bool _validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar("错误", "请输入用户名");
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      Get.snackbar("错误", "请输入有效的邮箱");
      return false;
    }
    if (passController.text.isEmpty || passController.text.length < 6) {
      Get.snackbar("错误", "密码至少需要6个字符");
      return false;
    }
    if (passController.text != confirmPassController.text) {
      Get.snackbar("错误", "两次输入的密码不一致");
      return false;
    }
    if (!agreeTerms.value) {
      Get.snackbar("错误", "请同意服务条款");
      return false;
    }
    return true;
  }

  /// 返回登录页面
  void handleNavSignIn() {
    Get.back();
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}

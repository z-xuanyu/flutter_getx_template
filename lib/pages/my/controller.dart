import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyController extends GetxController {
  MyController();

  // 用户信息
  final RxString avatar = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix'.obs;
  final RxString username = 'Flutter User'.obs;
  final RxString email = 'flutter@example.com'.obs;

  // 统计数据
  final RxInt orderCount = 128.obs;
  final RxInt favoriteCount = 56.obs;
  final RxInt couponCount = 12.obs;

  // 设置状态
  final RxBool notificationsEnabled = true.obs;
  final RxBool darkModeEnabled = false.obs;

  _initData() {
    update(["my"]);
  }

  // 编辑个人资料
  void onEditProfile() {
    Get.snackbar(
      '编辑资料',
      '打开编辑个人资料页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 菜单项点击
  void onOrdersTap() {
    Get.snackbar(
      '我的订单',
      '打开订单列表页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onFavoritesTap() {
    Get.snackbar(
      '我的收藏',
      '打开收藏列表页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onCouponsTap() {
    Get.snackbar(
      '优惠券',
      '打开优惠券页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onSettingsTap() {
    Get.snackbar(
      '设置',
      '打开设置页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onHelpTap() {
    Get.snackbar(
      '帮助与反馈',
      '打开帮助中心',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onAboutTap() {
    Get.snackbar(
      '关于我们',
      '打开关于页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onPrivacyTap() {
    Get.snackbar(
      '隐私政策',
      '打开隐私政策页面',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 开关切换
  void onNotificationChanged(bool value) {
    notificationsEnabled.value = value;
    Get.snackbar(
      '通知设置',
      value ? '已开启通知' : '已关闭通知',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onDarkModeChanged(bool value) {
    darkModeEnabled.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    Get.snackbar(
      '深色模式',
      value ? '已开启深色模式' : '已关闭深色模式',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 退出登录
  void onLogout() {
    Get.defaultDialog(
      title: '确认退出',
      middleText: '您确定要退出登录吗？',
      textConfirm: '确定',
      textCancel: '取消',
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          '退出成功',
          '已安全退出登录',
          snackPosition: SnackPosition.BOTTOM,
        );
        // 这里可以添加清除登录状态和跳转到登录页面的逻辑
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}

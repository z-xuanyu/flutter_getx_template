import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MainController extends GetxController {
  MainController();

  final state = MainState();

  // 用户相关数据
  RxString userName = "张三".obs;
  RxString userEmail = "user@example.com".obs;
  RxInt userLevel = 5.obs;
  RxInt totalPoints = 2850.obs;

  // 功能菜单数据
  final List<MenuItemData> menuItems = [
    MenuItemData(
      icon: Icons.shopping_bag,
      title: "购物",
      subtitle: "浏览商品",
      color: Color(0xFF2D9CDB),
    ),
    MenuItemData(
      icon: Icons.heart_broken,
      title: "收藏",
      subtitle: "我的收藏",
      color: Color(0xFFFF6B6B),
    ),
    MenuItemData(
      icon: Icons.receipt,
      title: "订单",
      subtitle: "订单历史",
      color: Color(0xFFFFA500),
    ),
    MenuItemData(
      icon: Icons.settings,
      title: "设置",
      subtitle: "账户设置",
      color: Color(0xFF4ECDC4),
    ),
  ];

  // 快速操作
  List<QuickActionData> quickActions = [
    QuickActionData(
      icon: Icons.payment,
      label: "充值",
      onTap: () => Get.snackbar("充值", "跳转到充值页面"),
    ),
    QuickActionData(
      icon: Icons.card_giftcard,
      label: "优惠券",
      onTap: () => Get.snackbar("优惠券", "查看可用优惠券"),
    ),
    QuickActionData(
      icon: Icons.notifications,
      label: "消息",
      onTap: () => Get.snackbar("消息", "您有3条未读消息"),
    ),
    QuickActionData(
      icon: Icons.help,
      label: "帮助",
      onTap: () => Get.snackbar("帮助", "打开帮助中心"),
    ),
  ];

  // tap
  void handleTap(int index) {
    Get.snackbar(
      "菜单项 ${index + 1}",
      menuItems[index].title,
    );
  }

  void handleLogout() {
    Get.snackbar(
      "退出",
      "已安全退出",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
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

class MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class QuickActionData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  QuickActionData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ApplicationController extends GetxController {
  ApplicationController();

  final state = ApplicationState();
  // tab 页标题
  late final List<String> tabTitles;
  // 页控制器
  late final PageController pageController;
  // 底部导航项目
  late final List<BottomNavigationBarItem> bottomTabs;

  // tap
  void handleTap(int index) {
    Get.snackbar("标题", "消息");
  }

  // tab栏动画
  void handleNavBarTap(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  // tab栏页码切换
  void handlePageChanged(int page) {
    state.tabIndex = page;
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();

    tabTitles = ['首页', '关于'];
    bottomTabs = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      const BottomNavigationBarItem(icon: Icon(Icons.info), label: '关于'),
    ];
    pageController = PageController(initialPage: state.tabIndex);
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

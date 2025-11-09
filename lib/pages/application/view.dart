import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app.dart';
import '../about/view.dart';
import '../main/view.dart';
import 'index.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  // 顶部导航
  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Obx(
        () => Text(
          controller.tabTitles[controller.state.tabIndex],
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () => debugPrint('搜索')),
      ],
    );
  }

  // 内容页面
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
      children: <Widget>[MainPage(), AboutPage()],
    );
  }

  // 底部导航栏
  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        items: controller.bottomTabs,
        currentIndex: controller.state.tabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: controller.handleNavBarTap,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApplicationController>(
      builder: (_) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildPageView(),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }
}

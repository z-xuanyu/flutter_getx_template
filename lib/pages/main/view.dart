import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/index.dart';
import 'index.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// 用户信息卡片
                _buildUserCard(),

                SizedBox(height: 20.h),

                /// 快速操作栏
                _buildQuickActions(),

                SizedBox(height: 20.h),

                /// 功能菜单网格
                _buildMenuGrid(),

                SizedBox(height: 20.h),

                /// 推荐内容区域
                _buildRecommendations(),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 自定义 AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "首页",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D2D2F),
          letterSpacing: 0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Color(0xFF2D2D2F)),
          onPressed: () => Get.snackbar("消息", "您有3条未读消息"),
        ),
      ],
    );
  }

  /// 用户信息卡片
  Widget _buildUserCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryElement,
            AppColors.primaryElement.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryElement.withValues(alpha: 0.2),
            blurRadius: 20.w,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 上方：欢迎语 + 退出按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "欢迎回来！",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(
                    () => Text(
                      controller.userName.value,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: controller.handleLogout,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  child: Text(
                    "退出",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          /// 用户统计信息
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.star,
                  label: "等级",
                  value: Text('${controller.userLevel.value}'),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.cabin,
                  label: "积分",
                  value: Text("${controller.userLevel.value}"),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// 进度条
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: LinearProgressIndicator(
                value: 0.65,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "下一等级还需 350 积分",
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 统计项目
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Widget value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16.sp),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            value,
          ],
        ),
      ],
    );
  }

  /// 快速操作栏
  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: controller.quickActions
            .map(
              (action) => GestureDetector(
                onTap: action.onTap,
                child: Column(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10.w,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        action.icon,
                        color: AppColors.primaryElement,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      action.label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D2D2F),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  /// 功能菜单网格
  Widget _buildMenuGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.0,
        ),
        itemCount: controller.menuItems.length,
        itemBuilder: (context, index) {
          final item = controller.menuItems[index];
          return _buildMenuCard(item, index);
        },
      ),
    );
  }

  /// 菜单卡片
  Widget _buildMenuCard(MenuItemData item, int index) {
    return GestureDetector(
      onTap: () => controller.handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 15.w,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14.w),
            onTap: () => controller.handleTap(index),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Icon(item.icon, color: item.color, size: 26.sp),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2F),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 推荐内容区域
  Widget _buildRecommendations() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "推荐为您",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2F),
                ),
              ),
              GestureDetector(
                onTap: () => Get.snackbar("查看全部", "查看更多推荐内容"),
                child: Text(
                  "查看全部 >",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryElement,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 140.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 12.w,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryElement.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.w),
                          topRight: Radius.circular(12.w),
                        ),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 40.sp,
                        color: AppColors.primaryElement.withValues(alpha: 0.3),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "推荐商品 ${index + 1}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D2D2F),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

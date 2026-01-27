import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/logout_button.dart';
import 'widgets/menu_item.dart';
import 'widgets/profile_header.dart';
import 'widgets/section_title.dart';
import 'widgets/stats_card.dart';
import 'widgets/version_info.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MyViewGetX();
  }
}

class _MyViewGetX extends GetView<MyController> {
  const _MyViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 个人资料头部
          Obx(
            () => ProfileHeader(
              avatar: controller.avatar.value,
              username: controller.username.value,
              email: controller.email.value,
              onEdit: controller.onEditProfile,
            ),
          ),
          SizedBox(height: 8.h),

          // 统计数据卡片
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Obx(
                  () => StatsCard(
                    label: '订单',
                    value: controller.orderCount.value.toString(),
                    icon: Icons.shopping_bag_rounded,
                    onTap: controller.onOrdersTap,
                  ),
                ),
                SizedBox(width: 12.w),
                Obx(
                  () => StatsCard(
                    label: '收藏',
                    value: controller.favoriteCount.value.toString(),
                    icon: Icons.favorite_rounded,
                    color: Colors.red,
                    onTap: controller.onFavoritesTap,
                  ),
                ),
                SizedBox(width: 12.w),
                Obx(
                  () => StatsCard(
                    label: '优惠券',
                    value: controller.couponCount.value.toString(),
                    icon: Icons.confirmation_number_rounded,
                    color: Colors.orange,
                    onTap: controller.onCouponsTap,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // 功能菜单
          const SectionTitle(title: '我的服务'),
          MenuItem(
            icon: Icons.settings_rounded,
            title: '设置',
            onTap: controller.onSettingsTap,
          ),
          MenuItem(
            icon: Icons.notifications_rounded,
            title: '消息通知',
            subtitle: '接收系统消息推送',
            onTap: () {},
          ),
          Obx(
            () => MenuSwitchItem(
              icon: Icons.notifications_active_rounded,
              title: '通知开关',
              value: controller.notificationsEnabled.value,
              onChanged: controller.onNotificationChanged,
            ),
          ),
          MenuItem(
            icon: Icons.help_outline_rounded,
            title: '帮助与反馈',
            onTap: controller.onHelpTap,
          ),
          SizedBox(height: 24.h),

          // 更多设置
          const SectionTitle(title: '更多'),
          MenuItem(
            icon: Icons.info_outline_rounded,
            title: '关于我们',
            onTap: controller.onAboutTap,
          ),
          MenuItem(
            icon: Icons.privacy_tip_outlined,
            title: '隐私政策',
            onTap: controller.onPrivacyTap,
          ),
          Obx(
            () => MenuSwitchItem(
              icon: Icons.dark_mode_rounded,
              title: '深色模式',
              subtitle: '切换应用主题',
              value: controller.darkModeEnabled.value,
              onChanged: controller.onDarkModeChanged,
            ),
          ),
          SizedBox(height: 16.h),

          // 退出登录按钮
          LogoutButton(
            onTap: controller.onLogout,
          ),

          // 版本信息
          const VersionInfo(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyController>(
      init: MyController(),
      id: "my",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '我的',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded),
                onPressed: () {
                  Get.snackbar(
                    '扫一扫',
                    '打开扫码功能',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildView(),
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return const Column(
      children: [
        AppHeader(),
        SizedBox(height: 32),
        DescriptionCard(),
        InfoSection(
          title: '应用信息',
          children: [
            InfoCard(
              icon: Icons.code,
              title: '技术栈',
              subtitle: 'Flutter 3.24+ • GetX 4.6+',
            ),
            InfoCard(
              icon: Icons.update,
              title: '检查更新',
              subtitle: '当前已是最新版本',
            ),
            InfoCard(
              icon: Icons.storage,
              title: '数据统计',
              subtitle: '暂无数据',
            ),
          ],
        ),
        InfoSection(
          title: '相关链接',
          children: [
            InfoCard(
              icon: Icons.star_outline,
              title: '开源协议',
              subtitle: 'MIT License',
            ),
            InfoCard(
              icon: Icons.help_outline,
              title: '帮助中心',
              subtitle: '使用指南与常见问题',
            ),
          ],
        ),
        Footer(),
      ],
    );
  }
}
 
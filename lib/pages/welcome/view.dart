import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
      init: WelcomeController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("welcome")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}

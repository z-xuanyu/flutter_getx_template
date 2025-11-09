import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("sign_up")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}

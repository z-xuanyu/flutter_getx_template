import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("sign_in")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}

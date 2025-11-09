import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// hello
class HelloWidget extends GetView<WelcomeController> {
  const HelloWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => controller.handleNavSignIn(),
        child: Text('下一步'),
      ),
    );
  }
}

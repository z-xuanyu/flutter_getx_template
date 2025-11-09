import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/index.dart';
import 'index.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF3F5F9), Color(0xFFF60F60)],
            ),
          ),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                padding: EdgeInsets.all(30.w),
                child: Column(
                  children: [
                    SizedBox(height: 160.h),
                    // email input
                    inputTextEdit(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Email",
                      marginTop: 0,
                      // autofocus: true,
                    ),
                    // // password input
                    inputTextEdit(
                      controller: controller.passController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: "Password",
                      isPassword: true,
                    ),
                    // 注册、登录 横向布局
                    Container(
                      height: 44.h,
                      margin: EdgeInsets.only(top: 15.h),
                      child: Row(
                        children: [
                          // 注册
                          btnFlatButtonWidget(
                            onPressed: controller.handleNavSignUp,
                            gbColor: AppColors.thirdElement,
                            title: "Sign up",
                          ),
                          Spacer(),
                          // 登录
                          btnFlatButtonWidget(
                            onPressed: controller.handleSignIn,
                            gbColor: AppColors.primaryElement,
                            title: "Sign in",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

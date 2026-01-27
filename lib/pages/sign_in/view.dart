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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF1A1A2E), // 深蓝色-暗色背景
                Color(0xFF16213E), // 更深的蓝色
                Color(0xFF0F3460), // 海洋蓝
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),

                    /// 品牌标题区域
                    _buildBrandSection(),

                    SizedBox(height: 60.h),

                    /// 登录表单区域
                    _buildLoginForm(context),

                    SizedBox(height: 40.h),

                    /// 底部链接区域
                    _buildFooterLinks(),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 品牌标题区域
  Widget _buildBrandSection() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Sign in to your account",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  /// 登录表单区域
  Widget _buildLoginForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3460).withValues(alpha: 0.3),
            blurRadius: 30.w,
            offset: Offset(0, 15.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 邮箱输入框
          _buildInputField(
            controller: controller.emailController,
            label: "Email Address",
            hintText: "name@example.com",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 20.h),

          /// 密码输入框
          _buildInputField(
            controller: controller.passController,
            label: "Password",
            hintText: "••••••••",
            icon: Icons.lock_outline,
            isPassword: true,
          ),

          SizedBox(height: 16.h),

          /// 忘记密码链接
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // 处理忘记密码逻辑
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryElement,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          SizedBox(height: 28.h),

          /// 按钮组
          Row(
            children: [
              /// 注册按钮
              Expanded(
                child: _buildButton(
                  onPressed: controller.handleNavSignUp,
                  title: "Sign up",
                  isPrimary: false,
                ),
              ),
              SizedBox(width: 12.w),
              /// 登录按钮
              Expanded(
                child: _buildButton(
                  onPressed: controller.handleSignIn,
                  title: "Sign in",
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 输入框组件
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2F),
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12.w, right: 8.w),
                child: Icon(
                  icon,
                  color: Colors.grey.withValues(alpha: 0.6),
                  size: 18.sp,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 40.w),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2D2D2F),
            ),
          ),
        ),
      ],
    );
  }

  /// 按钮组件
  Widget _buildButton({
    required VoidCallback onPressed,
    required String title,
    required bool isPrimary,
  }) {
    return SizedBox(
      height: 48.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10.w),
          child: Container(
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [
                        AppColors.primaryElement,
                        AppColors.primaryElement.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: !isPrimary
                  ? const Color(0xFFF0F0F0)
                  : null,
              borderRadius: BorderRadius.circular(10.w),
              border: !isPrimary
                  ? Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isPrimary
                      ? Colors.white
                      : const Color(0xFF2D2D2F),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 底部链接区域
  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        GestureDetector(
          onTap: controller.handleNavSignUp,
          child: Text(
            "Create one",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

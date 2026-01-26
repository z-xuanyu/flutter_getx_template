import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/index.dart';
import 'index.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
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
              appBar: _buildAppBar(),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),

                    /// 品牌标题区域
                    _buildBrandSection(),

                    SizedBox(height: 40.h),

                    /// 注册表单区域
                    _buildSignUpForm(),

                    SizedBox(height: 30.h),

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

  /// 自定义 AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: controller.handleNavSignIn,
      ),
      title: Text(
        "Create Account",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      centerTitle: true,
    );
  }

  /// 品牌标题区域
  Widget _buildBrandSection() {
    return Column(
      children: [
        Text(
          "Join Us Today",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Create your account to get started",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  /// 注册表单区域
  Widget _buildSignUpForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3460).withOpacity(0.3),
            blurRadius: 30.w,
            offset: Offset(0, 15.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 用户名输入框
          _buildInputField(
            controller: controller.nameController,
            label: "Full Name",
            hintText: "John Doe",
            icon: Icons.person_outline,
            keyboardType: TextInputType.text,
          ),

          SizedBox(height: 16.h),

          /// 邮箱输入框
          _buildInputField(
            controller: controller.emailController,
            label: "Email Address",
            hintText: "name@example.com",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 16.h),

          /// 密码输入框
          Obx(
            () => _buildPasswordField(
              controller: controller.passController,
              label: "Password",
              hintText: "••••••••",
              icon: Icons.lock_outline,
              showPassword: controller.showPassword.value,
              onToggle: () => controller.showPassword.toggle(),
            ),
          ),

          SizedBox(height: 16.h),

          /// 确认密码输入框
          Obx(
            () => _buildPasswordField(
              controller: controller.confirmPassController,
              label: "Confirm Password",
              hintText: "••••••••",
              icon: Icons.lock_outline,
              showPassword: controller.showConfirmPassword.value,
              onToggle: () => controller.showConfirmPassword.toggle(),
            ),
          ),

          SizedBox(height: 20.h),

          /// 服务条款复选框
          Obx(
            () => _buildTermsCheckbox(),
          ),

          SizedBox(height: 24.h),

          /// 注册按钮
          _buildSignUpButton(),

          SizedBox(height: 16.h),
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
              color: Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.withOpacity(0.5),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12.w, right: 8.w),
                child: Icon(
                  icon,
                  color: Colors.grey.withOpacity(0.6),
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

  /// 密码输入框（带显示/隐藏按钮）
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required bool showPassword,
    required VoidCallback onToggle,
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
              color: Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: !showPassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.withOpacity(0.5),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12.w, right: 8.w),
                child: Icon(
                  icon,
                  color: Colors.grey.withOpacity(0.6),
                  size: 18.sp,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 40.w),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.withOpacity(0.6),
                    size: 18.sp,
                  ),
                ),
              ),
              suffixIconConstraints: BoxConstraints(minWidth: 40.w),
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

  /// 服务条款复选框
  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.agreeTerms.toggle(),
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: controller.agreeTerms.value
                  ? AppColors.primaryElement
                  : Colors.white,
              border: Border.all(
                color: controller.agreeTerms.value
                    ? AppColors.primaryElement
                    : Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: controller.agreeTerms.value
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.sp,
                  )
                : null,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "I agree to the ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF2D2D2F),
                  ),
                ),
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primaryElement,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: " and ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF2D2D2F),
                  ),
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primaryElement,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 注册按钮
  Widget _buildSignUpButton() {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.handleSignUp,
          borderRadius: BorderRadius.circular(10.w),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryElement,
                  AppColors.primaryElement.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.w),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryElement.withOpacity(0.3),
                  blurRadius: 15.w,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
          "Already have an account? ",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        GestureDetector(
          onTap: controller.handleNavSignIn,
          child: Text(
            "Sign in",
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

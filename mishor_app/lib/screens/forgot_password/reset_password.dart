import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/text_field.dart';
import 'package:mishor_app/services/forgot_password.dart';

class ResetPasswordScreen extends StatelessWidget {
  final _resetCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Call PasswordService to handle password reset
  void _resetPassword(BuildContext context) async {
    String resetCode = _resetCodeController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (resetCode.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    bool success = await PasswordService().resetPassword(resetCode, password,confirmPassword);

    if (success) {
      Get.snackbar('Success', 'Password has been reset successfully');
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.snackbar('Error', 'Failed to reset password');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);
    return Scaffold(
      backgroundColor: AppColors.Col_White,
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _resetCodeController,
              label: 'Reset Code',
              icon: Icons.lock,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: _passwordController,
              label: 'New Password',
              icon: Icons.lock,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

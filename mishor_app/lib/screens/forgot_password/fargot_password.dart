import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/services/forgot_password.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/text_field.dart';

class ForgotPasswordPopup extends StatelessWidget {
  final _emailController = TextEditingController();

  // Call AuthService to handle forgot password
  void _forgotPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }

    // Call the PasswordService to handle the API call
    bool success = await PasswordService().sendResetCode(email);

    if (success) {
      Get.snackbar('Success', 'Reset code has been sent to your email');
      // Redirect to reset password screen
      Get.toNamed(AppRoutes.resetPassword);
    } else {
      Get.snackbar('Error', 'Failed to send reset code');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);
    return Scaffold(
      backgroundColor: AppColors.Col_White,
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _forgotPassword(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

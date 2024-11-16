import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/services/change_password_service.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/widgets/helping_global/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreen createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ChangePasswordService _changePasswordService = ChangePasswordService();
  String? userToken;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        centerTitle: true,
        backgroundColor: AppColors.Col_White,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _oldPasswordController,
                label: 'Old Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: _newPasswordController,
                label: 'New Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 30.h),
              userToken == null
                  ? CircularProgressIndicator() // Wait if the token isn't available
                  : SizedBox(
                      width: 270.w,
                      height: 60.h,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () {
                            if (_validatePasswordFields()) {
                              _changePassword();
                            }
                          },
                          child: Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validatePasswordFields() {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      _showError('Please enter your old password.');
      return false;
    }
    if (newPassword.isEmpty) {
      _showError('Please enter your new password.');
      return false;
    }
    if (confirmPassword.isEmpty) {
      _showError('Please confirm your new password.');
      return false;
    }
    if (newPassword != confirmPassword) {
      _showError('New password and confirm password do not match.');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      '',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _changePassword() async {
    if (userToken != null) {
      final result = await _changePasswordService.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
        userToken: userToken!,
      );

      if (result) {
        SnackBar(
          content: Text('Password updated successfully.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        );
      }
    } else {
      _showError('User token not found.');
    }
  }
}

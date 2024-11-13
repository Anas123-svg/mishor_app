import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/controllers/auth_controller.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/widgets/helping_global/text_field.dart';

class LoginScreen extends StatelessWidget {
  final _authController = Get.put(AuthController());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 100.h,
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                controller: _emailController,label: 'Email',icon: Icons.email,
              ),
              SizedBox(height: 20.h),

              CustomTextField(
                controller: _passwordController,label: 'Password',icon: Icons.lock,obscureText: true,
              ),
              SizedBox(height: 10.h),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFD42427),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Obx(() {
                return _authController.isLoading.value
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50.w/1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () {
                            _authController.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
              }),
              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.signup);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFD42427),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

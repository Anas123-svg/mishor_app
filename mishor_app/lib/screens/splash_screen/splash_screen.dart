import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/Routes/app_routes.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/utilities/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AppImages.logo,  
                width: 200.w,         
                height: 200.h,      
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}

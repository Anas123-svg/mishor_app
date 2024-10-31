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
      body: Center(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AppImages.logo,  
                width: 176.w,         
                height: 176.h,      
              ),
              SizedBox(height:40.h),
              Text(
                "Safety Culture",
                style: AppTexts.fontw600s30.copyWith(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: "Inter",
                ),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}

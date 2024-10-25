import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:get/get.dart';
import 'package:mishor_app/routes/app_routes.dart';

class SignUpScreen extends StatelessWidget {
  final List<String> companies = [
    'ABC Construction',
    'BuildWell Ltd.',
    'ConStruct',
    'Prime Builders',
    'Urban Development Co.',
  ];

  String? selectedCompany; 

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,), // Back arrow icon
          onPressed: () {
            Get.toNamed(AppRoutes.login); // Navigate back to login
          },
        ),
      ),
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
              SizedBox(height: 30.h),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0xFFD42427)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person, color: Color(0xFFD42427)),
                ),
              ),
              SizedBox(height: 15.h),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFFD42427)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email, color: Color(0xFFD42427)),
                ),
              ),
              SizedBox(height: 15.h),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFFD42427)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFD42427)),
                ),
              ),
              SizedBox(height: 15.h),

              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Color(0xFFD42427)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.phone, color: Color(0xFFD42427)),
                ),
              ),
              SizedBox(height: 15.h),

              DropdownButtonFormField<String>(
                value: selectedCompany,
                decoration: InputDecoration(
                  labelText: 'Select Construction Company',
                  labelStyle: TextStyle(color: Color(0xFFD42427)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Color(0xFFD42427)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: companies.map((String company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                onChanged: (String? value) {
                  selectedCompany = value; 
                },
              ),
              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD42427),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
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
}

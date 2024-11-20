import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/Routes/app_routes.dart';
import 'package:mishor_app/models/user.dart';
import 'package:mishor_app/utilities/api.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token != null) {
      bool isValid = await _validateToken(token);
      if (isValid) {
        Get.offAllNamed(AppRoutes.bottomNavBar);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

Future<bool> _validateToken(String token) async {
  try {
    print(token);
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/user/show'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);

      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      
      User user = User.fromJson(jsonResponse);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id.toString());
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_phone', user.phone);
      await prefs.setString('profile_image', user.profileImage ?? '');
      await prefs.setString('user_token', user.token);

      return true; 
    } else {
      print('Token is invalid or request failed');
      return false;
    }
  } catch (e) {
    debugPrint('Error validating token: $e');
    return false;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              AppImages.logo,
              width: 200.w,
              height: 200.h,
            ),
            SizedBox(height: 6.h),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class drawer extends StatelessWidget { 
  const drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Icon(Icons.account_circle, size: 60.w, color: Colors.white),
                  SizedBox(height: 8.h),
                  Text(
                    'Welcome, User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),  // White icon
              title: Text('Home', style: TextStyle(fontSize: 18.sp, color: Colors.white)),  // White text
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),  // White icon
              title: Text('Settings', style: TextStyle(fontSize: 18.sp, color: Colors.white)),  // White text
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),  // White icon
              title: Text('Logout', style: TextStyle(fontSize: 18.sp, color: Colors.white)),  // White text
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

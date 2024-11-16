import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class buildWelcomeMessage extends StatelessWidget {
  const buildWelcomeMessage({
    super.key,
    required this.ProfileImage,
    required this.userName,
  });

  final String? ProfileImage;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile section
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 60.r,  // Adjusted to make it bigger and centered
              backgroundColor: AppColors.primary,
              child: CircleAvatar(
                radius: 55.r, 
                backgroundImage: NetworkImage(
                  ProfileImage ?? 'https://static-00.iconduck.com/assets.00/user-icon-2048x2048-ihoxz4vq.png',
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 20.r,  // Camera icon size
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, size: 18.r, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),

        // Welcome and intro text
        SizedBox(height: 15.h),  // Add some space between profile and text
        Text(
          'Welcome, ${userName}',
          style: TextStyle(
            fontSize: 22.sp,  // Responsive font size
            fontWeight: FontWeight.w600,
            color: AppColors.Col_White,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Text(
                'Safety is our top priority.',
                style: TextStyle(
                  fontSize: 10.sp,  // Responsive font size
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'We promote a culture of responsibility.',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'All operations are guided by safety standards.',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'We ensure safety is at the forefront of everything.',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Together, we create a safe working environment.',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

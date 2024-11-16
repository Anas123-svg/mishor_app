import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class Instructions extends StatelessWidget {
  const Instructions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 45.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              '• Ensure all inspections are completed on time.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color.fromARGB(255, 6, 6, 6),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '• Track performance metrics regularly.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color.fromARGB(255, 6, 6, 6),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '• Report any delays or issues immediately.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color.fromARGB(255, 6, 6, 6),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '• Stay informed about upcoming inspections.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color.fromARGB(255, 6, 6, 6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



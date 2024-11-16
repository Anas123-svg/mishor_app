import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/models/assessment_stats.dart';

class buildInspectionCard extends StatelessWidget {
  const buildInspectionCard({
    super.key,
    required this.assessment,
  });
  final Assessment assessment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.assignment_add, // Correct way to reference the 'assessment' icon
                color: Colors.white, // Optional: Adjust icon color if needed
                size: 30.0, // Optional: Adjust the size of the icon if needed
              ),
/*Text(
                assessment.id.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),*/
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspection: ${assessment.name}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Location: ${assessment.Location}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Date: ${assessment.updatedAt}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Status: ${assessment.status}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey.shade500,
            size: 18.r,
          ),
        ],
      ),
    );
  }
}

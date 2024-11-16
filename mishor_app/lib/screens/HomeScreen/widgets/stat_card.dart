import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/utilities/app_colors.dart';


class buildStatisticsCards extends StatelessWidget {
  const buildStatisticsCards({
    super.key,
    required this.context,
    required this.assessmentCount,
  });

  final BuildContext context;
  final AssessmentStats assessmentCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: buildStatCard(context: context, title: 'Total', value: assessmentCount.totalAssessments.toString(), icon: Icons.list)),
        SizedBox(width: 5.w),
        Expanded(
            child: buildStatCard(context: context, title: 'Approved', value: assessmentCount.completedAssessments.toString(), icon: Icons.check_circle_outline)),
        SizedBox(width: 5.w),
        Expanded(
            child: buildStatCard(context: context, title: 'Assigned', value: assessmentCount.assignedAssessments.toString(), icon: Icons.assignment_add)),

        SizedBox(width: 5.w),
        Expanded(
            child: buildStatCard(context: context, title: 'Pending', value: assessmentCount.pendingAssessments.toString(), icon: Icons.pending_actions)),
      ],
    );
  }
}




class buildStatCard extends StatelessWidget {
  const buildStatCard({
    super.key,
    required this.context,
    required this.title,
    required this.value,
    required this.icon,
  });

  final BuildContext context;
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenOrientation = MediaQuery.of(context)
        .orientation; // Check for screen orientation (landscape or portrait)
    final isSmallScreen = screenSize.width < 530;
    final isPortrait = screenOrientation == Orientation.portrait;

    double cardWidth =
        isSmallScreen ? screenSize.width * 0.4 : screenSize.width * 0.3;
    double cardHeight = isSmallScreen
        ? (isPortrait ? 120.h : 100.h)
        : (isPortrait ? 150.h : 130.h);
    double iconSize = isSmallScreen ? 30.r : 23.r;
    double titleFontSize =
        isSmallScreen ? 12.sp : 12.sp; // Adjusted font size for title
    double valueFontSize =
        isSmallScreen ? 10.sp : 10.sp; // Adjusted font size for value
    double paddingValue =
        isSmallScreen ? 8.w : 2.w; // Padding that adapts to screen size

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.all(paddingValue),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            spreadRadius: 1.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Ensures everything is centered
        children: [
          Icon(icon, size: iconSize, color: Colors.white),
          SizedBox(height: 8.h), // Adding space between icon and text
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
            textAlign: TextAlign.center, // Ensures title is centered
          ),
          SizedBox(height: 4.h), // Space between title and value
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: valueFontSize,
            ),
            textAlign: TextAlign.center, // Ensures value is centered
          ),
        ],
      ),
    );
  }
}

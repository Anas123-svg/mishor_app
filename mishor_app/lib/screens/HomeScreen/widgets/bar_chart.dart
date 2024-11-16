import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class buildBarChart extends StatelessWidget {
  const buildBarChart({
    super.key,
    required this.barData,
  });

  final List<BarChartGroupData> barData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.2),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.r,
            spreadRadius: 2.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          barGroups: barData.map((data) {
            return BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.barRods[0].toY,
                  width: 16,
                  rodStackItems: [],
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
                reservedSize: 30.w,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

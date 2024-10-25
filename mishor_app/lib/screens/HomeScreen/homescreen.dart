import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int totalInspections = 150;
  final int completedInspections = 120;
  final int pendingInspections = 30;
  final double compliancePercentage = 80.0;
  String searchQuery = '';

  List<String> assignedInspections = [
    'Inspection 1',
    'Inspection 2 (Rejected)',
    'Inspection 3',
    'Inspection 4 (Rejected)',
  ];

  List<BarChartGroupData> inspectionBarData = [
    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 30, color: AppColors.primary)]),
    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 40, color: Colors.green)]),
    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 50, color: Colors.blue)]),
    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 60, color: Colors.purple)]),
    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 80, color: Colors.orange)]),
    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 90, color: Colors.red)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const  CustomAppbar(),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeMessage(),
              SizedBox(height: 20.h),
              _buildStatisticsCards(),
              SizedBox(height: 20.h),

              Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r), 
                ),
                margin: EdgeInsets.symmetric(vertical: 10.h), 
                child: Padding(
                  padding: EdgeInsets.all(16.w), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stay updated on inspections performed in the past week with ease.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center, 
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Inspection Performance',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildBarChart(inspectionBarData),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                'Assigned for this week',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              InspectionsList(
                inspections: assignedInspections
                    .where((inspection) => inspection.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList(),
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                onUploadDocument: () {
                },
                onSignOff: (inspection) {
                },
              ),
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
        },
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundColor: AppColors.primary.withOpacity(0.8),
          child: Icon(Icons.person, size: 30.r, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, User!',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Here\'s your latest inspection data',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildStatCard('Total', totalInspections.toString(), Icons.list)),
        SizedBox(width: 5.w),
        Expanded(child: _buildStatCard('Completed', completedInspections.toString(), Icons.check_circle_outline)),
        SizedBox(width: 5.w),
        Expanded(child: _buildStatCard('Pending', pendingInspections.toString(), Icons.pending_actions)),
        SizedBox(width: 5.w),
        Expanded(child: _buildStatCard('Compliance', '$compliancePercentage%', Icons.verified_user)),
      ],
    );
  }

  Widget _buildChartWithStats({required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: chart),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> barData) {
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
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Here are some additional insights based on recent inspection data. Keep up the good work and maintain the safety standards.',
          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
      ],
    );
  }

Widget _buildStatCard(String title, String value, IconData icon) {
  final screenSize = MediaQuery.of(context).size;

  double cardWidth = screenSize.width < 600 ? 80.w : 100.w; 
  double cardHeight = screenSize.width < 600 ? 100.h : 120.h; 
  double iconSize = screenSize.width < 600 ? 40.r : 50.r; 
  double titleFontSize = screenSize.width < 600 ? 10.sp : 12.sp; 
  double valueFontSize = screenSize.width < 600 ? 16.sp : 18.sp;
  double paddingValue = screenSize.width < 600 ? 8.w : 12.w;

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
      children: [
        Icon(icon, size: iconSize, color: Colors.white),
        SizedBox(height: 6.h),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: valueFontSize,
          ),
        ),
      ],
    ),
  );
}

}


class InspectionsList extends StatelessWidget {
  final List<String> inspections;
  final Function(String) onSignOff;
  final Function onUploadDocument;
  final Function(String) onSearchChanged;

  const InspectionsList({
    Key? key,
    required this.inspections,
    required this.onSearchChanged,
    required this.onSignOff,
    required this.onUploadDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Inspections...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => onSearchChanged(value),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, 
            itemCount: inspections.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12),
            itemBuilder: (context, index) {
              final inspection = inspections[index];
              final isFlagged = inspection.contains('Rejected');

              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h), 
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  title: Text(
                    inspection,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.cancel, 
                          color: isFlagged ? Colors.red : Colors.grey, 
                        ),
                        onPressed: () => onUploadDocument(),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.check_circle, 
                          color: !isFlagged ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => onSignOff(inspection),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

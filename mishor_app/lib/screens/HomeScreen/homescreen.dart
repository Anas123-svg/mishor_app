import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data for statistics
  final int totalInspections = 150;
  final int completedInspections = 120;
  final int pendingInspections = 30;
  final double compliancePercentage = 80.0;

  // Sample data for the trend graphs
  List<FlSpot> inspectionTrends = [
    FlSpot(1, 30),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 60),
    FlSpot(5, 80),
    FlSpot(6, 90),
  ];

  List<FlSpot> complianceTrends = [
    FlSpot(1, 70),
    FlSpot(2, 75),
    FlSpot(3, 80),
    FlSpot(4, 85),
    FlSpot(5, 90),
    FlSpot(6, 95),
  ];

  List<double> pieChartData = [20, 30, 50]; // Example data for Pie Chart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety Inspections',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for different graph types
              Text(
                'Trends in Inspections',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildLineChart(
                      inspectionTrends,
                      'Inspection Trends',
                      Colors.red,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildPieChart(pieChartData),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Safety Culture Text
              Text(
                'Fostering a Strong Safety Culture',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'A strong safety culture ensures that safety becomes a fundamental value in all aspects of our operations. '
                'By conducting regular safety inspections and promoting awareness, we minimize risks and maintain a safe working environment. '
                'Remember, safety is a shared responsibility that requires consistent attention and commitment.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.h),

              // Welcome Message
              Text(
                'Welcome, User!',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 16.h),

              // Statistics Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Total', totalInspections.toString()),
                  _buildStatCard('Completed', completedInspections.toString()),
                  _buildStatCard('Pending', pendingInspections.toString()),
                  _buildStatCard('Compliance', '$compliancePercentage%'),
                ],
              ),
              SizedBox(height: 20.h),

              // Compliance Trends Chart
              Text(
                'Compliance Trends',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 10.h),
              _buildLineChart(complianceTrends, 'Compliance Trends', Colors.greenAccent),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Handle adding new inspection
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 80.w,
      height: 100.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent.withOpacity(0.8), Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> spots, String title, Color lineColor) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            //leftTitles: SideTitles(showTitles: true, reservedSize: 38),
            //bottomTitles: SideTitles(showTitles: true, reservedSize: 38),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
             // colors: [lineColor],
            //  dotData: FlDotData(show: true, dotColor: lineColor, dotSize: 4),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<double> data) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: data[0],
              color: Colors.red,
              title: '${data[0]}%',
              radius: 40,
              titleStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: data[1],
              color: Colors.blue,
              title: '${data[1]}%',
              radius: 40,
              titleStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: data[2],
              color: Colors.green,
              title: '${data[2]}%',
              radius: 40,
              titleStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 30,
        ),
      ),
    );
  }
}

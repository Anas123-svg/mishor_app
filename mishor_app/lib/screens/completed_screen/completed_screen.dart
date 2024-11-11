import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:mishor_app/widgets/helping_global/inspection_list.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  String searchQuery = '';
  
  String selectedFilter = 'Completed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatistics(),

              SizedBox(height: 24.h),
                            Text(
                'Completed Inspections',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search inspections...',
                        hintStyle: TextStyle(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.w200),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColors.primary),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: AppColors.primary),
                    onPressed: () {
                      _showFilterOptions(context);
                    },
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5, 
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Completed Inspection ${index + 1} selected')),
                      );
                    },
                    child: buildInspectionCard(index: index),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildStatistics() {
  return Card(
    elevation: 8,
    child: Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),

          SizedBox(
            height: 100.h,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 20.h,
                sections: showingSections(),
              ),
            ),
          ),

          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCard('Completed', '15'),
              _statCard('In Review', '7'),
              _statCard('Archived', '5'),
            ],
          ),
        ],
      ),
    ),
  );
}

List<PieChartSectionData> showingSections() {
  return List.generate(3, (index) {
    switch (index) {
      case 0:
        return PieChartSectionData(
          color: AppColors.primary,
          value: 15,
          title: 'Completed',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      case 1:
        return PieChartSectionData(
          color: Colors.orange,
          value: 7,
          title: 'In Review',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      case 2:
        return PieChartSectionData(
          color: Colors.red,
          value: 5,
          title: 'Rejected',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      default:
        throw Error();
    }
  });
}
  Widget _statCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Completed'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Completed';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('In Review'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'In Review';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Archived'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Archived';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

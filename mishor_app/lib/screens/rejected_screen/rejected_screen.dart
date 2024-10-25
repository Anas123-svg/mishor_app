import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart ';

class RejectedScreen extends StatefulWidget {
  const RejectedScreen({super.key});

  @override
  _RejectedScreen createState() => _RejectedScreen();
}

class _RejectedScreen extends State<RejectedScreen> {
  String searchQuery = '';
  String selectedFilter = 'Rejected';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const  CustomAppbar(),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                            Text(
                'Rejected Inspections',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 16.h),
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
                        SnackBar(content: Text('Rejected Inspection ${index + 1} selected')),
                      );
                    },
                    child: _buildInspectionCard(index),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildInspectionCard(int index) {
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
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed Inspection ${index + 1}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Location: Completed Location ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Date: ${DateTime.now().subtract(Duration(days: index)).toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Status: Rejected',
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


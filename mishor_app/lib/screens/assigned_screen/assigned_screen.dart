import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';

class AssignedScreen extends StatefulWidget {
  const AssignedScreen({super.key});

  @override
  _AssignedScreenState createState() => _AssignedScreenState();
}

class _AssignedScreenState extends State<AssignedScreen> {
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
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Inspections',
                        hintStyle: TextStyle(color: AppColors.primary, fontSize: 16.sp),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: AppColors.primary),
                    onPressed: () {
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusCard('Total Assigned', '12', AppColors.primary),
                  _buildStatusCard('Completed', '8', Colors.green),
                  _buildStatusCard('Pending', '3', Colors.orange),
                  _buildStatusCard('Rejected', '1', Colors.red),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                'Assigned Inspections',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w100,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
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
                        SnackBar(content: Text('Inspection ${index + 1} selected')),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.r),
        onPressed: () {
        },
      ),
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
                  'Status: Assigned',
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

  Widget _buildStatusCard(String title, String count, Color color) {
    return Container(
      width: 80.w,
      height: 80.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

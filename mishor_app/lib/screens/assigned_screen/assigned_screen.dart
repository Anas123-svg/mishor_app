import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AssignedScreen extends StatefulWidget {
  const AssignedScreen({super.key});

  @override
  _AssignedScreenState createState() => _AssignedScreenState();
}

class _AssignedScreenState extends State<AssignedScreen> {
  final HomeController homeController = Get.find();
  String? userToken;
  bool isLoading = true;
  List<Assessment> assignedInspections = []; // Change to List<Assessment>
  String searchQuery = '';
  String filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
    });

    if (userToken != null) {
      try {
        await homeController.loadAssessmentCounts(userToken!);
        loadAssignedInspections();
      } catch (error) {
        print('Error fetching assessment counts: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void loadAssignedInspections() {
    final assessmentStats = homeController.assessmentStats;
    if (assessmentStats != null) {
      setState(() {
        assignedInspections = assessmentStats.rejectedAssessmentsList; // Use List<Assessment>
      });
    }
  }

List<Assessment> getFilteredAndSearchedInspections() {
  return assignedInspections.where((inspection) {
    bool matchesStatus = filterStatus == 'All' ||
        inspection.status.toLowerCase() == filterStatus.toLowerCase();
    bool matchesSearchQuery = searchQuery.isEmpty ||
        inspection.name.toLowerCase().contains(searchQuery.toLowerCase());

    return matchesStatus && matchesSearchQuery;
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    final assessmentStats = homeController.assessmentStats;

    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: drawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildSearchAndFilterRow(),
                    SizedBox(height: 24.h),
                    _buildStatusCards(assessmentStats),
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
                    _buildAssignedInspectionList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
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
        DropdownButton<String>(
          value: filterStatus,
          items: <String>['All', 'Pending', 'Rejected']
              .map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              filterStatus = value!;
            });
          },
          icon: Icon(Icons.filter_list, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildStatusCards(AssessmentStats? assessmentStats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (assessmentStats != null) ...[
          _buildStatusCard(
            'Total Assigned',
            (assessmentStats.pendingAssessments + assessmentStats.rejectedAssessments).toString(),
            AppColors.primary,
          ),
          _buildStatusCard(
            'Completed',
            assessmentStats.completedAssessments.toString(),
            Colors.green,
          ),
          _buildStatusCard(
            'Pending',
            assessmentStats.pendingAssessments.toString(),
            Colors.orange,
          ),
          _buildStatusCard(
            'Rejected',
            assessmentStats.rejectedAssessments.toString(),
            Colors.red,
          ),
        ]
      ],
    );
  }

  Widget _buildAssignedInspectionList() {
    final filteredList = getFilteredAndSearchedInspections();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final assessment = filteredList[index];
        return GestureDetector(
          onTap: () {
            // Navigate to detail page or perform any action
          },
          child: buildInspectionCard(assessment),
        );
      },
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
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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

Widget buildInspectionCard(Assessment assessment) {
  String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(assessment.createdAt.toLocal());

  return GestureDetector(
    onTap: () {
      Get.toNamed(AppRoutes.template);
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 1.w),
      width: MediaQuery.of(context).size.width * 0.9, 
      child: Card(
        color: AppColors.Col_White,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment, color: Colors.grey[700], size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      assessment.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[700], size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Location: ${assessment.Location}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[700], size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Date: $formattedDate',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.info, color: Colors.grey[700], size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Status: ${assessment.status}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.assignment_add,
                    color: Colors.grey[700],
                    size: 16.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
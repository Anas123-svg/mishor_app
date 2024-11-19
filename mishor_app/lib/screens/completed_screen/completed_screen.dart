import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/screens/template_screen/view_template.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:mishor_app/widgets/helping_global/inspection_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final HomeController homeController = Get.find();
  String? userToken;
  bool isLoading = true;
  List<Assessment> completedInspections = [];
  String searchQuery = '';
  //String filterStatus = 'All';
  String selectedFilter = 'Completed';
    String? username;

  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    loadUserData();
  });
  }



Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  if (!mounted) return; 

  setState(() {
    userToken = prefs.getString('user_token');
    username = prefs.getString('user_name');
  });

  if (userToken != null) {
    try {
      await homeController.loadApprovedAssessmentCounts(userToken!);
      if (homeController.approvedAssessmentStats != null) {
        print("fetchting approved assessment stats");
        loadAssignedInspections();
      } else {
        print('Error: approvedAssessmentStats is null.');
      }
    } catch (error) {
      print('Error fetching assessment counts: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  } else {
    print('Error: userToken is null.');
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  void reloadAssignedScreen() {
    loadUserData(); 
  }


  void loadAssignedInspections() {
    final assessmentStats = homeController.approvedAssessmentStats;
    if (assessmentStats != null) {
      setState(() {
        completedInspections = assessmentStats.rejectedAssessmentsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(token: userToken),
      drawer: drawer(user_name: username, userToken: userToken),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show statistics if data is available
              Obx(() {
                final assessmentStats = homeController.approvedAssessmentStats;
                return assessmentStats != null
                    ? _buildStatistics(assessmentStats)
                    : const SizedBox.shrink();
              }),
              SizedBox(height: 24.h),

              // Search bar (functional but no filtering logic for now)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Inspections...',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w200,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.primary),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        // You can later implement a filtering mechanism here if needed.
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Dynamic ListView showing completed inspections
              Obx(() {
                final completedInspections =
                    homeController.approvedAssessmentStats?.rejectedAssessmentsList ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: completedInspections.length,
                  itemBuilder: (context, index) {
                    final assessment = completedInspections[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ViewTemplate(assessment.id));
                      },
                      child: buildInspectionCard(assessment: assessment),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStatistics(AssessmentStats assessment) {
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
                  sections: showingSections(assessment),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statCard(
                    'approved', assessment.completedAssessments.toString()),
                _statCard(
                    'Pending',
                    (assessment.pendingAssessments)
                        .toString()),
                // _statCard('Total', assessment.totalAssessments.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(AssessmentStats assessment) {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primary,
            value: assessment.completedAssessments.toDouble(),
            title: 'approved',
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
            value:
                (assessment.pendingAssessments + assessment.rejectedAssessments)
                    .toDouble(),
            title: 'pending',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        /* case 2:
        return PieChartSectionData(
          color: Colors.red,
          value: assessment.totalAssessments.toDouble(),
          title: 'Total',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );*/
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
}

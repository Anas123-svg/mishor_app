import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/screens/HomeScreen/widgets/bar_chart.dart';
import 'package:mishor_app/screens/HomeScreen/widgets/inspection_list.dart';
import 'package:mishor_app/screens/HomeScreen/widgets/instructions.dart';
import 'package:mishor_app/screens/HomeScreen/widgets/stat_card.dart';
import 'package:mishor_app/screens/HomeScreen/widgets/welcome_card.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:get/get.dart';
import 'package:mishor_app/controllers/user_controller.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  String searchQuery = '';
  String? userId;
  String? userEmail;
  String? userName;
  String? userToken;
  String? ProfileImage;
  bool isLoading = true;

  List<String> assignedInspections = [];
  List<BarChartGroupData> inspectionBarData = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    userEmail = prefs.getString('user_email');
    userName = prefs.getString('user_name');
    userToken = prefs.getString('user_token');
    ProfileImage = prefs.getString('profile_image');

    if (userToken != null) {
      await fetchAndUpdateData();
    }
  }

  Future<void> reloadUserData() async {
    setState(() {
      isLoading = true;
    });
    await loadUserData();
  }

  Future<void> fetchAndUpdateData() async {
    try {
      await homeController.loadAssessmentCounts(userToken!);
      print("AssessmentStats: ${homeController.assessmentStats}");
      loadInspectionBarData();
      loadAssignedInspections();
    } catch (error) {
      print('Error fetching assessment counts: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void loadAssignedInspections() {
    final assessmentStats = homeController.assessmentStats;
    print("adsdasdas");
    if (assessmentStats != null) {
      assignedInspections =
          assessmentStats.rejectedAssessmentsList.map((assessment) {
        return '${assessment.name} (${assessment.status[0].toUpperCase() + assessment.status.substring(1)})';
      }).toList();
      print('Updated assignedInspections: $assignedInspections');
    }
  }

  void loadInspectionBarData() {
    final assessmentStats = homeController.assessmentStats;
    if (assessmentStats != null) {
      print("Daily Approved Counts: ${assessmentStats.dailyApprovedCounts}");
      inspectionBarData =
          assessmentStats.dailyApprovedCounts.entries.map((entry) {
        int dayIndex = getDayIndex(entry.key);
        return BarChartGroupData(
          x: dayIndex,
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: AppColors.primary,
              width: 16.w,
            ),
          ],
          showingTooltipIndicators: [0],
        );
      }).toList();
      print("Updated Inspection Bar Data: $inspectionBarData");
    }
  }

  void reloadAssignedScreen() {
    loadUserData();
  }

  int getDayIndex(String day) {
    switch (day) {
      case 'Monday':
        return 0;
      case 'Tuesday':
        return 1;
      case 'Wednesday':
        return 2;
      case 'Thursday':
        return 3;
      case 'Friday':
        return 4;
      case 'Saturday':
        return 5;
      case 'Sunday':
        return 6;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      appBar: CustomAppbar(token: userToken),
      drawer: drawer(user_name: userName),
      body: Obx(() {
        final assessmentStats = homeController.assessmentStats;
        return isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 8,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        shadowColor: Colors.black.withOpacity(0.3),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary],
                              stops: [0.0],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: buildWelcomeMessage(
                              ProfileImage: ProfileImage, userName: userName),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Instructions(),
                      SizedBox(height: 20.h),
                      if (assessmentStats != null)
                        buildStatisticsCards(
                            context: context, assessmentCount: assessmentStats),
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
                                'Stay updated on inspections performed/approved in the past week with ease.',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color.fromARGB(255, 6, 6, 6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Inspection Performance',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              buildBarChart(barData: inspectionBarData),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Assigned for this week',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ),
                      ),
                      Obx(() {
                        final inspections = homeController
                            .assessmentStats?.rejectedAssessmentsList
                            .map((assessment) {
                          return '${assessment.name} (${assessment.status[0].toUpperCase() + assessment.status.substring(1)})';
                        }).toList();

                        final filteredInspections = inspections
                                ?.where((inspection) => inspection
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                                .toList() ??
                            [];

                        return InspectionsList(
                          inspections: filteredInspections,
                          onSearchChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          onUploadDocument: () {},
                          onSignOff: (inspection) {},
                        );
                      }),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

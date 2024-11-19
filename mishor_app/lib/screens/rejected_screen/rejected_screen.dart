import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/screens/template_screen/view_template.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:mishor_app/widgets/helping_global/inspection_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RejectedScreen extends StatefulWidget {
  const RejectedScreen({super.key});

  @override
  _RejectedScreen createState() => _RejectedScreen();
}

class _RejectedScreen extends State<RejectedScreen> {
  final HomeController homeController = Get.find();
  String? userToken;
  bool isLoading = true;
  List<Assessment> RejectedInspections = [];
  String searchQuery = '';
  String? username;
  //String filterStatus = 'All';
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserData();  // Reload data every time the screen is shown
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
      await homeController.loadRejectedAssessmentCounts(userToken!);
      if (homeController.rejectedAssessmentStats != null) {
        print("fetchting rejected assessment stats");
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
    final assessmentStats = homeController.rejectedAssessmentStats;
    if (assessmentStats != null) {
      setState(() {
        RejectedInspections = assessmentStats.rejectedAssessmentsList;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppbar(token: userToken),
      drawer: drawer(user_name: username, userToken: userToken,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // Dynamic ListView for Rejected Inspections
            Expanded(
              child: Obx(() {
                final rejectedInspections =
                    homeController.rejectedAssessmentStats?.rejectedAssessmentsList ?? [];

                if (rejectedInspections.isEmpty) {
                  return const Center(
                    child: Text(
                      'No rejected inspections found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: rejectedInspections.length,
                  itemBuilder: (context, index) {
                    final assessment = rejectedInspections[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ViewTemplate(assessment.id));
                      },
                      child: buildInspectionCard(assessment: assessment),
                    );
                  },
                );
              }),
            ),
          ],
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
}

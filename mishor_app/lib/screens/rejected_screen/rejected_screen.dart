import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/screens/template_screen/view_template.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart ';
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
  //String filterStatus = 'All';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
    });

    if (userToken != null) {
      try {
        await homeController.loadRejectedAssessmentCounts(userToken!);
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
    final assessmentStats = homeController.rejectedAssessmentStats;
    if (assessmentStats != null) {
      setState(() {
        RejectedInspections = assessmentStats.rejectedAssessmentsList;
      });
    }
  }
  @override
  
  Widget build(BuildContext context) {
    final assessmentStats = homeController.rejectedAssessmentStats;
    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            fontWeight: FontWeight.w200),
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
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
              SizedBox(height: 20.h),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: RejectedInspections.length,
                itemBuilder: (context, index) {
                  final assessment = RejectedInspections[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ViewTemplate(assessment.id));
                    },
                    child: buildInspectionCard(assessment: assessment),
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
}

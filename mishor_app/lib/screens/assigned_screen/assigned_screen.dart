import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/screens/HomeScreen/widgets/stat_card.dart';
import 'package:mishor_app/screens/template_screen/template.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/drawer.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:mishor_app/widgets/helping_global/inspection_list.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('user_token');

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
                hintText: 'Search Inspections...',
                hintStyle: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w200),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                      color: Colors
                          .red),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
              ),
              cursorColor: Colors.red,
          ),
        ),
        SizedBox(width: 10.w),
        Container(

            padding: EdgeInsets.symmetric(horizontal: 1/2.w),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),

          child: DropdownButton<String>(
            value: filterStatus,
            items: <String>['All', 'Pending', 'Assigned']
                .map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4), // Text padding
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                filterStatus = value!;
              });
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 13),
              child: Icon(Icons.filter_list, color: AppColors.primary, size: 18),
            ),
              underline: SizedBox(), 
              dropdownColor: Colors.white,
              isExpanded: false, 
            
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCards(AssessmentStats? assessmentStats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (assessmentStats != null) ...[
          Expanded(
            child: buildStatCard(
              context: context,
              title: 'Assigned',
              value: (assessmentStats.assignedAssessments).toString(),
              icon: Icons.list,
            ),
          ),
                  SizedBox(width: 5.w),

          Expanded(
            child: buildStatCard(
                          context: context,
            
              title:'Approved',
              value: assessmentStats.completedAssessments.toString(),
              icon: Icons.check_circle_outline,
            ),
          ),
                  SizedBox(width: 5.w),

          Expanded(
            child: buildStatCard(
                          context: context,
            
              title: 'Pending',
              value: assessmentStats.pendingAssessments.toString(),
              icon: Icons.pending_actions,
              
              ),
          ),
                  SizedBox(width: 5.w),

          Expanded(
            child: buildStatCard(
                          context: context,
            
              title: 'Rejected',
              value: assessmentStats.rejectedAssessments.toString(),
              icon:Icons.cancel,
              ),
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
          Get.to(() => TemplateScreen(assessment.id));
          },
          child: buildInspectionCard(assessment: assessment),
        );
      },
    );
  }

}


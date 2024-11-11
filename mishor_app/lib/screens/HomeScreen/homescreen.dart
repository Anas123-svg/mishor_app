import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mishor_app/models/assessment_stats.dart';
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
    setState(() {
      userId = prefs.getString('user_id');
      userEmail = prefs.getString('user_email');
      userName = prefs.getString('user_name');
      userToken = prefs.getString('user_token');
    });

    if (userToken != null) {
      try {
        await homeController.loadAssessmentCounts(userToken!);  
        loadInspectionBarData();
        loadAssignedInspections();
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        print('Error fetching assessment counts: $error');
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
        assignedInspections = assessmentStats.rejectedAssessmentsList.map((assessment) {
          return '${assessment.name} (${assessment.status[0].toUpperCase() + assessment.status.substring(1)})';
        }).toList();
      });
    }
  }


void loadInspectionBarData() {
  final assessmentStats = homeController.assessmentStats;
  if (assessmentStats != null) {
    setState(() {
      inspectionBarData = assessmentStats.dailyApprovedCounts.entries.map((entry) {
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
    });
  }
}


  int getDayIndex(String day) {
    switch (day) {
      case 'Monday': return 0;
      case 'Tuesday': return 1;
      case 'Wednesday': return 2;
      case 'Thursday': return 3;
      case 'Friday': return 4;
      case 'Saturday': return 5;
      case 'Sunday': return 6;
      default: return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("user id : {$userId}");
    print("userEmail {$userEmail}");
    print("User Name: $userName");
    print("User Token: $userToken");
    final assessmentStats = homeController.assessmentStats;
  if (assessmentStats != null) {
    print("Daily Approved Counts: ${assessmentStats.dailyApprovedCounts.entries}");
  } else {
    print("Assessment stats are not available.");
  }
 if (assessmentStats != null) {
    print("assigned assessments : ${assessmentStats.rejectedAssessmentsList}");
  } else {
    print("Assessment stats are not available.");
  }

    return Scaffold(
      appBar: const  CustomAppbar(),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeMessage(),
              SizedBox(height: 20.h),
              if (assessmentStats != null) ...[
                _buildStatisticsCards(assessmentStats),
              ] else if (isLoading) ...[
                Center(child: CircularProgressIndicator()),
              ] else ...[
                Center(child: Text('Failed to load assessment data. Please try again later.')),
              ],
          
              
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
                        'Stay updated on inspections performed in the past week with ease.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center, 
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Inspection Performance',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildBarChart(inspectionBarData),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                'Assigned for this week',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              InspectionsList(
                inspections: assignedInspections
                    .where((inspection) => inspection.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList(),
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                onUploadDocument: () {
                },
                onSignOff: (inspection) {
                },
              ),
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildWelcomeMessage() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundColor: AppColors.primary.withOpacity(0.8),
          child: Icon(Icons.person, size: 30.r, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $userName',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Here\'s your latest inspection data',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(AssessmentStats assessmentCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildStatCard('Total', assessmentCount.totalAssessments.toString(), Icons.list)),
        SizedBox(width: 5.w),
        Expanded(child: _buildStatCard('Completed', assessmentCount.completedAssessments.toString(), Icons.check_circle_outline)),
        SizedBox(width: 5.w),
        Expanded(child: _buildStatCard('Pending', assessmentCount.pendingAssessments.toString(), Icons.pending_actions)),
        SizedBox(width: 5.w),
        Expanded(child: _buildStatCard('Rejected', assessmentCount.rejectedAssessments.toString(), Icons.cancel)),
      ],
    );
  }

  Widget _buildChartWithStats({required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: chart),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> barData) {
    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.2),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.r,
            spreadRadius: 2.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          barGroups: barData.map((data) {
            return BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.barRods[0].toY,
                  width: 16,
                  rodStackItems: [],
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
                reservedSize: 30.w,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Here are some additional insights based on recent inspection data. Keep up the good work and maintain the safety standards.',
          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
      ],
    );
  }

Widget _buildStatCard(String title, String value, IconData icon) {
  final screenSize = MediaQuery.of(context).size;

  double cardWidth = screenSize.width < 600 ? 80.w : 100.w; 
  double cardHeight = screenSize.width < 600 ? 100.h : 120.h; 
  double iconSize = screenSize.width < 600 ? 40.r : 50.r; 
  double titleFontSize = screenSize.width < 600 ? 10.sp : 12.sp; 
  double valueFontSize = screenSize.width < 600 ? 16.sp : 18.sp;
  double paddingValue = screenSize.width < 600 ? 8.w : 12.w;

  return Container(
    width: cardWidth.w,
    height: cardHeight.h,
    padding: EdgeInsets.all(paddingValue),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10.r,
          spreadRadius: 1.r,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize, color: Colors.white),
        SizedBox(height: 6.h),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: valueFontSize,
          ),
        ),
      ],
    ),
  );
}
}


class InspectionsList extends StatelessWidget {
  final List<String> inspections;
  final Function(String) onSignOff;
  final Function onUploadDocument;
  final Function(String) onSearchChanged;

  const InspectionsList({
    Key? key,
    required this.inspections,
    required this.onSearchChanged,
    required this.onSignOff,
    required this.onUploadDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Inspections...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => onSearchChanged(value),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, 
            itemCount: inspections.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12),
            itemBuilder: (context, index) {
              final inspection = inspections[index];
              final isFlagged = inspection.contains('Rejected');

              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h), 
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  title: Text(
                    inspection,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.cancel, 
                          color: isFlagged ? Colors.red : Colors.grey, 
                        ),
                        onPressed: () => onUploadDocument(),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.pending, 
                          color: !isFlagged ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => onSignOff(inspection),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

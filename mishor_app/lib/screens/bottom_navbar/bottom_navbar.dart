import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:mishor_app/screens/HomeScreen/homescreen.dart';
import 'package:mishor_app/screens/assigned_screen/assigned_screen.dart';
import 'package:mishor_app/screens/completed_screen/completed_screen.dart';
import 'package:mishor_app/screens/rejected_screen/rejected_screen.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/utilities/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavBar extends StatefulWidget {
  final List<Widget> screens;
  final int Ind;

  const CustomBottomNavBar({
    Key? key,
    required this.screens,
    required this.Ind,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.Ind;
    _triggerTabLogic(currentIndex); // Trigger logic for initial tab
  }

  void _triggerTabLogic(int index) {
    switch (index) {
      case 0:
        _handleHomeLogic();
        break;
      case 1:
        _handleAssignedLogic();
        break;
      case 2:
        _handleCompletedLogic();
        break;
      case 3:
        _handleRejectedLogic();
        break;
      case 4:
        _handleProfileLogic();
        break;
    }
  }

  Future<void> _handleHomeLogic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token != null) {
        final homeController = Get.find<HomeController>();
        await homeController.loadAssessmentCounts(token);
        if (widget.screens[0] is HomeScreen) {
          final homeScreen = widget.screens[0] as HomeScreen;
          final state = homeScreen.createState();
          await state.fetchAndUpdateData();
        }
      } else {
        print('User token not found.');
      }
    } catch (error) {
      print('Error refreshing data for Assigned tab: $error');
    }
  }

  Future<void> _handleAssignedLogic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token != null) {
        final homeController = Get.find<HomeController>();
        await homeController.loadAssessmentCounts(token);

        if (widget.screens[1] is AssignedScreen) {
          final assignedScreen = widget.screens[1] as AssignedScreen;
          final state = assignedScreen.createState(); // Retrieve the state
          state.reloadAssignedScreen();
        }
      } else {
        print('User token not found.');
      }
    } catch (error) {
      print('Error refreshing data for Assigned tab: $error');
    }
  }

  void _handleCompletedLogic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token != null) {
        final homeController = Get.find<HomeController>();
        await homeController.loadApprovedAssessmentCounts(token);

        if (widget.screens[2] is CompletedScreen) {
          final assignedScreen = widget.screens[2] as CompletedScreen;
          final state = assignedScreen.createState();
          state.reloadAssignedScreen();
        }
      } else {
        print('User token not found.');
      }
    } catch (error) {
      print('Error refreshing data for Assigned tab: $error');
    }
  }

  void _handleRejectedLogic() async{
        try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token != null) {
        final homeController = Get.find<HomeController>();
        await homeController.loadRejectedAssessmentCounts(token);

        if (widget.screens[3] is RejectedScreen) {
          final assignedScreen = widget.screens[3] as RejectedScreen;
          final state = assignedScreen.createState();
          state.reloadAssignedScreen();
        }
      } else {
        print('User token not found.');
      }
    } catch (error) {
      print('Error refreshing data for Assigned tab: $error');
    }
  }

  void _handleProfileLogic() {
    // Add logic specific to the 'Profile' tab
    print("Profile tab logic triggered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: AppTexts.Inter_w400_f10.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.Col_White,
          ),
          unselectedLabelStyle: AppTexts.Inter_w400_f10.copyWith(
            color: AppColors.Col_White,
          ),
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            _triggerTabLogic(index); // Trigger tab-specific logic
          },
          items: [
            BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? Image.asset(AppImages.home_highlighted,
                      height: 21.h, width: 21.w)
                  : Image.asset(AppImages.home, height: 21.h, width: 21.w),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? Image.asset(AppImages.assigned_highlighted,
                      height: 21.h, width: 21.w)
                  : Image.asset(AppImages.assigned, height: 21.h, width: 21.w),
              label: 'Assigned',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? Image.asset(AppImages.completed_highlighted,
                      height: 21.h, width: 21.w)
                  : Image.asset(AppImages.completed, height: 21.h, width: 21.w),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 3
                  ? Image.asset(AppImages.Rejected_highlighted,
                      height: 21.h, width: 21.w)
                  : Image.asset(AppImages.Rejected, height: 21.h, width: 21.w),
              label: 'Rejected',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 4
                  ? Image.asset(AppImages.profile_highlighted,
                      height: 21.h, width: 21.w)
                  : Image.asset(AppImages.profile, height: 21.h, width: 21.w),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Center(
        child: IndexedStack(
          index: currentIndex,
          children: widget.screens,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/utilities/text_style.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.redAccent,
              Colors.redAccent,
            ], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
          },
          items: [
            BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? Image.asset(AppImages.home, height: 21.h, width: 21.w)
                  : Image.asset(AppImages.home, height: 21.h, width: 21.w),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? Image.asset(AppImages.assigned, height: 21.h, width: 21.w)
                  : Image.asset(AppImages.assigned, height: 21.h, width: 21.w),
              label: 'Assigned',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? Image.asset(AppImages.completed, height: 21.h, width: 21.w)
                  : Image.asset(AppImages.completed, height: 21.h, width: 21.w),
              label: 'Completed',
            ),
           /* BottomNavigationBarItem(
              icon: currentIndex == 3
                  ? Image.asset(AppImages.highlightedControlIcon, height: 21.h, width: 21.w)
                  : Image.asset(AppImages.controlIcon, height: 21.h, width: 21.w),
              label: 'Control',
            ),*/
            BottomNavigationBarItem(
              icon: currentIndex == 3
                  ? Image.asset(AppImages.profile, height: 21.h, width: 21.w)
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Image.asset(AppImages.logo_trans, height: 50.h),
      ),
      backgroundColor: AppColors.Col_White,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: AppColors.primary),
          onPressed: () {
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black), // Set drawer icon color to black
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Open the drawer
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Set preferred size of the AppBar
}

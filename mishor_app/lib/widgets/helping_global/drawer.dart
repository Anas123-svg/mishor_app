import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/routes/app_pages.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/screens/change_password/change_password.dart';
import 'package:mishor_app/screens/edit_profile/edit_profile.dart';
import 'package:mishor_app/screens/support_screen/support_screen.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';

class drawer extends StatelessWidget {
  final String? user_name;
  final String? userProfileImage;

  drawer({super.key, this.user_name, this.userProfileImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0), // Set the overall background color of the drawer to black
      width: 280.w, // Maintain modern width, but will scale on smaller screens
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                // Center the logo within the header
                child: Image.asset(
                  AppImages.logo, // Your company logo asset path
                  width: 150.w, // Adjust size of the logo as per requirement
                  height: 150.h,
                  fit: BoxFit.contain, // Ensure logo fits within the provided size
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255), // Set the background color below the header to red
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // Edit Profile Option
                    _buildDrawerItem(
                      icon: Icons.home,
                      text: 'Edit Profile',
                      onTap: () {
                        Get.to(() => EditProfile());
                      },
                    ),
                    // Change Password Option
                    _buildDrawerItem(
                      icon: Icons.settings,
                      text: 'Change Password',
                      onTap: () {
                        Get.to(() => ChangePasswordScreen());
                      },
                    ),
                    // Help & Support Option
                    _buildDrawerItem(
                      icon: Icons.settings,
                      text: 'Help & Support',
                      onTap: () {
                        Get.to(() => SupportScreen());
                      },
                    ),
                    // Logout Option
                    _buildDrawerItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () {
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable drawer list item widget with rounded borders and elevated effect
  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w), // Dynamic padding
      child: Material(
        color: Colors.white, // Set each list item background to white
        elevation: 8, // Slightly higher elevation for a better floating effect
        borderRadius: BorderRadius.circular(12.r), // Rounded corners for a modern look
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Keep the background white for list items
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w), // Dynamic padding
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24.sp), // Use primary color for icons
                SizedBox(width: 16.w),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.black, // Set text color to black for contrast
                    fontSize: 18.sp, // Responsive font size for text
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

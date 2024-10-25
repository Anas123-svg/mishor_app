import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const  CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture with Edit Option
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 57.r,
                      backgroundImage: NetworkImage(
                        'https://randomuser'),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Implement change profile picture action
                      },
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, size: 16.w, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Name and Email
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'john.doe@example.com',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 20.h),

              // Profile Options Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 16.r,
                      spreadRadius: 1.r,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      label: 'Edit Profile',
                      onTap: () {
                        // Implement edit profile action
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      onTap: () {
                        // Implement change password action
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.history,
                      label: 'Order History',
                      onTap: () {
                        // Implement order history action
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.notifications_outlined,
                      label: 'Notification Settings',
                      onTap: () {
                        // Implement notification settings action
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () {
                        // Implement help & support action
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () {
                        // Implement logout action
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          // Add subtle hover effect
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4.r,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Color(0xFFD42427) : Colors.black87, size: 28.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: isLogout ? Color(0xFFD42427) : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18.w, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1.h,
      color: Colors.grey.shade300,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}

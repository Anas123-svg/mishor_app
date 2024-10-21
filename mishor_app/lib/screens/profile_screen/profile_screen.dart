
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.redAccent,
                child: CircleAvatar(
                  radius: 57.r,
                  backgroundImage: NetworkImage(
                      'https://your-image-url.com/image.jpg'), 
                )
              ),
              SizedBox(height: 20.h),
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

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      label: 'Edit Profile',
                      onTap: () {
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      onTap: () {
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.history,
                      label: 'Order History',
                      onTap: () {
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.notifications_outlined,
                      label: 'Notification Settings',
                      onTap: () {
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () {
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () {
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
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.redAccent : Colors.black87, size: 28.w),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18.sp,
          color: isLogout ? Colors.redAccent : Colors.black87,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18.w, color: Colors.grey.shade400),
      onTap: onTap,
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

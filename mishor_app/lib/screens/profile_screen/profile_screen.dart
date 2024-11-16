import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/Routes/app_routes.dart';
import 'package:mishor_app/controllers/user_controller.dart';
import 'package:mishor_app/screens/change_password/change_password.dart';
import 'package:mishor_app/screens/edit_profile/edit_profile.dart';
import 'package:mishor_app/screens/support_screen/support_screen.dart';
import 'package:mishor_app/services/profile_service.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/widgets/helping_global/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find(); // Get the UserController instance
  String? userToken;
  bool isLoading = false;
    final ProfileService profileService = ProfileService();

  String nameController = '';
  String emailController = '';
  String phoneController =  '';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                logout(context); // Call the logout function
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
      nameController = prefs.getString('user_name') ?? '';
      emailController = prefs.getString('user_email') ?? '';
      phoneController = prefs.getString('user_phone') ?? '';
      profileImageUrl = prefs.getString('profile_image');
      
    });
  }


      Future<void> logout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Call the logout API
      if(userToken!=null) {
        print(userToken);

      }
      else
      {
        print('userToken is null');
        return;
      }
            
      bool response;
              
      response = await profileService.logout(userToken!);


      if (response) {
        userController.clearUser();

        Navigator.pop(context);
        Get.offAllNamed(AppRoutes.splash);
      } else {
        // Handle logout failure
        Navigator.pop(context);
        Get.snackbar(
          'Logout Failed',
          'Unable to logout. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Navigator.pop(context);
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    print(nameController);
    print(emailController);
    return Scaffold(
      appBar: const  CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 57.r,
                      backgroundImage: NetworkImage(
                        profileImageUrl ?? 'https://static-00.iconduck.com/assets.00/user-icon-2048x2048-ihoxz4vq.png',
                      ),
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
                nameController,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                emailController,
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
                        Get.to(() => EditProfile());
                      },
                    ),
                    _buildDivider(),
                   _buildProfileOption(
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      onTap: () {
                        Get.to(() => ChangePasswordScreen());
                      },
                    ),

                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () {
                            Get.to(() => SupportScreen());
                      },
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () => showLogoutDialog(context),
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

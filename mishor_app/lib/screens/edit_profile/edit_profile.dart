import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mishor_app/models/user.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mishor_app/controllers/user_controller.dart'; // Import UserController
import 'package:mishor_app/services/profile_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileService profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  final UserController userController =
      Get.find(); // Get the UserController instance
  String? userToken;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? profileImage;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
      nameController.text = prefs.getString('user_name') ?? '';
      emailController.text = prefs.getString('user_email') ?? '';
      phoneController.text = prefs.getString('user_phone') ?? '';
      profileImageUrl = prefs.getString('profile_image');
    });
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> submitProfileUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      final updatedUserData = User(
        id: 1,
        email: emailController.text,
        token: userToken!,
        name: nameController.text,
        phone: phoneController.text,
        profileImage: profileImageUrl, // Update the profile image URL if needed
        client_id: 1, // Replace with actual client ID
        isVerified: true, // Update accordingly
        completed_assessments: 0,
        total_assessments: 0,
        rejected_assessments: 0,
        pending_assessments: 0,
      );

      try {
        final isSuccess = await profileService.updateUserProfile(
          userToken: userToken!,
          updatedData: {
            'name': nameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
          },
          profileImage: profileImage,
        );

        if (isSuccess) {
          userController.updateProfile(
              updatedUserData); // Update the profile in the controller

          Get.snackbar(
              'Profile Updated', 'Your profile has been updated successfully!',
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'Failed to update profile.',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (error) {
        print('Error updating profile: $error');
        Get.snackbar('Error', 'Something went wrong. Please try again later.',
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        centerTitle: true,
        backgroundColor: AppColors.Col_White,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        profileImageUrl != null && profileImageUrl!.isNotEmpty
                            ? CachedNetworkImageProvider(profileImageUrl!)
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                    child: profileImageUrl == null || profileImageUrl!.isEmpty
                        ? Icon(Icons.camera_alt,
                            size: 30.sp, color: Colors.grey[700])
                        : null,
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: Colors.black),

                    prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 7) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: submitProfileUpdate,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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

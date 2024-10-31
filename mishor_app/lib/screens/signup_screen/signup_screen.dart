import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:get/get.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/controllers/auth_controller.dart';
import 'package:mishor_app/models/client.dart';
import 'package:mishor_app/widgets/helping_global/text_field.dart';

class SignUpScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.fetchClients();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.toNamed(AppRoutes.login);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 100.h,
              ),
              SizedBox(height: 30.h),

              CustomTextField(
                controller: _nameController,label: 'Name',icon: Icons.person,
              ),
              SizedBox(height: 15.h),

              CustomTextField(
                controller: _emailController,label: 'Email',icon: Icons.email,
              ),
              SizedBox(height: 15.h),

              CustomTextField(
                controller: _passwordController,label: 'Password',icon: Icons.lock,obscureText: true,
              ),
              SizedBox(height: 15.h),

              CustomTextField(controller: _phoneController,label: 'Phone',icon: Icons.phone,keyboardType: TextInputType.phone,),
              SizedBox(height: 15.h),
              Obx(() {
                if (_authController.isLoading.value) {
                  return CircularProgressIndicator();
                } else if (_authController.clients.isEmpty) {
                  return Text('No construction companies available');
                } else {
                  return DropdownButtonFormField<Client>(
                    value: _authController.selectedClient.value,
                    decoration: InputDecoration(
                      labelText: 'Select Construction Company',
                      labelStyle: TextStyle(color: Color(0xFFD42427)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFD42427)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _authController.clients.map((Client company) {
                      return DropdownMenuItem<Client>(
                        value: company,
                        child: Text(company.name),
                      );
                    }).toList(),
                    onChanged: (Client? value) {
                      if (value != null) {
                        _authController.selectedClient.value = value;
                      }
                    },
                  );
                }
              }),
              SizedBox(height: 30.h),

              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: _authController.selectedClient.value == null
                        ? null
                        : () {
                            final selectedClientId = _authController.selectedClient.value?.id;
                            _authController.signUp(
                              _emailController.text,
                              _passwordController.text,
                              _phoneController.text,
                              _nameController.text,
                              selectedClientId,
                            );
                          },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFFD42427)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xFFD42427)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xFFD42427)),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Color(0xFFD42427)),
      ),
    );
  }
}

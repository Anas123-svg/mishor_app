import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mishor_app/utilities/api.dart';

class ChangePasswordService {
  static const String _baseUrl = Api.baseUrl; 

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required String userToken,
  }) async {
    final url = Uri.parse('$_baseUrl/user/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        //final responseData = jsonDecode(response.body);
              Get.snackbar(
        'Success',
        'Password updated successfully',  
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 3, 253, 82),
        colorText: Colors.white,
      );
        return true;

      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update password.');
      }
    } catch (error) {
      Get.snackbar(
        'Errrror',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}

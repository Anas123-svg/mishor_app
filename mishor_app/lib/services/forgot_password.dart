import 'package:http/http.dart' as http;

import 'package:mishor_app/utilities/api.dart';

class PasswordService {
  static const String _baseUrl = Api.baseUrl;

  Future<bool> sendResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print("Error sending reset code: $e");
      return false;
    }
  }

  // Reset the password using the reset code
  Future<bool> resetPassword(String resetCode, String password,String confirm_password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        body: {
          'reset_code': resetCode,
          'password': password,
          'password_confirmation': confirm_password,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print("Error resetting password: $e");
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  static Future<void> sendContactDetails({
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    final url = Uri.parse('https://mishor.globalctg1.com/api/contact-us');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send contact details');
    }
  }
}

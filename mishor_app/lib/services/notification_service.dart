import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mishor_app/utilities/api.dart';

class NotificationService {
  static const String apiUrl = '${Api.baseUrl}/user/notifications'; 

  static Future<List<String>> fetchNotifications(String token) async {
    print(apiUrl);
    print(token);
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data as List<dynamic>);
      } else {
        throw Exception('Failed to load notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}

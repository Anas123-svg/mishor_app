import 'package:dio/dio.dart';
import 'package:mishor_app/models/user.dart';
import 'package:mishor_app/models/client.dart';

class AuthService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api';
  final Dio dio = Dio();

  Future<User?> login(String email, String password) async {
    try {
      print('$_baseUrl/user/login');
      final response = await dio.post(
        '$_baseUrl/user/login',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        print("Decoded JSON response: $json");
        return User.fromJson(json);
      } else {
        throw Exception('Failed to log in: Unexpected response format');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData is String &&
            e.response?.headers.value('content-type')?.contains('text/html') ==
                true) {
          throw Exception(
              'Failed to log in: Server returned HTML response. Status code: ${e.response?.statusCode}');
        } else if (responseData is Map<String, dynamic>) {
          final errorMessage = responseData['message'] ?? 'Unknown error';
          throw Exception('Failed to log in: $errorMessage');
        } else {
          throw Exception(
              'Failed to log in: Status code ${e.response?.statusCode}');
        }
      } else {
        throw Exception('Failed to log in: ${e.message}');
      }
    }
  }

Future<bool> signUp(String email, String password, String confirmPassword,
    String phone, String name, int? client) async {
  try {
    final response = await dio.post(
      '$_baseUrl/user/register',
      data: {
        'client_id': client,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'phone': phone,
        'name': name,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print("Request Data: $response");

    if (response.statusCode == 201) {
      // Assuming successful registration
      return true;
    } else {
      // Log status and message if response is not 201
      print("Sign-up failed. Status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      throw Exception('Failed to sign up: ${response.statusCode}');
    }
  } on DioError catch (e) {
    print("Failed to sign up:");
    print("Status code: ${e.response?.statusCode}");
    print("Error message: ${e.message}");
    if (e.response?.data != null) {
      print("Server response: ${e.response?.data}");
    }

    throw Exception('Failed to sign up: ${e.response?.statusCode ?? 'Unknown error'}');
  }
}

  Future<List<Client>> getClients() async {
    try {
      final url = '$_baseUrl/client/';
      print('Requesting: $url');
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        try {
          final List<dynamic> clientList = response.data;
                  return clientList.map((client) => Client.fromJson(client)).toList();
        } catch (e) {
          print("Error parsing clients: $e");
          throw Exception('Failed to parse clients: Invalid JSON format');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Clients not found');
      } else {
        throw Exception(
            'Failed to load clients: Status code ${response.statusCode}');
      }
    } on DioError catch (e) {
      print(e);
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        print('Error status code: ${e.response?.statusCode}');
      } else {
        print('Error occurred without a response.');
      }
      throw Exception(
          'Failed to load clients: ${e.response?.statusCode ?? 'Unknown error'}');
    }
  }
}

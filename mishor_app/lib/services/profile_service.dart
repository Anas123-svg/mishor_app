import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mishor_app/utilities/api.dart';

class ProfileService {
  final String apiUrl =Api.baseUrl;
  final String cloudName = 'dchubllrz';
  final String uploadPreset = 'nmafnbii';


  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
          String? imageUrl = jsonMap['secure_url']; // Ensure this is correct

          if (imageUrl != null) {
    print('Image URL from Cloudinary: $imageUrl');  // Log the URL for debugging
    return imageUrl;
  } else {
    print('Image URL is null');
    return null;
  }

      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to update the user profile (name, email, phone, and image URL)
  Future<bool> updateUserProfile({
    required String userToken,
    required Map<String, String> updatedData,
    File? profileImage,
  }) async {
    try {
      String? imageUrl;

      // If there's a profile image, upload it to Cloudinary first
      if (profileImage != null) {
        imageUrl = await uploadImageToCloudinary(profileImage);
      }

      final updatedUserData = {
        'name': updatedData['name'] ?? '',
        'email': updatedData['email'] ?? '',
        'phone': updatedData['phone'] ?? '',
        if (imageUrl != null) 'profile_image': imageUrl, // Add image URL if available
      };

      final response = await http.put(
        Uri.parse('$apiUrl/user'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedUserData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("user Updated");
        print(response);
        return responseData['success'] ?? true; // Return true if update was successful
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }


Future<bool> logout(String token) async {
  print('Calling logout API with token: $token');

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/user/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Logout successful');
      return true;
    } else {
      print('Logout failed: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    print('Error during logout: $error');
    return false;
  }
}


}

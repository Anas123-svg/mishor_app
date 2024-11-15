import 'package:get/get.dart';
import 'package:mishor_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var user = Rx<User?>(null);

  void setUser(User userData) async {
    user(userData);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', userData.email);
    prefs.setString('user_token', userData.token);
    prefs.setString('user_name', userData.name);
    prefs.setString('user_phone', userData.phone);
    prefs.setInt('user_id', userData.id);
    prefs.setInt('user_client_id', userData.client_id);
    prefs.setBool('user_is_verified', userData.isVerified);
    prefs.setInt('user_completed_assessments', userData.completed_assessments);
    prefs.setInt('user_total_assessments', userData.total_assessments);
    prefs.setInt('user_rejected_assessments', userData.rejected_assessments);
    prefs.setInt('user_pending_assessments', userData.pending_assessments);
  }
  Future<void> updateProfile(User updatedUser) async {
    // Update the user data
    user(updatedUser);

    // Update SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', updatedUser.name);
    prefs.setString('user_email', updatedUser.email);
    prefs.setString('user_phone', updatedUser.phone);
    prefs.setString('profile_image', updatedUser.profileImage ?? ''); // Optional profile image update
  }

  void clearUser() async {
    user(null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Remove all saved user data
  }

  User? getUser() {
    return user.value;
  }
}

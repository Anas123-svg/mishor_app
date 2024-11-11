import 'package:get/get.dart';
import 'package:mishor_app/models/user.dart';
import 'package:mishor_app/services/auth_service.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/models/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var clients = <Client>[].obs;
  var selectedClient = Rx<Client?>(null); 
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

Future<void> login(String email, String password) async {
  isLoading.value = true;
  try {
    User? user = await _authService.login(email, password);
    if (user != null) {
      Get.offNamed(AppRoutes.bottomNavBar);
    }
  } catch (e) {
    Get.snackbar("Login Failed", e.toString());
   // Get.offNamed(AppRoutes.bottomNavBar);
    print(e);
  } finally {
    isLoading.value = false;
  }
}


  Future<void> signUp(String email, String password,String confirmPassword, String phone, String name, int Client) async {
    isLoading.value = true;
    try {
      bool isRegistered = await _authService.signUp(email, password,confirmPassword, phone, name, Client);
      if (isRegistered) {
        Get.toNamed(AppRoutes.bottomNavBar);
      }
    } catch (e) {
      Get.snackbar("Sign Up Failed", e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClients() async {
    try {
      isLoading.value = true;
      final response = await _authService.getClients();
      clients.assignAll(response);
      
      if (clients.isNotEmpty) {
        selectedClient.value = clients[0];
      }
    } catch (e) {
      print("Error fetching clients: $e");
    } finally {
      isLoading.value = false;
    }
  }


    Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    String? userEmail = prefs.getString('email');
    if (userId != null && userEmail != null) {
      print('Loaded User ID: $userId, Email: $userEmail');
    }
  }

}

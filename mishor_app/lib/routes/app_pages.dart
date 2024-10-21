import 'package:get/get.dart';
import 'package:mishor_app/main.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/screens/HomeScreen/homescreen.dart';
import 'package:mishor_app/screens/assigned_screen/assigned_screen.dart';
import 'package:mishor_app/screens/completed_screen/completed_screen.dart';
import 'package:mishor_app/screens/profile_screen/profile_screen.dart';
import 'package:mishor_app/screens/bottom_navbar/bottom_navbar.dart';
import 'package:mishor_app/screens/splash_screen/splash_screen.dart';

class AppPages {
  static final appRoutes =[
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.bottomNavBar, page: () => CustomBottomNavBar(
      screens: [
        HomeScreen(),
        AssignedScreen(),
        CompletedScreen(),
        ProfileScreen(),
      ],
      Ind: 0,
    )),

  ];
}
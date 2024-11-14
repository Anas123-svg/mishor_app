import 'package:get/get.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/screens/HomeScreen/homescreen.dart';
import 'package:mishor_app/screens/assigned_screen/assigned_screen.dart';
import 'package:mishor_app/screens/completed_screen/completed_screen.dart';
import 'package:mishor_app/screens/login_screen/login_screen.dart';
import 'package:mishor_app/screens/profile_screen/profile_screen.dart';
import 'package:mishor_app/screens/bottom_navbar/bottom_navbar.dart';
import 'package:mishor_app/screens/rejected_screen/rejected_screen.dart';
import 'package:mishor_app/screens/signup_screen/signup_screen.dart';
import 'package:mishor_app/screens/splash_screen/splash_screen.dart';
import 'package:mishor_app/screens/template_screen/template.dart';

class AppPages {
  static final appRoutes =[

    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
   // GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.splash, page: () => TemplateScreen(19)),

    GetPage(name: AppRoutes.bottomNavBar, page: () => CustomBottomNavBar(
      screens: [
        HomeScreen(),
        AssignedScreen(),
        CompletedScreen(),
        RejectedScreen(),
        ProfileScreen(),
      ],
      Ind: 0,
    )),

  ];
}
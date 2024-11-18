import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/routes/app_pages.dart';
import 'package:mishor_app/controllers/user_controller.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

//reg

void main() async {
  Get.put(UserController());
  Get.put(HomeController());  // Register HomeController here

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            getPages: AppPages.appRoutes,
            navigatorObservers: [AppNavigatorObserver()],

            initialRoute: AppRoutes.splash,
          );
        });
  }
}



class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    // Check if the newly pushed route is the target screen
    if (route.settings.name == '/assigned') {
      // Refresh or fetch data when AssignedScreen is pushed
      final homeController = Get.find<HomeController>();
      _loadUserTokenAndRefreshData(homeController);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    // Trigger actions when returning to a specific route
    if (previousRoute?.settings.name == '/assigned') {
      final homeController = Get.find<HomeController>();
      _loadUserTokenAndRefreshData(homeController);
    }
  }

  Future<void> _loadUserTokenAndRefreshData(HomeController homeController) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token != null) {
      await homeController.loadAssessmentCounts(token);
    } else {
      print('User token is missing');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/routes/app_pages.dart';
import 'package:mishor_app/controllers/user_controller.dart';
import 'package:mishor_app/controllers/home_screen_controller.dart';



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
            initialRoute: AppRoutes.splash,
          );
        });
  }
}






import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:mishor_app/utilities/app_images.dart';
import 'package:mishor_app/services/notification_service.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? token;

  const CustomAppbar({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Image.asset(AppImages.logo_trans, height: 50.h),
      ),
      backgroundColor: AppColors.Col_White,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: AppColors.primary),
          onPressed: () async {
            if (token == null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('User token is missing. Please log in.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
              return;
            }

            final notifications = await NotificationService.fetchNotifications(token!);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.red.shade50, 
                title: Center(
                  child: Text(
                    'Assigned',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: notifications.isNotEmpty
                    ? SizedBox(
                        height: 200.h,
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 0),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Row(
                                  children: [
                                    const Icon(Icons.assignment, color: Colors.red),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        notifications[index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Assigned',
                                      style: TextStyle(
                                        color: Colors.red.shade800,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Text(
                        'No notifications available.',
                        style: TextStyle(color: Colors.black),
                      ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

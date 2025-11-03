import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/generated/locales.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/modules/main/controllers/main_controller.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorageService.init();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupPushNotifications();
  runApp(
    ScreenUtilInit(
      enableScaleWH: () {
        if (kIsWeb) {
          return false;
        } else {
          return true;
        }
      },
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          darkTheme: ThemeData.light(),
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColor.PrimaryColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.PrimaryColor,
              primary: AppColor.PrimaryColor,
            ),
          ),
          debugShowCheckedModeBanner: false,
          locale: const Locale('en', 'US'),
          translationsKeys: AppTranslation.translations,
          fallbackLocale: const Locale('en', 'US'),
          color: AppColor.PrimaryColor,
          title: "Fan Poll World",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          builder: (context, widget) {
            if (kIsWeb) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: widget!,
                    ),
                  );
                },
              );
            } else {
              return widget!;
            }
          },
        );
      },
    ),
  );
}

Future<void> setupPushNotifications() async {
  // Request permission
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Get token
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
  if (token != null) {
    await LocalStorageService.saveString("fcm_token", token);
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message = ${message}");

    //showNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('User opened the app from a notification ${message}');
    final MainController mainController = Get.find<MainController>();
    mainController.changeTabIndex(3);
  });
}

// void showNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//
//   if (notification != null && android != null) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channel_id',
//           'channel_name',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//     );
//   }
// }

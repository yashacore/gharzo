import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gharzo_project/routes/pages.dart';
import 'package:gharzo_project/screens/splash/splash_view.dart';
import 'package:gharzo_project/utils/theme/text_style.dart';
import 'package:provider/provider.dart';

import 'notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService().initialize();

  String? token = await FirebaseMessaging.instance.getToken();
  print('🔥 FCM Token: $token');

  runApp(
    MultiProvider(
      providers: appProviders,
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: AppTextTheme.theme(fontFamily: 'Poppins'),
      ),
      navigatorKey: navigatorKey,
      home: SplashView(),
    );
  }
}

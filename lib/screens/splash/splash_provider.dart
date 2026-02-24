import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/screens/login/login_view.dart';
import 'package:gharzo_project/screens/onboardring/onboarding_one.dart';
import 'package:gharzo_project/screens/welcome_screen.dart';
import 'package:video_player/video_player.dart';

class SplashProvider extends ChangeNotifier {
  VideoPlayerController? controller;
  bool isInitialized = false;
  bool navigationDone = false;

  Future<void> start() async {
    try {
      debugPrint("🎬 Splash start");

      controller = VideoPlayerController.asset('assets/splash.mp4');

      await controller!.initialize();
      controller!.setLooping(false);
      controller!.play();

      isInitialized = true;
      notifyListeners();

      // 🔥 Navigate when video finishes
      controller!.addListener(() {
        if (!navigationDone &&
            controller!.value.isInitialized &&
            controller!.value.position >= controller!.value.duration) {
          navigationDone = true;
          handleNavigation();
        }
      });
    } catch (e) {
      debugPrint("❌ Asset video failed: $e");

      isInitialized = true;
      notifyListeners();

      // fallback immediately
      handleNavigation();
    }
  }

  Future<void> handleNavigation() async {
    if (navigationDone) return;
    navigationDone = true;

    final onboardingViewed = await PrefService.getOnboardingPageViews();

    if (onboardingViewed == false) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
      return;
    }

    final token = await PrefService.getToken();

    if (token != null && token.isNotEmpty) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomBarView()),
      );
    } else {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

// void start(BuildContext context) async {
//   await Future.delayed(const Duration(seconds: 3));
//   final getOnboardingPageViews = await PrefService.getOnboardingPageViews();
//   print('getOnboardingPageViews::  $getOnboardingPageViews');
//   if(getOnboardingPageViews){
//     final token = await PrefService.getToken();
//     debugPrint('token::  $token');
//
//     if(token != null && token.isNotEmpty){
//       navigatorKey.currentState?.pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => const BottomBarView(),
//         ),
//       );
//     }else{
//       navigatorKey.currentState?.pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => const LoginView(),
//         ),
//       );
//     }
//   }
//   else{
//     navigatorKey.currentState?.pushReplacement(
//       MaterialPageRoute(
//         builder: (_) => const OnboardingView()
//       ),
//     );
//   }
// }

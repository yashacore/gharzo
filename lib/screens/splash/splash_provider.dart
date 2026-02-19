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
  bool useVideo = false;
  bool navigationDone = false;


  Future<void> start() async {
    try {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(
          "https://gharzo-bucket.s3.ap-south-1.amazonaws.com/splace+screen/GHARZO+1.0.mp4"
        ),
      );

      await controller!.initialize();
      controller!.setLooping(false);
      controller!.play();

      // 🔥 Navigate when video finishes
      controller!.addListener(() {
        if (controller!.value.isInitialized &&
            controller!.value.position >=
                controller!.value.duration &&
            !navigationDone) {
          navigationDone = true;
          handleNavigation();
        }
      });

      isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Video load failed: $e");
      useVideo = false;
      isInitialized = true;
      notifyListeners();

      // fallback navigation
      await Future.delayed(const Duration(seconds: 2));
      handleNavigation();
    }
  }
  /// 🔍 Detect MediaTek & unsupported devices
  Future<bool> _canPlayVideoSplash() async {
    if (!Platform.isAndroid) return true;

    final info = await DeviceInfoPlugin().androidInfo;
    final hardware = info.hardware.toLowerCase();
    final manufacturer = info.manufacturer.toLowerCase();

    /// ❌ Block MediaTek devices
    if (hardware.contains("mt") || manufacturer.contains("xiaomi")) {
      return false;
    }

    return true;
  }

  Future<void> handleNavigation() async {
    print("🚀 handleNavigation() STARTED");

    await Future.delayed(const Duration(seconds: 3));

    final onboardingViewed =
    await PrefService.getOnboardingPageViews();
    print("📘 Onboarding Viewed: $onboardingViewed");

    // 1️⃣ Onboarding NOT completed
    if (onboardingViewed == false) {
      print("➡️ Navigating to OnboardingView");

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingView(),
        ),
      );
      return;
    }

    // 2️⃣ Onboarding completed → check auth
    final token = await PrefService.getToken();
    print("🔑 Token: $token");

    if (token != null && token.isNotEmpty) {
      print("➡️ Navigating to BottomBarView");

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BottomBarView(),
        ),
      );
    } else {
      print("➡️ Navigating to WelcomeScreen");

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        ),
      );
    }

    print("🏁 handleNavigation() FINISHED");
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






import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/screens/login/login_view.dart';
import 'package:gharzo_project/screens/onboardring/onboarding_one.dart';
import 'package:video_player/video_player.dart';

class SplashProvider extends ChangeNotifier {
  VideoPlayerController? controller;
  bool isInitialized = false;
  bool useVideo = false;

  Future<void> start() async {
    useVideo = await _canPlayVideoSplash();

    if (useVideo) {
      try {
        controller = VideoPlayerController.asset(
          'assets/gharzo_splash_video.mp4',
        );

        await controller!.initialize();
        controller!.setLooping(false);
        controller!.play();
      } catch (e) {
        debugPrint("❌ Video splash failed: $e");
        useVideo = false;
      }
    }

    isInitialized = true;
    notifyListeners();

    /// Splash duration
    await Future.delayed(const Duration(seconds: 3));

    _handleNavigation();
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

  Future<void> _handleNavigation() async {
    final getOnboardingPageViews =
    await PrefService.getOnboardingPageViews();

    if (getOnboardingPageViews) {
      final token = await PrefService.getToken();
      print("Token-------");
      print(token);
      if (token != null && token.isNotEmpty) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomBarView()),
        );
      } else {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    } else {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingView()),
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






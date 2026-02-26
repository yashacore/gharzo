// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:gharzo_project/screens/splash/splash_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
//
// // Brand Colors extracted from the Gharzo Logo
// const Color kBrandBlue = Color(0xFF002147);   // Navy Blue from 'G'
// const Color kBrandOrange = Color(0xFFF7941D); // Orange from house roof
// const Color kBgWhite = Color(0xFFFFFFFF);
//
//
//
// class SplashView extends StatefulWidget {
//   const SplashView({super.key});
//
//   @override
//   State<SplashView> createState() => _SplashViewState();
// }
//
// class _SplashViewState extends State<SplashView> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<SplashProvider>().start();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<SplashProvider>(
//         builder: (_, provider, __) {
//           if (provider.navigationDone) {
//             return const SizedBox.shrink();
//           }
//
//           if (!provider.isInitialized ||
//               provider.controller == null) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return Center(
//             child: AspectRatio(
//               aspectRatio:
//               provider.controller!.value.aspectRatio,
//               child: VideoPlayer(provider.controller!),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/screens/home/home_provider.dart';
import 'package:gharzo_project/screens/onboardring/onboarding_one.dart';
import 'package:gharzo_project/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashProvider>().handleNavigation();
      context.read<HomeProvider>().saveToken();
    });
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/splash.mp4');
      await _videoController!.initialize();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController!.play();
        _videoController!.setLooping(false);
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isVideoInitialized && _videoController != null
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          : Center(
              child: Image.asset(
                "assets/logo/splash.jpeg",
                width: 150,
                height: 150,
              ),
            ),
    );
  }
}

//

class SplashProvider with ChangeNotifier {
  bool navigationDone = false;

  /// 🔥 Single entry point
  Future<void> handleNavigation() async {
    if (navigationDone) return;
    navigationDone = true;

    debugPrint("🚀 Splash navigation started");

    // Minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    final onboardingViewed = await PrefService.getOnboardingPageViews();
    debugPrint("📘 Onboarding viewed: $onboardingViewed");

    if (onboardingViewed == false) {
      _go(const OnboardingView());
      return;
    }

    final token = await PrefService.getToken();
    debugPrint("🔑 Token: $token");

    if (token != null && token.isNotEmpty) {
      _go(const BottomBarView());
    } else {
      _go(const WelcomeScreen());
    }

    debugPrint("🏁 Splash navigation finished");
  }

  /// 🔐 Safe navigation helper
  void _go(Widget page) {
    final nav = navigatorKey.currentState;
    if (nav == null) return;

    nav.pushReplacement(MaterialPageRoute(builder: (_) => page));
  }
}

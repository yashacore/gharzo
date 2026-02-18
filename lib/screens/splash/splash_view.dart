import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gharzo_project/screens/splash/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

// Brand Colors extracted from the Gharzo Logo
const Color kBrandBlue = Color(0xFF002147);   // Navy Blue from 'G'
const Color kBrandOrange = Color(0xFFF7941D); // Orange from house roof
const Color kBgWhite = Color(0xFFFFFFFF);

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final String logoPath = 'assets/logo/splash.jpeg';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SplashProvider>().start();
    });

    // Start navigation logic from provider
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<SplashProvider>(context, listen: false).start(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Consumer<SplashProvider>(
            builder: (_, provider, __) {
              if (!provider.isInitialized) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              /// 🎥 VIDEO SPLASH (Safe devices)
              if (provider.useVideo && provider.controller != null) {
                return Center(
                  child: AspectRatio(
                    aspectRatio:
                    provider.controller!.value.aspectRatio,
                    child: VideoPlayer(provider.controller!),
                  ),
                );
              }

              /// 🖼 IMAGE SPLASH (MediaTek fallback)
              return Center(
                child: Image.asset(
                  'assets/logo/splash.jpeg',
                  width: 220,
                ));

            }
            ));

    // body: Stack(
      //   children: [
      //     // Background subtle decoration
      //     Positioned(
      //       top: -100,
      //       right: -100,
      //       child: CircleAvatar(
      //         radius: 150,
      //         backgroundColor: kBrandOrange.withOpacity(0.05),
      //       ),
      //     ),
      //
      //     Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           // Animated Logo
      //           Container(
      //             padding: const EdgeInsets.all(25),
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               shape: BoxShape.circle,
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: kBrandBlue.withOpacity(0.08),
      //                   blurRadius: 40,
      //                   offset: const Offset(0, 10),
      //                 ),
      //               ],
      //             ),
      //             child: Image.asset(
      //               logoPath,
      //               width: 200,
      //               height: 200,
      //               fit: BoxFit.contain,
      //             ),
      //           )
      //               .animate()
      //               .fadeIn(duration: 800.ms)
      //               .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
      //
      //           const SizedBox(height: 30),
      //
      //           // Tagline
      //           Text(
      //             "ELEVATING YOUR REALTY EXPERIENCE",
      //             style: TextStyle(
      //               color: kBrandBlue.withOpacity(0.7),
      //               fontSize: 11,
      //               fontWeight: FontWeight.w600,
      //               letterSpacing: 3,
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //
      //     // Bottom Navigation Keywords
      //     Positioned(
      //       bottom: 80,
      //       left: 0,
      //       right: 0,
      //       child: Column(
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               _buildKeyword("SELL"),
      //               _buildDot(),
      //               _buildKeyword("RENT"),
      //               _buildDot(),
      //               _buildKeyword("BUY"),
      //               _buildDot(),
      //               _buildKeyword("PG"),
      //             ],
      //           ),
      //           const SizedBox(height: 40),
      //
      //           // Elegant Minimal Loader
      //           SizedBox(
      //             width: 140,
      //             child: ClipRRect(
      //               borderRadius: BorderRadius.circular(10),
      //               child: LinearProgressIndicator(
      //                 backgroundColor: kBrandBlue.withOpacity(0.05),
      //                 color: kBrandOrange,
      //                 minHeight: 2,
      //               ),
      //             ),
      //           ).animate().fadeIn(delay: 1.2.seconds),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),

  }

  Widget _buildKeyword(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: kBrandBlue,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    ).animate().fadeIn(delay: 1.seconds).slideY(begin: 0.3, end: 0);
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: kBrandOrange,
        shape: BoxShape.circle,
      ),
    ).animate().scale(delay: 1.2.seconds);
  }
}
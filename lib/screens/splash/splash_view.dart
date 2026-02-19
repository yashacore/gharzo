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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashProvider>().start();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SplashProvider>(
        builder: (_, provider, __) {
          // 🛑 stop drawing splash after navigation
          if (provider.navigationDone) {
            return const SizedBox.shrink();
          }

          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.useVideo && provider.controller != null) {
            return Center(
              child: AspectRatio(
                aspectRatio:
                provider.controller!.value.aspectRatio,
                child: VideoPlayer(provider.controller!),
              ),
            );
          }

          // fallback image
          return Center(
            child: Image.asset(
              'assets/logo/splash.jpeg',
              width: 220,
            ),
          );
        },
      ),
    );
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
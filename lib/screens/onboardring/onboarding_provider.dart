import 'package:flutter/material.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/login/login_view.dart';

import '../../data/db_service/db_service.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();

  final isBtnLoading = false;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "All your favorites",
      "description": "Get all your loved in one once place, you just place the orer we do the rest",
      "logo": "assets/onboarding/onboarding.png"
    },
    {
      "title": "All your favorites",
      "description": "Get all your loved in one once place, you just place the orer we do the rest",
      "logo": "assets/onboarding/onboarding.png"
    },
  ];

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> next(BuildContext context) async {
    if (_currentIndex < onboardingData.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      await callLoginPage();
    }
  }

  Future<void> callLoginPage() async {
    await PrefService.saveOnboardingPageViews();
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';

class OtpVerificationProvider extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final String mobileNumber;
  final bool isRegistration;
// Backend enum-safe values
  List<String> roles = ["buyer", "agent", "landlord"];
  String selectedRole = "buyer";


  bool isLoading = false;
  bool showRegisterForm = false;

  int secondsRemaining = 60;
  Timer? _timer;

  OtpVerificationProvider({
    required this.mobileNumber,
    required this.isRegistration,
  }) {
    showRegisterForm = isRegistration; // 🔥 KEY LINE
    startTimer();
  }

  // =========================
  // VERIFY OTP
  // =========================
  Future<void> verifyOtp(BuildContext context) async {
    if (isLoading) return;

    if (otpController.text.trim().length != 6) {
      _snack(context, "Enter valid OTP");
      return;
    }

    if (showRegisterForm && nameController.text.trim().isEmpty) {
      _snack(context, "Enter your name");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService.verifyOtp(
        phone: mobileNumber,
        otp: otpController.text.trim(),
        name: showRegisterForm ? nameController.text.trim() : null,
        role: showRegisterForm ? selectedRole : null,
      );

      if (!response.success) {
        _snack(context, response.message);
        return;
      }

      await PrefService.saveAuthData(
        token: response.data?.token ?? '',
        userJson: jsonEncode(response.data?.user),
      );

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomBarView()),
            (route) => false,
      );
    } catch (e) {
      debugPrint("OTP ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // RESEND OTP
  // =========================
  Future<void> resendOtp(BuildContext context) async {
    final response = await AuthService.sendOtp(mobileNumber);
    if (response.success) {
      startTimer();
      _snack(context, "OTP sent again");
    }
  }

  void startTimer() {
    secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) timer.cancel();
      secondsRemaining--;
      notifyListeners();
    });
  }

  void _snack(BuildContext c, String msg) {
    ScaffoldMessenger.of(c)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    otpController.dispose();
    nameController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

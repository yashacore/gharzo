import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';

// ✅ CUSTOM AUTOFILL (NOT package)
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationProvider extends ChangeNotifier with CodeAutoFill {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final String mobileNumber;
  final bool isRegistration;

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
    debugPrint("🟢 Provider CREATED");
    debugPrint("📞 Mobile: $mobileNumber");
    debugPrint("📝 isRegistration: $isRegistration");

    showRegisterForm = isRegistration;

    debugPrint("⏳ startTimer()");
    startTimer();

    debugPrint("📡 listenForCode()");
    listenForCode(); // 🔥 AUTO READ OTP
  }

  // =========================
  // AUTO OTP RECEIVED
  // =========================
  @override
  void codeUpdated() {
    debugPrint("🔥 codeUpdated() called");
    debugPrint("📩 Raw code: $code");

    if (code == null) {
      debugPrint("❌ code is NULL");
      return;
    }

    if (code!.length != 6) {
      debugPrint("❌ code length = ${code!.length}");
      return;
    }

    debugPrint("✅ OTP VALID: $code");

    otpController.text = code!;
    notifyListeners();
  }

  // =========================
  // VERIFY OTP
  // =========================
  Future<void> verifyOtp(BuildContext context) async {
    debugPrint("🔐 verifyOtp() called");
    debugPrint("📥 OTP controller value: ${otpController.text}");

    if (isLoading) {
      debugPrint("⏳ Already loading");
      return;
    }

    if (otpController.text.trim().length != 6) {
      debugPrint("❌ OTP length invalid");
      return;
    }

    if (showRegisterForm && nameController.text.trim().isEmpty) {
      debugPrint("❌ Name empty");
      _snack(context, "Enter your name");
      return;
    }

    debugPrint("🚀 Starting verification API");
    isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService.verifyOtp(
        phone: mobileNumber,
        otp: otpController.text.trim(),
        name: showRegisterForm ? nameController.text.trim() : null,
        role: showRegisterForm ? selectedRole : null,
      );

      debugPrint("📡 API success = ${response.success}");

      if (!response.success) {
        debugPrint("❌ API failed: ${response.message}");
        _snack(context, response.message);
        return;
      }

      debugPrint("💾 Saving auth data");
      await PrefService.saveAuthData(
        token: response.data?.token ?? '',
        userJson: jsonEncode(response.data?.user),
      );

      debugPrint("➡️ Navigating to BottomBar");
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomBarView()),
            (route) => false,
      );
    } catch (e) {
      debugPrint("🔥 OTP ERROR: $e");
    } finally {
      debugPrint("✅ verifyOtp() finished");
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // RESEND OTP
  // =========================
  Future<void> resendOtp(BuildContext context) async {
    debugPrint("🔄 resendOtp() called");

    final response = await AuthService.sendOtp(mobileNumber);
    debugPrint("📡 resend response success = ${response.success}");

    if (response.success) {
      startTimer();
      debugPrint("📡 listenForCode() again");
      listenForCode();
      _snack(context, "OTP sent again");
    }
  }

  void startTimer() {
    debugPrint("⏱ Timer started");
    secondsRemaining = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsRemaining--;
      debugPrint("⏳ secondsRemaining = $secondsRemaining");

      if (secondsRemaining == 0) {
        debugPrint("⛔ Timer stopped");
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void _snack(BuildContext c, String msg) {
    debugPrint("🍿 Snack: $msg");
    ScaffoldMessenger.of(c)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    debugPrint("🧹 Provider DISPOSED");
    cancel();
    otpController.dispose();
    nameController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

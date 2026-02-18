import 'package:flutter/material.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/screens/otpVerification/otp_verification.dart';
import 'package:gharzo_project/screens/otpVerification/otp_verification_provider.dart';
import 'package:provider/provider.dart';


class LoginProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  bool isButtonLoading = false;

  Future<void> sendOtp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final phone = phoneController.text.trim();

    isButtonLoading = true;
    notifyListeners();

    final response = await AuthService.sendOtp(phone);

    isButtonLoading = false;
    notifyListeners();

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Something went wrong")),
      );
      return;
    }

  final bool isRegistration =
        response.data?.purpose == "registration";

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => OtpVerificationProvider(
            mobileNumber: phone,
            isRegistration: isRegistration,
          ),
          child: const OtpVerificationView(),
        ),
      ),
    );
  }
  void clickOn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => BottomBarView()),
    );
  }
}

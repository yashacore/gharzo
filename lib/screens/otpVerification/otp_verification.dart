import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/screens/otpVerification/otp_verification_provider.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:gharzo_project/utils/validation/validation.dart';
import 'package:provider/provider.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpVerificationProvider>(
      builder: (context, value, child) {
        return CommonWidget.commonScaffoldWithContainer(
          context: context,
          title: PageConstVar.verification,
          subtitle: PageConstVar.verificationText,
          extraText: "+91 ${value.mobileNumber}",
          showBack: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Text(
                  "OTP",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
                SizedBox(height: 8,),

                CommonWidget.commonOtpTextField(
                  context: context,
                  controller: value.otpController,
                  length: 6,
                ),
                SizedBox(height: 20),
                if (value.showRegisterForm) ...[
                  Text(
                    PageConstVar.fullName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                  fullNameTextFormField(value),
                  SizedBox(height: 8,),
                  Text(
                    PageConstVar.role,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                  roleSegmentedSelector(value),
                ],

                SizedBox(height: 32),
                PrimaryButton(
                  title: value.isLoading
                    ? "Verifying..."
                    : value.showRegisterForm
                    ? "Continue"
                    : "Verify",

                  onPressed:
                  value.isLoading ? null : () => value.verifyOtp(context),),


                SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: value.secondsRemaining == 0
                        ? () => value.resendOtp(context)
                        : null,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: PageConstVar.resend,
                            style: TextStyle(
                              color: value.secondsRemaining == 0
                                  ? AppThemeColors().primary
                                  : Colors.grey,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          if (value.secondsRemaining > 0)
                            TextSpan(
                              text: " in ${(value.secondsRemaining)} sec",
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget fullNameTextFormField(OtpVerificationProvider value) =>
      CommonWidget.commonTextFormField(
        hint: PageConstVar.fullName,
        controller: value.nameController,
        keyboardType: TextInputType.name,
        validator: Validation.fullNameValidator,
      );

  Widget roleSegmentedSelector(OtpVerificationProvider provider) {
    // Map internal role values to display names
    final roleDisplayNames = {
      "Buyer/Owner": "Buyer/Owner",
      "Agent": "Broker",
      "landlord": "PG Landlord",
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: provider.roles.map((role) {
          final isSelected = provider.selectedRole == role;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                provider.selectedRole = role;
                provider.notifyListeners();
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppThemeColors().buttonColor : Colors
                      .transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  roleDisplayNames[role] ?? role, // Show mapped name
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

}

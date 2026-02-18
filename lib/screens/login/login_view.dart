import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/screens/login/login_provider.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:gharzo_project/utils/validation/validation.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return CommonWidget.commonScaffoldWithContainer(
          context: context,
          title: PageConstVar.login,
          subtitle: PageConstVar.loginText,
          showSkip: true,
          onSkipTap: () {
            value.clickOn(context);
          },
          child: Form(
            key: value.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PageConstVar.mobileNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 6),
                    mobileTextFormField(value),
                  ],
                ),
                SizedBox(height: 16),
                PrimaryButton(title: "Send Otp",
                    onPressed: value.isButtonLoading
                        ? null
                        : () async => await value.sendOtp(context),
                    )

              ],
            ),
          ),
        );
      },
    );
  }

  Widget mobileTextFormField(LoginProvider value) =>
      CommonWidget.commonTextFormField(
        hint: PageConstVar.enterMobileNumber,
        controller: value.phoneController,
        keyboardType: TextInputType.phone,
        validator: Validation.mobileValidator,
      );
}

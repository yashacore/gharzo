import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/onboardring/onboarding_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:gharzo_project/utils/theme/text_style.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: value.pageController,
                    itemCount: value.onboardingData.length,
                    onPageChanged: value.onPageChanged,
                    itemBuilder: (context, index) {
                      return CommonWidget.commonOnBoarding(
                        context: context,
                        imagePath: value.onboardingData[index]['logo']!,
                        title: value.onboardingData[index]['title']!,
                        description: value.onboardingData[index]['description']!,
                        currentIndex: value.currentIndex,
                        totalCount: value.onboardingData.length,
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      CommonWidget.commonElevatedBtn(
                        btnText: "Next",
                        isLoading: value.isBtnLoading,
                        onPressed:() {
                          value.next(context);
                        },
                      ),
                      SizedBox(height: 4,),
                      TextButton(
                        onPressed: () async => await value.callLoginPage(),
                        child: Text("Skip", style: AppTextStyle.bodyMedium(AppThemeColors().textGrey)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

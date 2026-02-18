import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:pinput/pinput.dart';

class CommonWidget {
  /// -------------------- Onboarding --------------------
  static Widget commonOnBoarding({
    required String imagePath,
    required String title,
    required String description,
    required BuildContext? context,
    required int currentIndex,
    required int totalCount,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Container(
          height: 292,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 29),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context!).textTheme.labelLarge,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalCount,
            (index) => Container(
              margin: const EdgeInsets.all(4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? AppThemeColors().primary
                    : AppThemeColors().textGrey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //=============================================Login/Verification/register
  static Widget commonScaffoldWithContainer({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget child,
    bool showSkip = false,
    bool showBack = false,
    VoidCallback? onSkipTap,
    VoidCallback? onBackTap,
    String? extraText,
  }) {
    final colors = AppThemeColors();

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.backgroundLeft, colors.backgroundRight, colors.backgroundRight],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            /* -------------------- Back Button -------------------- */
            if (showBack)
              Positioned(
                top: 50,
                left: 16,
                child: GestureDetector(
                  onTap: onBackTap ?? () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            if (showSkip)
              Positioned(
                top: 50,
                right: 16,
                child: GestureDetector(
                  onTap: onSkipTap,
                  child: Text(
                    "Skip",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              top: 120,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              bottom: 0,
              child: authWhiteContainer(child),
            ),
          ],
        ),
      ),
    );
  }

  //=================================Gradient App Bar
  static PreferredSizeWidget gradientAppBar({
    required String title,
    bool centerTitle = true,
    List<Widget>? actions,
    Widget? leading,
    bool showBack = true,
    VoidCallback? onPressed,

  }) {
    return AppBar(
      leading: showBack
          ? leading ??
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white, size: 20),
              onPressed: onPressed,
            ),
          )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: AppThemeColors().textWhite,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppThemeColors().backgroundLeft,
              AppThemeColors().backgroundRight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  static Widget authWhiteContainer(Widget child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(right: 24, left: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(child: child),
    );
  }

  // ======================================Common Elevated Button
  static Widget commonElevatedBtn({
    required String btnText,
    VoidCallback? onPressed,
    bool isLoading = false,
    Color? backgroundColor,
    Size? minimumSize,
    Size? maximumSize,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppThemeColors().primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          maximumSize: maximumSize,
          minimumSize: minimumSize,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Builder(
                builder: (context) => Text(
                  btnText,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
      ),
    );
  }

  // ============================Text  Form Field
  static Widget commonTextFormField({
    required String hint,
    TextEditingController? controller,
    bool isPassword = false,
    bool readOnly = false,
    bool enabled = true,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onSubmitted,
    void Function(String)? onChanged,
    VoidCallback? onTap,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLines = 1,
    int minLines = 1,
    int? maxLength,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: isPassword,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppThemeColors().textHint,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? Color(0xffF0F5FA),
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  //---------------------OTP Text field
  static Widget commonOtpTextField({
    required BuildContext context,
    required TextEditingController controller,
    int length = 4,
    ValueChanged<String>? onCompleted,
  }) {
    final defaultPinTheme = PinTheme(
      width: 48,   // 👈 slightly wider
      height: 52,  // 👈 slightly taller
      textStyle: Theme.of(context)
          .textTheme
          .displaySmall
          ?.copyWith(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA), // 👈 light background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
    );

    return Pinput(
      controller: controller,
      length: length,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      defaultPinTheme: defaultPinTheme,

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      ),

      submittedPinTheme: defaultPinTheme,
      onCompleted: onCompleted,
    );
  }

  //==============================================Rich Text
  static Widget commonRichTextBtn({
    required BuildContext context,
    VoidCallback? onPressed,
    String? normalText,
    String? btnText,
  }) {
    return RichText(
      text: TextSpan(
        text: "$normalText",
        style: TextStyle(color: AppThemeColors().textGrey),
        children: [
          TextSpan(
            text: "$btnText",
            style: TextStyle(color: AppThemeColors().primary),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
          ),
        ],
      ),
    );
  }

  static Widget commonGradientScaffold({
    required Widget body,

    Gradient? gradient,
    bool isScrollable = true,
    double headerHeight = 260,
    ScrollPhysics? physics,
    EdgeInsets safeAreaPadding = const EdgeInsets.symmetric(horizontal: 16),
  }) {
    Widget content = SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppThemeColors().backgroundLeft,
                  AppThemeColors().backgroundRight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          body,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: isScrollable
          ? SingleChildScrollView(physics: physics, child: content)
          : content,
    );
  }

  static Widget categoryListView(dynamic provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: provider.categories.map<Widget>((label) {
          bool isSelected = provider.selectedCategory == label;

          return GestureDetector(
            onTap: () => provider.setCategory(label),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppThemeColors().buttonColor,
                          AppThemeColors().buttonColor,
                        ],
                      )
                    : const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ),

                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget commonSliders({
    double height = 180,
    required List<String> images,
    required PageController pageController,
    required int currentIndex,
    required ValueChanged<int> onPageChanged,
  }) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: currentIndex == index ? 18 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget profileImagePicker({
    required String imagePath,
    required VoidCallback onTapCamera,
  }) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: imagePath.isNotEmpty
              ? (imagePath.startsWith('http')
                    ? NetworkImage(imagePath)
                    : FileImage(File(imagePath)) as ImageProvider)
              : null,
          child: imagePath.isEmpty ? Icon(Icons.person, size: 40) : null,
        ),

        InkWell(
          onTap: onTapCamera,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  static void showImage({
    required BuildContext context,
    required VoidCallback onCamera,
    required VoidCallback onGallery,
    VoidCallback? onRemove,
    bool showRemove = false,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(PageConstVar.camera),
            onTap: () {
              Navigator.pop(context);
              onCamera();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: Text(PageConstVar.gallery),
            onTap: () {
              Navigator.pop(context);
              onGallery();
            },
          ),
          if (showRemove && onRemove != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                "Remove Photo",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onRemove();
              },
            ),
        ],
      ),
    );
  }
}

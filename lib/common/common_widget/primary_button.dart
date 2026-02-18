import 'package:flutter/material.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final Future<void> Function()? onPressed;
  final bool enabled;
  final double height;
  final BorderRadius borderRadius;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.height = 46,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _loading = false;

  Future<void> _handleTap() async {
    if (_loading || widget.onPressed == null) return;

    setState(() => _loading = true);

    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors();

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.enabled ? _handleTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.buttonColor,
          foregroundColor: colors.buttonTextColor,
          disabledBackgroundColor:
          colors.buttonColor.withOpacity(.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _loading
              ? SizedBox(
            key: const ValueKey("loader"),
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(
                colors.textWhite,
              ),
            ),
          )
              : Text(
            widget.title,
            key: const ValueKey("text"),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

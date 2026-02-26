import 'package:flutter/material.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final Future<void> Function()? onPressed;
  final bool enabled;
  final double height;
  final BorderRadius borderRadius;
  final Color? color; // optional solid color

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.height = 50,
    this.color,
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

    final bool isDisabled = !widget.enabled;

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          // 👉 If color provided → use solid color
          // 👉 Otherwise → use default gradient
          color: widget.color != null
              ? (isDisabled ? widget.color!.withOpacity(0.5) : widget.color)
              : null,
          gradient: widget.color == null
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isDisabled
                      ? [
                          const Color(0xFF3B82F6).withOpacity(0.5),
                          const Color(0xFF2563EB).withOpacity(0.5),
                        ]
                      : const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                )
              : null,
          borderRadius: widget.borderRadius,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: widget.borderRadius,
            onTap: widget.enabled ? _handleTap : null,
            child: Center(
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
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

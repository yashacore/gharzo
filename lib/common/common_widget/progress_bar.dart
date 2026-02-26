import 'package:flutter/material.dart';

class PropertyProgressBar extends StatelessWidget {
  final double progress; // 0.0 → 1.0
  final String? label;

  const PropertyProgressBar({super.key, required this.progress, this.label});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _baseColor(progress).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$percent%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _baseColor(progress),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation(_gradientColor(progress)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 Base color by progress
  Color _baseColor(double v) {
    if (v < 0.4) return const Color(0xFFEF4444); // red
    if (v < 0.7) return const Color(0xFFF59E0B); // amber
    return const Color(0xFF22C55E); // green
  }

  // 🌈 Gradient illusion (premium trick)
  Color _gradientColor(double v) {
    if (v < 0.4) {
      return const Color(0xFFEF4444);
    } else if (v < 0.7) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFF22C55E);
    }
  }
}

import 'package:flutter/material.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String? debugLabel;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.debugLabel,
    this.height = 140,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  String? _getValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;

    if (url.startsWith("http")) return url;

    // backend-relative URL support
    const baseUrl = "https://api.gharzoreality.com";
    return "$baseUrl$url";
  }

  @override
  Widget build(BuildContext context) {
    final validUrl = _getValidUrl(imageUrl);

    if (validUrl == null) {
      debugPrint(
        "❌ Invalid image URL${debugLabel != null ? ' [$debugLabel]' : ''} → '$imageUrl'",
      );

      return Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Image.network(
        validUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
            "❌ Image load failed${debugLabel != null ? ' [$debugLabel]' : ''} → $validUrl",
          );
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            child: const Center(child: Icon(Icons.broken_image, size: 40)),
          );
        },
      ),
    );
  }
}

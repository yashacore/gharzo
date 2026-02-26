import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final List<String> images;

  const ImageSlider({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (_, i) => Image.network(
          images[i],
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
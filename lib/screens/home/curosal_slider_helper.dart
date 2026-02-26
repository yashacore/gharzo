import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/common/cached_image_helper.dart';
import 'home_provider.dart';

class HomeAdSlider extends StatelessWidget {
  const HomeAdSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 210,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.ads.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 210,
          child: Stack(
            children: [
              /// 🎠 CAROUSEL
              CarouselSlider.builder(
                itemCount: provider.ads.length,

                // ❌ unlimitedMode causes previous slide to render
                unlimitedMode: false,

                keepPage: true,

                // ✅ HARD CLIP (MOST IMPORTANT)
                clipBehavior: Clip.hardEdge,

                // ✅ FULL WIDTH (NO SIDE PEEK)
                viewportFraction: 1.0,

                // ⚠️ CubeTransform shows sides by nature
                // ❌ REMOVE IT
                slideTransform: const DefaultTransform(),

                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 4),
                autoSliderTransitionTime: const Duration(milliseconds: 800),
                autoSliderTransitionCurve: Curves.easeInOut,

                onSlideChanged: (index) {
                  provider.onAdPageChanged(index);
                },

                slideBuilder: (index) {
                  final ad = provider.ads[index];

                  return GestureDetector(
                    onTap: () => provider.onAdTap(ad),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedImage(
                            imageUrl: ad.imageUrl,
                            fit: BoxFit.cover,
                          ),

                          // Gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.65),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),              /// 🔘 INDICATOR
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    provider.ads.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width:
                      provider.currentAdIndex == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: provider.currentAdIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
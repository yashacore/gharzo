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

                /// 🔥 REQUIRED FOR CUBE EFFECT
                unlimitedMode: true,
                keepPage: true,

                /// 🔥 IMPORTANT: allow overflow for cube
                clipBehavior: Clip.none,

                slideTransform: const CubeTransform(),

                /// 🔥 Slightly smaller for visible gap
                viewportFraction: 0.86,

                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 4),
                autoSliderTransitionTime:
                const Duration(milliseconds: 800),
                autoSliderTransitionCurve: Curves.fastOutSlowIn,

                onSlideChanged: (index) {
                  provider.onAdPageChanged(index);
                },

                slideBuilder: (index) {
                  final ad = provider.ads[index];

                  return Padding(
                    /// 🔥 THIS CREATES THE GAP
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => provider.onAdTap(ad),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// 🖼 IMAGE (CACHED)
                            CachedImage(
                              imageUrl: ad.imageUrl,
                              fit: BoxFit.cover,
                            ),

                            /// 🌑 GRADIENT
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

                            /// ⭐ SPONSORED BADGE
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star,
                                        size: 12, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      "Sponsored",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// 🏷 TITLE
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 34,
                              child: Text(
                                ad.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              /// 🔘 INDICATOR
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
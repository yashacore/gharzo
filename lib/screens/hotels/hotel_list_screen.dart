import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/hotel_provider.dart';
import 'package:gharzo_project/screens/hotels/hotel_card.dart';
import 'package:gharzo_project/screens/hotels/hotel_search_bar.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().fetchHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HotelProvider>();

    return Scaffold(
      appBar: CommonWidget.gradientAppBar(
        title: "Hotels",
        onPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 🔍 SEARCH
          const HotelSearchBar(),

          const SizedBox(height: 12),

          /// 🧭 FILTER TABS (PROVIDER CONTROLLED)
          const HotelFilterTabs(),

          const SizedBox(height: 12),

          /// 📃 LIST
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : provider.hotels.isEmpty
                ? const Center(child: Text('No hotels found'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: provider.hotels.length,
              itemBuilder: (context, index) {
                final hotel = provider.hotels[index];

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.95, end: 1.0),
                  duration: const Duration(milliseconds: 250),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: HotelCard(hotel: hotel),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class StarRating extends StatelessWidget {
  final double rating;
  final int totalStars;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.totalStars = 5,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        if (index + 1 <= rating) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index + 0.5 <= rating) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.grey.shade400,
            size: size,
          );
        }
      }),
    );
  }
}


class HotelFilterTabs extends StatelessWidget {
  const HotelFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HotelProvider>();
    final colors = AppThemeColors();

    final tabs = ['All', '5 Star', 'Featured', 'Budget'];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = provider.selectedTab == index;

          return GestureDetector(
            onTap: () {
              context.read<HotelProvider>().filterByTab(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.containerWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? colors.textWhite
                        : colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


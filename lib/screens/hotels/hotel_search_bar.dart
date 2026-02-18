import 'package:flutter/material.dart';
import 'package:gharzo_project/providers/hotel_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class HotelSearchBar extends StatefulWidget {
  const HotelSearchBar({super.key});

  @override
  State<HotelSearchBar> createState() => _HotelSearchBarState();
}

class _HotelSearchBarState extends State<HotelSearchBar> {
  final controller = TextEditingController();
  final colors = AppThemeColors();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.containerWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: (value) {
            context.read<HotelProvider>().searchHotels(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search hotels, locality, keywords...',
            hintStyle: TextStyle(color: colors.textHint),
            icon: Icon(Icons.search, color: colors.primary),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                controller.clear();
                context.read<HotelProvider>().searchHotels('');
              },
            )
                : null,

          ),
        ),
      ),
    );
  }
}

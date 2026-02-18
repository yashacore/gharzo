import 'package:flutter/material.dart';
import 'package:gharzo_project/model/advertisement/advertisment_model.dart';

import '../../../main.dart';
import '../../../screens/notification/notification_view.dart';

class CommonHomeWidgets {

  // ================= HEADER =================
  static Widget headerView({
    required VoidCallback onMenuTap,
    required BuildContext? context,
  }) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/logo/splash.jpeg",
                height: 44,
                width: 44,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: Theme.of(context!).textTheme.titleMedium!.copyWith(color: Colors.white),
              ),
              Row(

                children: [
                  Text(
                      "Vijay Nagar, Indore",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                  Icon(Icons.location_on_outlined, color: Colors.white70, size: 14),

                ],
              ),
            ],
          ),
           Spacer(),
          GestureDetector(
            onTap: () => navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => NotificationView(),)),
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white30,
              ),
              child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SEARCH BAR =================
  static Widget searchBarView({VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.search, color: Colors.grey, size: 24),
              const SizedBox(width: 10),

              /// 🔑 IMPORTANT FIX
              const Expanded(
                child: IgnorePointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),

              /// 🔵 Filter Button
              Container(
                margin: const EdgeInsets.all(8),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E3A5F),
                      Color(0xFF6A8DFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ================= AD SLIDER =================
  static Widget commonAddSlider({
    required bool isLoading,
    required List<AdvertisementModel> ads,
    required PageController pageController,
    required Function(int) onPageChanged,
  }) {
    if (isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              ad.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ================= COMMON SECTION =================
  static Widget section({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  static Widget categoryCardView({
    IconData? icon,
    required String label,
    Color? color,
    bool isShowIcon = true,
  }) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius:3)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isShowIcon && icon != null) ...[
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static   Widget commonColumn({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

}

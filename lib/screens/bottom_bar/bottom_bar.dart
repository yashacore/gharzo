import 'package:flutter/material.dart';
import 'package:gharzo_project/screens/home/home_derawer.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';
import 'bottom_bar_provider.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBarView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 220),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
  }

  void openDrawer() => _controller.forward();
  void closeDrawer() => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              extendBody: true,
              body: provider.currentPage(openDrawer),

              bottomNavigationBar: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                offset: provider.isBottomBarVisible
                    ? Offset.zero
                    : const Offset(0, 1), // slide down
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: provider.isBottomBarVisible ? 1 : 0,
                  child: _bottomBar(provider),
                ),
              ),
            ),


            // 🔥 DARK OVERLAY
            if (_controller.value > 0)
              Positioned.fill(
                child: GestureDetector(
                  onTap: closeDrawer,
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),

            // 🔥 DRAWER
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                _controller.value +=
                    details.primaryDelta! /
                        (MediaQuery.of(context).size.width * 0.8);
              },
              onHorizontalDragEnd: (details) {
                if (_controller.value > 0.5) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: SlideTransition(
                position: _slideAnimation,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: HomeDrawer(onClose: closeDrawer),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomBar(BottomBarProvider provider) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem(0, Icons.home, "Home", provider),
                  navItem(1, Icons.receipt_long, "Plans", provider),
                  const SizedBox(width: 60),
                  navItem(3, Icons.video_collection, "Reels", provider),
                  navItem(4, Icons.person, "Profile", provider),
                ],
              ),
            ),
          ),

          // 🔥 CENTER ADD BUTTON
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => provider.setIndex(2, context),
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppThemeColors().primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                          AppThemeColors().primary.withOpacity(0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "ADD",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem(
      int index,
      IconData icon,
      String label,
      BottomBarProvider provider,
      ) {
    final isActive = provider.currentIndex == index;

    return GestureDetector(
      onTap: () => provider.setIndex(index, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color:
            isActive ? AppThemeColors().primary : Colors.black45,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color:
              isActive ? AppThemeColors().primary : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}

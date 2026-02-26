import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:gharzo_project/screens/reels/reels_feed/reels_feed_provider.dart';
import 'package:gharzo_project/screens/reels/reels_feed/comment_title.dart';
import 'package:gharzo_project/screens/reels/reels_feed/real_search/search_reel_view.dart';

import '../../../model/reels/reels_feed_model.dart';

class ReelsFeedView extends StatefulWidget {
  const ReelsFeedView({super.key});

  @override
  State<ReelsFeedView> createState() => _ReelsFeedViewState();
}

class _ReelsFeedViewState extends State<ReelsFeedView> {
  late final PageController _pageController;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReelsFeedProvider>().fetchReels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReelsFeedProvider>(
      builder: (_, provider, __) {
        if (provider.reels.isEmpty && provider.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            top: true,
            bottom: false, // ✅ Instagram style
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: provider.reels.length,
              onPageChanged: (index) {
                setState(() => _activeIndex = index);
                if (index >= provider.reels.length - 2) {
                  provider.fetchReels();
                }
              },
              itemBuilder: (_, index) {
                return ReelItem(
                  reel: provider.reels[index],
                  isActive: index == _activeIndex,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isActive;

  const ReelItem({
    super.key,
    required this.reel,
    required this.isActive,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late final VideoPlayerController _controller;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.reel.videoUrl),
    )
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted && widget.isActive) _controller.play();
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.isActive ? _controller.play() : _controller.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleMute() {
    _muted = !_muted;
    _controller.setVolume(_muted ? 0 : 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ReelsFeedProvider>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // 🎥 VIDEO
        _controller.value.isInitialized
            ? GestureDetector(
          onTap: toggleMute,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),

        // 🔍 SEARCH
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchReelsScreen()),
              );
            },
          ),
        ),

        // ❤️ ACTIONS (Instagram exact placement)
        Positioned(
          right: 12,
          bottom: 110, // 👈 fixed Instagram value
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  widget.reel.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.reel.isLiked ? Colors.red : Colors.white,
                  size: 32,
                ),
                onPressed: () => provider.toggleLike(widget.reel),
              ),
              Text(
                widget.reel.likesCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 14),
              IconButton(
                icon: Icon(
                  widget.reel.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => provider.toggleSave(widget.reel),
              ),
              const SizedBox(height: 14),
              IconButton(
                icon: const Icon(Icons.comment, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ReelCommentsSheet(reelId: widget.reel.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // 👤 USER + CAPTION
        Positioned(
          left: 12,
          right: 96,
          bottom: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: widget.reel.userImage != null
                        ? NetworkImage(widget.reel.userImage!)
                        : null,
                    backgroundColor: Colors.grey.shade800,
                    child: widget.reel.userImage == null
                        ? const Icon(Icons.person,
                        color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.reel.userName ?? "User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (widget.reel.caption != null)
                Text(
                  widget.reel.caption!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gharzo_project/screens/reels/reels_feed/comment_title.dart';
import 'package:gharzo_project/screens/reels/reels_feed/real_search/search_reel_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:gharzo_project/model/reels/reels_model.dart';
import 'package:gharzo_project/screens/reels/reels_feed/reels_feed_provider.dart';

class ReelsFeedView extends StatefulWidget {
  const ReelsFeedView({super.key});

  @override
  State<ReelsFeedView> createState() => _ReelsFeedViewState();
}

class _ReelsFeedViewState extends State<ReelsFeedView> {
  late PageController _pageController;
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReelsFeedProvider>(
      builder: (context, provider, _) {
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
          body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: provider.reels.length,
            onPageChanged: (index) {
              setState(() => _activeIndex = index);

              if (index >= provider.reels.length - 2) {
                provider.fetchReels();
              }
            },
            itemBuilder: (context, index) {
              return _ReelItem(
                reel: provider.reels[index],
                isActive: index == _activeIndex,
              );
            },
          ),
        );
      },
    );
  }
}

class _ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isActive;

  const _ReelItem({
    required this.reel,
    required this.isActive,
  });

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  late VideoPlayerController _videoController;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.reel.videoUrl),
    )
      ..setLooping(true)
      ..initialize().then((_) {
        if (widget.isActive) {
          _videoController.play();
        }
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant _ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      _videoController.play();
    } else {
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void toggleMute() {
    isMuted = !isMuted;
    _videoController.setVolume(isMuted ? 0 : 1);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final provider = context.read<ReelsFeedProvider>();

    return Stack(
      fit: StackFit.expand,
      children: [
        _videoController.value.isInitialized
            ? GestureDetector(
          onTap: toggleMute,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: VideoPlayer(_videoController),
            ),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),

        Positioned(
          top: 40,
          right: 16,
          child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchReelsScreen(),
                  ),
                );
              } ,
              icon: Icon(Icons.search)
          ),
        ),

        Positioned(
          right: 12,
          bottom: 120,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  widget.reel.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: widget.reel.isLiked ? Colors.red : Colors.white,
                  size: 32,
                ),
                onPressed: () {}
                // => provider.
                // toggleLike(widget.reel),
              ),
              Text(
                widget.reel.likesCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12),
              IconButton(
                icon: Icon(
                  widget.reel.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => provider.toggleSave(widget.reel),
              ),
              SizedBox(height: 12),
              IconButton(
                icon: const Icon(
                  Icons.comment,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReelCommentsSheet(reelId: widget.reel.id),
                    ),
                  );

                },
              ),

            ],
          ),
        ),

        Positioned(
          left: 12,
          bottom: 80,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.reel.userImage != null
                        ? NetworkImage(widget.reel.userImage!)
                        : null,
                    backgroundColor: Colors.grey.shade800,
                    child: widget.reel.userImage == null
                        ? const Icon(Icons.person, size: 18, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reel.userName ?? "User",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (widget.reel.city != null)
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 12, color: Colors.white70),
                            const SizedBox(width: 2),
                            Text(
                              [
                                widget.reel.locality,
                                widget.reel.city,
                              ]
                                  .where((e) =>
                              e != null && e!.trim().isNotEmpty)
                                  .join(", "),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),

               SizedBox(height: 8),

              if (widget.reel.caption != null)
                Text(
                  widget.reel.caption!,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),


      ],
    );
  }
}



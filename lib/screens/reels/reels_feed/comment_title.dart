import 'package:flutter/material.dart';
import 'package:gharzo_project/model/reels/comment_model.dart';
import 'package:gharzo_project/screens/reels/reels_feed/reels_feed_provider.dart';
import 'package:provider/provider.dart';

class ReelCommentsSheet extends StatefulWidget {
  final String reelId;

  const ReelCommentsSheet({super.key, required this.reelId});

  @override
  State<ReelCommentsSheet> createState() => _ReelCommentsSheetState();
}

class _ReelCommentsSheetState extends State<ReelCommentsSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ReelsFeedProvider>().fetchComments(widget.reelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material( // ✅ REQUIRED
      color: Colors.transparent,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Divider(height: 16),

                /// 🔹 COMMENTS LIST
                Expanded(
                  child: Consumer<ReelsFeedProvider>(
                    builder: (context, provider, _) {
                      if (provider.isCommentsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (provider.comments.isEmpty) {
                        return const Center(
                          child: Text(
                            "No comments yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        children: _buildCommentsTree(
                          provider.comments,
                          provider,
                        ),
                      );
                    },
                  ),
                ),
                _replyIndicator(),
                _commentInputSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _replyIndicator() {
    return Consumer<ReelsFeedProvider>(
      builder: (context, provider, _) {
        if (provider.replyingToUser == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          color: Colors.grey.shade100,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Replying to ${provider.replyingToUser}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: provider.cancelReply,
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _commentInputSection() {
    final provider = context.watch<ReelsFeedProvider>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),

            /// INPUT
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: provider.replyingToUser != null
                        ? "Reply to ${provider.replyingToUser}"
                        : "Add a comment…",
                    hintStyle: const TextStyle(fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: _controller.text.trim().isEmpty
                  ? null
                  : () {
                provider.postComment(
                  reelId: widget.reelId,
                  text: _controller.text.trim(),
                );
                _controller.clear();
                FocusScope.of(context).unfocus();
              },
              child: Text(
                "Post",
                style: TextStyle(
                  color: _controller.text.trim().isEmpty
                      ? Colors.grey
                      : Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<Widget> _buildCommentsTree(
      List<CommentModel> comments,
      ReelsFeedProvider provider,
      ) {
    final mainComments =
    comments.where((c) => c.parentId == null).toList();

    return mainComments.map((comment) {
      final replies =
      comments.where((r) => r.parentId == comment.id).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commentTile(comment, provider, isReply: false),
          if (replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 46, top: 8),
              child: Column(
                children: replies
                    .map((reply) =>
                    _commentTile(reply, provider, isReply: true))
                    .toList(),
              ),
            ),
          const SizedBox(height: 20),
        ],
      );
    }).toList();
  }

  Widget _commentTile(
      CommentModel comment,
      ReelsFeedProvider provider, {
        required bool isReply,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isReply ? 14 : 18,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: comment.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(text: comment.text),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Text(
                      "2h",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () => provider.setReply(comment),
                      child: const Text(
                        "Reply",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// LIKE ICON
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.favorite_border,
              size: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

}

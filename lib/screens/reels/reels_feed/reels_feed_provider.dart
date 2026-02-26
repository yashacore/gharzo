import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/data/reels_api_service/reels_api_service.dart';
import 'package:gharzo_project/model/reels/comment_model.dart';

import '../../../model/reels/reels_feed_model.dart';


class ReelsFeedProvider extends ChangeNotifier {
  final List<Reel> _reels = [];

  List<Reel> get reels => _reels;

  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;

  final Set<String> likeProcessing = {};

  List<CommentModel> comments = [];

  String? replyingToCommentId;
  String? replyingToUser;

  bool isCommentsLoading = false;

  // ================= FETCH REELS =================
  Future<void> fetchReels({bool refresh = false}) async {
    if (isLoading || !hasMore) return;

    if (refresh) {
      reels.clear();
      currentPage = 1;
      hasMore = true;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await ReelsApiService.getReelsFeed(page: currentPage);

      if (response == null || response.data.isEmpty) {
        debugPrint("⚠️ NO MORE REELS OR API FAILED");
        hasMore = false;
        return;
      }

      reels.addAll(response.data);
      hasMore = response.currentPage < response.totalPages;
      currentPage++;
    } catch (e) {
      debugPrint("🔥 Fetch reels provider error: $e");
      hasMore = false; // ⛔ STOP LOOP
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(Reel reel) async {
    if (likeProcessing.contains(reel.id)) return;

    likeProcessing.add(reel.id);

    final index = _reels.indexWhere((r) => r.id == reel.id);
    if (index == -1) {
      likeProcessing.remove(reel.id);
      return;
    }

    final oldReel = _reels[index];

    // 🔥 Optimistic update
    final bool optimisticLike = !oldReel.isLiked;
    final int optimisticLikes = optimisticLike
        ? oldReel.likesCount + 1
        : (oldReel.likesCount > 0 ? oldReel.likesCount - 1 : 0);

    _reels[index] = oldReel.copyWith(
      isLiked: optimisticLike,
      likesCount: optimisticLikes,
    );
    notifyListeners();

    try {
      debugPrint("📡 CALLING LIKE API...");

      // final result = await ReelsApiService.likeReel(reel.id);

      final result = await ReelsApiService.likeReel(reel.id);
      debugPrint("🟣 API RESPONSE: $result");

      _reels[index] = _reels[index].copyWith(
        isLiked: result["isLiked"] as bool,
        likesCount: result["likes"] as int,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("❌ LIKE API ERROR: $e");

      // 🔄 Rollback
      _reels[index] = oldReel;
      notifyListeners();
    } finally {
      likeProcessing.remove(reel.id);
    }
  }

  Future<void> toggleSave(Reel reel) async {
    final token = await PrefService.getToken();
    print("token");
    print(token);
    if (token == null) return;

    final index = _reels.indexWhere((r) => r.id == reel.id);

    debugPrint("Save Id :: $index");
    if (index == -1) return;

    final oldReel = _reels[index];
    final bool newSavedState = !oldReel.isSaved;

    _reels[index] = oldReel.copyWith(isSaved: newSavedState);
    notifyListeners();

    try {
      final response = await ReelsApiService.saveReel(reel.id, token);

      if (response == null || !response.success) {
        _reels[index] = oldReel;
        notifyListeners();
      } else {
        _reels[index] = _reels[index].copyWith(
          isSaved: response.data?.isSaved ?? newSavedState,
        );
        notifyListeners();
      }
    } catch (e) {
      /// ❌ exception → rollback
      _reels[index] = oldReel;
      notifyListeners();
    }
  }

  Future<void> fetchComments(String reelId) async {
    isCommentsLoading = true;
    notifyListeners();

    try {
      comments = await ReelsApiService.fetchComments(reelId);
    } catch (e) {
      debugPrint("❌ Fetch comments error: $e");
    }

    isCommentsLoading = false;
    notifyListeners();
  }

  Future<void> postComment({
    required String reelId,
    required String text,
  }) async {
    final success = await ReelsApiService.addComment(
      reelId: reelId,
      text: text,
      parentId: replyingToCommentId,
    );

    if (!success) return;

    comments.add(
      CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        userName: "You",
        parentId: replyingToCommentId,
      ),
    );

    final reelIndex = _reels.indexWhere((r) => r.id == reelId);
    if (reelIndex != -1) {
      _reels[reelIndex] = _reels[reelIndex].copyWith(
        commentsCount: _reels[reelIndex].commentsCount + 1,
      );
    }

    replyingToCommentId = null;
    replyingToUser = null;

    notifyListeners();
  }

  void setReply(CommentModel comment) {
    replyingToCommentId = comment.id;
    replyingToUser = comment.userName;
    notifyListeners();
  }

  void cancelReply() {
    replyingToCommentId = null;
    replyingToUser = null;
    notifyListeners();
  }
}

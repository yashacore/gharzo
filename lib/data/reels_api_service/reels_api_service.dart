import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/reels/comment_model.dart';
import 'package:gharzo_project/model/reels/reels_model.dart';
import 'package:gharzo_project/model/reels/save_reel_model.dart';
import 'package:http/http.dart' as http;

class ReelsApiService {


  static const String baseUrl = "https://api.gharzoreality.com/api/reels/feed";
  static const String token = "YOUR_TOKEN";

  static Map<String, String> headers() => {
    "Authorization": "Bearer $token",
  };

  //fetch reels
  static Future<Map<String, String>> getToken() async {
    final token = await PrefService.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  static Future<ReelResponse?> getReelsFeed({
    int page = 1,
    int limit = 10,
    String type = "latest",
    String city = "Indore",
  }) async {
    final url = Uri.parse(
      '$baseUrl?type=$type&city=$city&page=$page&limit=$limit',
    );

    try {
      final response = await http.get(
        url,
        headers: await getToken(),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return ReelResponse.fromJson(jsonBody);
      } else {
        print('Reels API failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching reels: $e');
      return null;
    }
  }


  static Future<bool> toggleLike(String reelId, String token) async {
    try {
      final url = '$baseUrl/reels/$reelId/like';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final body = jsonDecode(response.body);
      return response.statusCode == 200 && body['success'] == true;
    } catch (e) {
      debugPrint('Toggle like error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> likeReel(String reelId) async {
    final token = await PrefService.getToken();

    final response = await http.post(
      Uri.parse(
        "https://api.gharzoreality.com/api/reels/$reelId/like",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json["success"] == true) {
      return {
        "likes": json["likes"],
        "isLiked": json["isLiked"],
      };
    } else {
      throw Exception("Like failed");
    }
  }



 static Future<ReelSaveResponse?> saveReel(String reelId, String token) async {
    final url = Uri.parse("https://api.gharzoreality.com/api/reels/$reelId/save");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "save": true,
      }),
    );

    if (response.statusCode == 200) {
      return ReelSaveResponse.fromJson(jsonDecode(response.body));
    } else {
      print("Error saving reel: ${response.body}");
      return null;
    }
  }

  // static Future<List<CommentModel>> getComments(String reelId) async {
  // final res = await http.get(
  // Uri.parse("$baseUrl/reels/$reelId/comments"),
  // headers: headers(),
  // );
  // final data = json.decode(res.body);
  // return (data['data'] as List)
  //     .map((e) => CommentModel.fromJson(e))
  //     .toList();
  // }

  static Future<bool> addComment({
    required String reelId,
    required String text,
    String? parentId,
  }) async {
    try {
      final token = await PrefService.getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      final url = Uri.parse('https://api.gharzoreality.com/api/reels/$reelId/comments');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(
          AddCommentRequest(text: text).toJson(),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Comment Added Successfully");
        return true;
      } else {
        print("Failed: ${response.body}");
        return false;
      }

    } catch (e) {
      print("🔥 Error addComment: $e");
      return false;
    }
  }


  //--------------fetch Comment
  static Future<List<CommentModel>> fetchComments(String reelId) async {
    try {
      final token = await PrefService.getToken();

      if (token == null) {
        debugPrint("❌ Token not found");
        return [];
      }

      final url = Uri.parse("https://api.gharzoreality.com/api/reels/$reelId/comments");

      debugPrint("📥 FETCH COMMENTS");
      debugPrint("🆔 ReelId: $reelId");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📥 StatusCode: ${response.statusCode}");
      debugPrint("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List list = decoded["data"] ?? [];

        return list
            .map((e) => CommentModel.fromJson(e))
            .toList();
      } else {
        debugPrint("❌ Failed to fetch comments");
        return [];
      }
    } catch (e) {
      debugPrint("🔥 fetchComments error: $e");
      return [];
    }
  }
}


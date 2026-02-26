class Reel {
  final String id;
  final String videoUrl;
  final String? caption;

  final String? userName;
  final String? userImage;

  final String? city;
  final String? locality;

  final int likesCount;
  final int savesCount;
  final int commentsCount;

  final bool isLiked;
  final bool isSaved;

  Reel({
    required this.id,
    required this.videoUrl,
    this.caption,
    this.userName,
    this.userImage,
    this.city,
    this.locality,
    required this.likesCount,
    required this.savesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
  });

  /// ✅ FROM JSON
  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['_id'],
      videoUrl: json['videoUrl'],
      caption: json['caption'],
      userName: json['uploadedBy']?['name'],
      userImage: json['uploadedBy']?['profileImage']?['url'],
      city: json['location']?['city'],
      locality: json['location']?['locality'],
      likesCount: json['likes'] ?? 0,
      savesCount: json['saves'] ?? 0,
      commentsCount: json['comments'] ?? 0,
      isLiked: json['isLiked'] ?? false, // backend dependent
      isSaved: json['isSaved'] ?? false, // backend dependent
    );
  }

  /// ✅ COPY WITH (THIS FIXES YOUR ERROR)
  Reel copyWith({
    String? id,
    String? videoUrl,
    String? caption,
    String? userName,
    String? userImage,
    String? city,
    String? locality,
    int? likesCount,
    int? savesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
  }) {
    return Reel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      caption: caption ?? this.caption,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      likesCount: likesCount ?? this.likesCount,
      savesCount: savesCount ?? this.savesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}class ReelsFeedResponse {
  final List<Reel> data;
  final int currentPage;
  final int totalPages;

  ReelsFeedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  factory ReelsFeedResponse.fromJson(Map<String, dynamic> json) {
    return ReelsFeedResponse(
      data: (json['data'] as List? ?? [])
          .map((e) => Reel.fromJson(e))
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  factory ReelsFeedResponse.empty() {
    return ReelsFeedResponse(
      data: const [],
      currentPage: 1,
      totalPages: 1,
    );
  }
}
class ReelModel {
  final String id;
  final ReelProperty? property;
  final ReelUser uploadedBy;
  final String videoUrl;
  final String caption;
  final List<String> tags;
  final int duration;
  final int views;
  final int likes;
  final int saves;
  final int shares;
  final int comments;
  final String status;
  final DateTime createdAt;

  ReelModel({
    required this.id,
    required this.property,
    required this.uploadedBy,
    required this.videoUrl,
    required this.caption,
    required this.tags,
    required this.duration,
    required this.views,
    required this.likes,
    required this.saves,
    required this.shares,
    required this.comments,
    required this.status,
    required this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['_id'],
      property: json['propertyId'] != null
          ? ReelProperty.fromJson(json['propertyId'])
          : null,
      uploadedBy: ReelUser.fromJson(json['uploadedBy']),
      videoUrl: json['videoUrl'],
      caption: json['caption'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      duration: json['duration'] ?? 0,
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      saves: json['saves'] ?? 0,
      shares: json['shares'] ?? 0,
      comments: json['comments'] ?? 0,
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ReelProperty {
  final String id;
  final String title;
  final String listingType;

  ReelProperty({
    required this.id,
    required this.title,
    required this.listingType,
  });

  factory ReelProperty.fromJson(Map<String, dynamic> json) {
    return ReelProperty(
      id: json['_id'],
      title: json['title'] ?? '',
      listingType: json['listingType'] ?? '',
    );
  }
}

class ReelUser {
  final String id;
  final String name;
  final String? profileImage;

  ReelUser({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory ReelUser.fromJson(Map<String, dynamic> json) {
    return ReelUser(
      id: json['_id'],
      name: json['name'] ?? '',
      profileImage: json['profileImage']?['url'],
    );
  }
}
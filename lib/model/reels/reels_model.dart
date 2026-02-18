class ReelResponse {
  final bool success;
  final List<Reel> data;
  final int totalPages;
  final int currentPage;

  ReelResponse({
    required this.success,
    required this.data,
    required this.totalPages,
    required this.currentPage,
  });

  factory ReelResponse.fromJson(Map<String, dynamic> json) => ReelResponse(
    success: json["success"] ?? false,
    data: json["data"] != null
        ? List<Reel>.from(json["data"].map((x) => Reel.fromJson(x)))
        : [],
    totalPages: json["totalPages"] ?? 1,
    currentPage: json["currentPage"] ?? 1,
  );
}

class Reel {
  final String id;
  final String videoUrl;
  final bool isLiked;
  final bool isSaved;
  final int likesCount;
  final int commentsCount;
  final String? userName;
  final String? userImage;
  final String? caption;
  final String? city;
  final String? locality;

  Reel({
    required this.id,
    required this.videoUrl,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.isSaved,
    this.userName,
    this.userImage,
    this.caption,
    this.city,
    this.locality,
  });

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
    id: json["_id"] ?? "",
    videoUrl: json["videoUrl"] ?? "",
    isLiked: json["isLiked"] == true,
    isSaved: json["isSaved"] == true,
    likesCount: json["likes"] ?? 0,
    commentsCount: json["comments"] ?? 0,
    caption: json["caption"],
    userName: json["uploadedBy"]?["name"] ?? "User",
    userImage: json["uploadedBy"]?["profileImage"],
    city: json["location"]?["city"],
    locality: json["location"]?["locality"],
  );

  Reel copyWith({
    bool? isLiked,
    int? likesCount,
    bool? isSaved,
    int? commentsCount,
  }) {
    return Reel(
      id: id,
      videoUrl: videoUrl,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isSaved: isSaved ?? this.isSaved,
      userName: userName,
      userImage: userImage,
      caption: caption,
      city: city,
      locality: locality,
    );
  }
}

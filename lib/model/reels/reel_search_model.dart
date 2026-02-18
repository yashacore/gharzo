class ReelSearchModel {
  final String id;
  final String title;
  final String city;
  final List<String> tags;
  final String imageUrl;

  ReelSearchModel({
    required this.id,
    required this.title,
    required this.city,
    required this.tags,
    required this.imageUrl,
  });

  factory ReelSearchModel.fromJson(Map<String, dynamic> json) {
    return ReelSearchModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      city: json['city'] ?? '',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

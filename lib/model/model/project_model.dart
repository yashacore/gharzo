class ProjectModel {
  final String id;
  final String name;
  final String tagline;
  final String city;
  final String status;
  final int minPrice;
  final int maxPrice;
  final String image;
  final bool isFeatured;
  final bool isPremium;

  ProjectModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.city,
    required this.status,
    required this.minPrice,
    required this.maxPrice,
    required this.image,
    required this.isFeatured,
    required this.isPremium,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'],
      name: json['projectName'],
      tagline: json['tagline'] ?? '',
      city: json['location']?['city'] ?? '',
      status: json['projectStatus']?['status'] ?? '',
      minPrice: json['pricing']?['priceRange']?['min'] ?? 0,
      maxPrice: json['pricing']?['priceRange']?['max'] ?? 0,
      image: (json['media']?['images'] != null &&
          json['media']['images'].isNotEmpty)
          ? json['media']['images'][0]['url']
          : '',
      isFeatured: json['isFeatured'] ?? false,
      isPremium: json['isPremium'] ?? false,
    );
  }
}
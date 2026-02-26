class ProjectDetailModel {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String city;
  final String status;
  final int minPrice;
  final int maxPrice;
  final List<String> images;
  final List<String> highlights;
  final List<String> amenities;

  ProjectDetailModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.city,
    required this.status,
    required this.minPrice,
    required this.maxPrice,
    required this.images,
    required this.highlights,
    required this.amenities,
  });

  factory ProjectDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ProjectDetailModel(
      id: data['_id'],
      name: data['projectName'],
      tagline: data['tagline'] ?? '',
      description: data['description'] ?? '',
      city: data['location']['city'],
      status: data['projectStatus']['status'],
      minPrice: data['pricing']['priceRange']['min'],
      maxPrice: data['pricing']['priceRange']['max'],
      images: (data['media']['images'] as List)
          .map((e) => e['url'] as String)
          .toList(),
      highlights: List<String>.from(data['highlights']),
      amenities: [
        ...List<String>.from(data['amenities']['basic']),
        ...List<String>.from(data['amenities']['premium']),
      ],
    );
  }
}
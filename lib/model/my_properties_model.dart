class MyProperty {
  final String id;
  final String title;
  final String propertyType;
  final String listingType;
  final String status;
  final int completionPercentage;
  final String city;
  final String? image;
  final DateTime createdAt;

  MyProperty({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.listingType,
    required this.status,
    required this.completionPercentage,
    required this.city,
    required this.image,
    required this.createdAt,
  });

  factory MyProperty.fromJson(Map<String, dynamic> json) {
    return MyProperty(
      id: json['_id'],
      title: json['title'] ?? '',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      status: json['status'] ?? '',
      completionPercentage: json['completionPercentage'] ?? 0,
      city: json['location']?['city'] ?? '—',
      image: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

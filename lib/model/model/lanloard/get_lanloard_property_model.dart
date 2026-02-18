class LanloardPropertyModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String propertyType;
  final String listingType;
  final String status;
  final String verificationStatus;
  final Map<String, dynamic> price;
  final Map<String, dynamic> area;
  final Map<String, dynamic> location;
  final List<dynamic> images;
  final Map<String, dynamic> owner;

  LanloardPropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.propertyType,
    required this.listingType,
    required this.status,
    required this.verificationStatus,
    required this.price,
    required this.area,
    required this.location,
    required this.images,
    required this.owner,
  });

  factory LanloardPropertyModel.fromJson(Map<String, dynamic> json) {
    return LanloardPropertyModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      status: json['status'] ?? '',
      verificationStatus: json['verificationStatus'] ?? '',
      price: json['price'] ?? {},
      area: json['area'] ?? {},
      location: json['location'] ?? {},
      images: json['images'] ?? [],
      owner: json['ownerId'] ?? {},
    );
  }
}

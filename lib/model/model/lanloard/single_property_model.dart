class SinglePropertyModel {
  final String id;
  final String title;
  final String description;
  final int bhk;
  final int bathrooms; // Added
  final String propertyAge; // Added
  final String propertyType;
  final String listingType;
  final String status;
  final String verificationStatus;
  final Map<String, dynamic> price;
  final Map<String, dynamic> area;
  final List images;
  final String availableFrom;
  final Map owner;

  SinglePropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bhk,
    required this.bathrooms,
    required this.propertyAge,
    required this.propertyType,
    required this.listingType,
    required this.status,
    required this.verificationStatus,
    required this.price,
    required this.area,
    required this.images,
    required this.availableFrom,
    required this.owner,
  });

  factory SinglePropertyModel.fromJson(Map<String, dynamic> json) {
    return SinglePropertyModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      bhk: json['bhk'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0, // Parse bathrooms
      propertyAge: json['propertyAge'] ?? '-', // Parse propertyAge
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      status: json['status'] ?? '',
      verificationStatus: json['verificationStatus'] ?? '',
      price: json['price'] ?? {},
      area: json['area'] ?? {},
      images: json['images'] ?? [],
      availableFrom: json['availableFrom'] ?? '',
      owner: json['ownerId'] ?? {},
    );
  }
}

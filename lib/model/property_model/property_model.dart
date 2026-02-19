class PropertyModel {
  final String id;
  final String title;

  // Price
  final int priceAmount;
  final bool isNegotiable;

  // Location
  final String city;
  final String locality;

  // Property details
  final int bhk;
  final int bathrooms;
  final double carpetArea;
  final String areaUnit;
  final String furnishing;

  // Flags
  final bool isFeatured;
  final bool isVerified;

  // Media
  final String imageUrl;

  PropertyModel({
    required this.id,
    required this.title,
    required this.priceAmount,
    required this.isNegotiable,
    required this.city,
    required this.locality,
    required this.bhk,
    required this.bathrooms,
    required this.carpetArea,
    required this.areaUnit,
    required this.furnishing,
    required this.isFeatured,
    required this.isVerified,
    required this.imageUrl,
  });

  // ================= JSON =================

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List? ?? [];

    // 🔑 pick primary image first
    String imageUrl = '';
    if (images.isNotEmpty) {
      final primary = images.firstWhere(
            (img) => img['isPrimary'] == true,
        orElse: () => images.first,
      );
      imageUrl = primary['url'] ?? '';
    }

    return PropertyModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',

      priceAmount: json['price']?['amount'] ?? 0,
      isNegotiable: json['price']?['negotiable'] ?? false,

      city: json['location']?['city'] ?? '',
      locality: json['location']?['locality'] ?? '',

      bhk: json['bhk'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      carpetArea: (json['area']?['carpet'] ?? 0).toDouble(),
      areaUnit: json['area']?['unit'] ?? 'sqft',

      furnishing: json['furnishing']?['type'] ?? 'Unfurnished',

      isFeatured: json['isFeatured'] ?? false,
      isVerified: json['verificationStatus'] == 'Verified',

      imageUrl: imageUrl,
    );
  }

  // ================= HELPERS FOR UI =================

  String get formattedPrice => "₹$priceAmount";

  String get fullLocation =>
      locality.isNotEmpty ? "$locality, $city" : city;

  String get areaText => "$carpetArea $areaUnit";
}

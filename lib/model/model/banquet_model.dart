class BanquetModel {
  final String id;
  final String name;
  final String description;
  final String city;
  final String state;
  final String venueType;
  final String imageUrl;
  final int minPrice;
  final int maxPrice;
  final int seating;
  final int floating;

  BanquetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.state,
    required this.venueType,
    required this.imageUrl,
    required this.minPrice,
    required this.maxPrice,
    required this.seating,
    required this.floating,
  });

  factory BanquetModel.fromJson(Map<String, dynamic> json) {
    return BanquetModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['location']?['city'] ?? '',
      state: json['location']?['state'] ?? '',
      venueType: json['venueType'] ?? '',
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : '',
      minPrice: json['priceRange']?['min'] ?? 0,
      maxPrice: json['priceRange']?['max'] ?? 0,
      seating: json['totalCapacity']?['seating'] ?? 0,
      floating: json['totalCapacity']?['floating'] ?? 0,
    );
  }
}

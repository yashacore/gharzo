class PropertyModel {
  final String id;
  final String title;
  final String city;
  final String locality;
  final String image;
  final int price;
  final int bhk;
  final int area;
  final String propertyType;

  PropertyModel({
    required this.id,
    required this.title,
    required this.city,
    required this.locality,
    required this.image,
    required this.price,
    required this.bhk,
    required this.area,
    required this.propertyType,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['_id'],
      title: json['title'] ?? '',
      city: json['location']['city'] ?? '',
      locality: json['location']['locality'] ?? '',
      image: json['images'].isNotEmpty
          ? json['images'][0]['url']
          : '',
      price: json['price']['amount'] ?? 0,
      bhk: json['bhk'] ?? 0,
      area: json['area']['carpet'] ?? 0,
      propertyType: json['propertyType'] ?? '',
    );
  }
}

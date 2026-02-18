class PropertyModel {
  final String id;
  final String title;
  final String price;
  final String location;
  final String imageUrl;

  PropertyModel({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['_id'],
      title: json['title'] ?? '',
      price: "₹${json['price']?['amount'] ?? ''}",
      location: json['location']?['city'] ?? '',
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : '',
    );
  }
}





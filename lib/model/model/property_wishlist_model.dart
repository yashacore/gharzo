class SavedPropertyResponse {
  final bool success;
  final int count;
  final int total;
  final int totalPages;
  final int currentPage;
  final List<SavedPropertyModel> data;

  SavedPropertyResponse({
    required this.success,
    required this.count,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.data,
  });

  factory SavedPropertyResponse.fromJson(Map<String, dynamic> json) {
    return SavedPropertyResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      data: (json['data'] as List? ?? [])
          .map((e) => SavedPropertyModel.fromJson(e))
          .toList(),
    );
  }
}
class SavedPropertyModel {
  final String id;
  final String savedId;
  final String title;
  final String category;
  final String propertyType;
  final String listingType;
  final int bhk;
  final int? bathrooms;
  final int price;
  final String pricePer;
  final String city;
  final String locality;
  final String image;
  final bool isSaved;
  final String? note;
  final DateTime savedAt;

  SavedPropertyModel({
    required this.id,
    required this.savedId,
    required this.title,
    required this.category,
    required this.propertyType,
    required this.listingType,
    required this.bhk,
    required this.bathrooms,
    required this.price,
    required this.pricePer,
    required this.city,
    required this.locality,
    required this.image,
    required this.isSaved,
    required this.note,
    required this.savedAt,
  });

  factory SavedPropertyModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List? ?? [];

    return SavedPropertyModel(
      id: json['_id'] ?? '',
      savedId: json['savedId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      bhk: json['bhk'] ?? 0,
      bathrooms: json['bathrooms'],
      price: json['price']?['amount'] ?? 0,
      pricePer: json['price']?['per'] ?? '',
      city: json['location']?['city'] ?? '',
      locality: json['location']?['locality'] ?? '',
      image: images.isNotEmpty ? images.first['url'] ?? '' : '',
      isSaved: json['isSaved'] ?? false,
      note: json['note'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }
}

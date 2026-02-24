class PropertyDetailsModel {
  final String id;
  final String title;
  final String propertyType;
  final String listingType;
  final String status;
  final int completionPercentage;
  final int bhk;
  final int bathrooms;
  final int balconies;
  final String propertyAge;
  final String description;
  final DateTime availableFrom;

  // Price
  final int amount;
  final bool negotiable;
  final int securityDeposit;

  // Area
  final int carpetArea;
  final String areaUnit;

  PropertyDetailsModel({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.listingType,
    required this.status,
    required this.completionPercentage,
    required this.bhk,
    required this.bathrooms,
    required this.balconies,
    required this.propertyAge,
    required this.description,
    required this.availableFrom,
    required this.amount,
    required this.negotiable,
    required this.securityDeposit,
    required this.carpetArea,
    required this.areaUnit,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsModel(
      id: json['_id'],
      title: json['title'] ?? '',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      status: json['status'] ?? '',
      completionPercentage: json['completionPercentage'] ?? 0,
      bhk: json['bhk'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      balconies: json['balconies'] ?? 0,
      propertyAge: json['propertyAge'] ?? '',
      description: json['description'] ?? '',
      availableFrom: DateTime.parse(json['availableFrom']),
      amount: json['price']?['amount'] ?? 0,
      negotiable: json['price']?['negotiable'] ?? false,
      securityDeposit: json['price']?['securityDeposit'] ?? 0,
      carpetArea: json['area']?['carpet'] ?? 0,
      areaUnit: json['area']?['unit'] ?? '',
    );
  }
}

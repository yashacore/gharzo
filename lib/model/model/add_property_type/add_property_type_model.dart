class PropertyTypeModel {
  String? propertyId;
  String category;
  String propertyType;
  String listingType;

  PropertyTypeModel({
    this.propertyId,
    required this.category,
    required this.propertyType,
    required this.listingType,
  });

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      propertyId: json['data']['propertyId'],
      category: json['data']['category'] ?? '',
      propertyType: json['data']['propertyType'] ?? '',
      listingType: json['data']['listingType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'propertyType': propertyType,
      'listingType': listingType,
    };
  }
}


class PropertyDraftModel {
  final String propertyId;
  final int completionPercentage;
  final String nextStep;

  PropertyDraftModel({
    required this.propertyId,
    required this.completionPercentage,
    required this.nextStep,
  });

  factory PropertyDraftModel.fromJson(Map<String, dynamic> json) {
    return PropertyDraftModel(
      propertyId: json['propertyId'],
      completionPercentage: json['completionPercentage'],
      nextStep: json['nextStep'],
    );
  }
}

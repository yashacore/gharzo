class AmenityModel {
  final String name;
  final String icon;

  AmenityModel({required this.name, this.icon = ""});

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      name: json['name'],
      icon: json['icon'] ?? "",
    );
  }

  factory AmenityModel.fromString(String value) {
    return AmenityModel(name: value);
  }
}

class AmenitiesMasterResponse {
  final List<AmenityModel> basic;
  final List<AmenityModel> society;
  final List<AmenityModel> nearby;

  AmenitiesMasterResponse({
    required this.basic,
    required this.society,
    required this.nearby,
  });

  factory AmenitiesMasterResponse.fromJson(Map<String, dynamic> json) {
    return AmenitiesMasterResponse(
      basic: (json['basic'] as List).map((e) => AmenityModel.fromJson(e)).toList(),
      society: (json['society'] as List).map((e) => AmenityModel.fromJson(e)).toList(),
      nearby: (json['nearby'] as List).map((e) => AmenityModel.fromJson(e)).toList(),
    );
  }
}

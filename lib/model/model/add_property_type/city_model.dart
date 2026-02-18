class CityModel {
  final String id;
  final String name;
  final String state;
  final int priority;

  CityModel({
    required this.id,
    required this.name,
    required this.state,
    required this.priority,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      state: json['state'] ?? '',
      priority: json['priority'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'state': state,
      'priority': priority,
    };
  }
}

// Optional: Model for the full API response
class CitiesResponse {
  final bool success;
  final int count;
  final List<CityModel> data;

  CitiesResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CitiesResponse.fromJson(Map<String, dynamic> json) {
    return CitiesResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CityModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}


class LocalityModel {
  final String name;

  LocalityModel({required this.name});

  factory LocalityModel.fromJson(dynamic json) {
    if (json is String) {
      return LocalityModel(name: json);
    } else {
      throw Exception("Invalid Locality JSON");
    }
  }

  @override
  String toString() => name;
}

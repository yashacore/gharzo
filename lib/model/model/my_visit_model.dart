class MyVisitResponse {
  final bool success;
  final int count;
  final List<MyVisit> visits;

  MyVisitResponse({
    required this.success,
    required this.count,
    required this.visits,
  });

  factory MyVisitResponse.fromJson(Map<String, dynamic> json) {
    return MyVisitResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      visits: (json['data'] as List? ?? [])
          .map((e) => MyVisit.fromJson(e))
          .toList(),
    );
  }
}

class MyVisit {
  final String id;
  final String visitNumber;
  final String status;
  final String preferredTimeSlot;
  final DateTime preferredDate;
  final String propertyTitle;
  final String city;
  final List<String> images;

  MyVisit({
    required this.id,
    required this.visitNumber,
    required this.status,
    required this.preferredTimeSlot,
    required this.preferredDate,
    required this.propertyTitle,
    required this.city,
    required this.images,
  });

  factory MyVisit.fromJson(Map<String, dynamic> json) {
    final property = json['propertyId'] ?? {};

    return MyVisit(
      id: json['_id'],
      visitNumber: json['visitNumber'] ?? '',
      status: json['status'] ?? '',
      preferredTimeSlot: json['preferredTimeSlot'] ?? '',
      preferredDate: DateTime.parse(json['preferredDate']),
      propertyTitle: property['title'] ?? '',
      city: property['location']?['city'] ?? '',
      images: (property['images'] as List? ?? [])
          .map((e) => e['url'].toString())
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }
}

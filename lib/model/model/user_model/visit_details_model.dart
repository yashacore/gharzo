class VisitDetailModel {
  final String id;
  final String visitNumber;
  final String status;
  final String propertyTitle;
  final String city;
  final DateTime preferredDate;
  final String preferredTimeSlot;
  final String visitType;
  final int numberOfVisitors;
  final String purpose;
  final String message;
  final List<TimelineItem> timeline;
  final List<String> images;

  VisitDetailModel({
    required this.id,
    required this.visitNumber,
    required this.status,
    required this.propertyTitle,
    required this.city,
    required this.preferredDate,
    required this.preferredTimeSlot,
    required this.visitType,
    required this.numberOfVisitors,
    required this.purpose,
    required this.message,
    required this.timeline,
    required this.images,
  });

  factory VisitDetailModel.fromJson(Map<String, dynamic> json) {
    final property = json['propertyId'] ?? {};

    return VisitDetailModel(
      id: json['_id'],
      visitNumber: json['visitNumber'] ?? '',
      status: json['status'] ?? '',
      propertyTitle: property['title'] ?? '',
      city: property['location']?['city'] ?? '',
      preferredDate: DateTime.parse(json['preferredDate']),
      preferredTimeSlot: json['preferredTimeSlot'] ?? '',
      visitType: json['visitType'] ?? '',
      numberOfVisitors: json['numberOfVisitors'] ?? 0,
      purpose: json['purpose'] ?? '',
      message: json['message'] ?? '',
      images: (property['images'] as List? ?? [])
          .map((e) => e['url'].toString())
          .where((e) => e.isNotEmpty)
          .toList(),
      timeline: (json['timeline'] as List? ?? [])
          .map((e) => TimelineItem.fromJson(e))
          .toList(),
    );
  }
}

class TimelineItem {
  final String status;
  final String name;
  final DateTime timestamp;
  final String notes;

  TimelineItem({
    required this.status,
    required this.name,
    required this.timestamp,
    required this.notes,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      status: json['status'] ?? '',
      name: json['updatedBy']?['name'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'] ?? '',
    );
  }
}

class SubmitPropertyResponseModel {
  final String propertyId;
  final String title;
  final String status;
  final int completionPercentage;
  final String publishedAt;
  final String estimatedApprovalTime;

  SubmitPropertyResponseModel({
    required this.propertyId,
    required this.title,
    required this.status,
    required this.completionPercentage,
    required this.publishedAt,
    required this.estimatedApprovalTime,
  });

  factory SubmitPropertyResponseModel.fromJson(Map<String, dynamic> json) {
    final property = json['property'];

    return SubmitPropertyResponseModel(
      propertyId: property['_id'],
      title: property['title'],
      status: property['status'],
      completionPercentage: property['completionPercentage'],
      publishedAt: property['publishedAt'],
      estimatedApprovalTime: json['estimatedApprovalTime'],
    );
  }
}

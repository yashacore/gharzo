class MyEnquiryModel {
  final String id;
  final String enquiryNumber;
  final String projectName;
  final String developerName;
  final String phone;
  final String configuration;
  final int budgetMin;
  final int budgetMax;
  final String status;
  final String priority;
  final DateTime createdAt;

  MyEnquiryModel({
    required this.id,
    required this.enquiryNumber,
    required this.projectName,
    required this.developerName,
    required this.phone,
    required this.configuration,
    required this.budgetMin,
    required this.budgetMax,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  factory MyEnquiryModel.fromJson(Map<String, dynamic> json) {
    return MyEnquiryModel(
      id: json['_id'],
      enquiryNumber: json['enquiryNumber'],
      projectName: json['projectId']['projectName'],
      developerName: json['projectId']['developer']['name'],
      phone: json['enquiryFrom']['phone'],
      configuration: json['interestedIn']['configurationType'],
      budgetMin: json['interestedIn']['budgetRange']['min'],
      budgetMax: json['interestedIn']['budgetRange']['max'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
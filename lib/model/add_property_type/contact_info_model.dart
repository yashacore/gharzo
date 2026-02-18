class ContactResponseModel {
  final int completionPercentage;
  final String nextStep;

  ContactResponseModel({
    required this.completionPercentage,
    required this.nextStep,
  });

  factory ContactResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactResponseModel(
      completionPercentage: json['completionPercentage'],
      nextStep: json['nextStep'],
    );
  }
}

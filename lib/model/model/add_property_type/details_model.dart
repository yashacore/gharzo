class BasicDetailsModel {
  final int completionPercentage;
  final String nextStep;

  BasicDetailsModel({
    required this.completionPercentage,
    required this.nextStep,
  });

  factory BasicDetailsModel.fromJson(Map<String, dynamic> json) {
    return BasicDetailsModel(
      completionPercentage: json['completionPercentage'],
      nextStep: json['nextStep'],
    );
  }
}

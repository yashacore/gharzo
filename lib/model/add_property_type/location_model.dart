class LocationResponseModel {
  final int completionPercentage;
  final String nextStep;

  LocationResponseModel({
    required this.completionPercentage,
    required this.nextStep,
  });

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) {
    return LocationResponseModel(
      completionPercentage: json['completionPercentage'],
      nextStep: json['nextStep'],
    );
  }
}
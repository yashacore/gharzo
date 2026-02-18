class PhotoUploadResponseModel {
  final int uploadedCount;
  final int totalImages;
  final int completionPercentage;
  final String nextStep;

  PhotoUploadResponseModel({
    required this.uploadedCount,
    required this.totalImages,
    required this.completionPercentage,
    required this.nextStep,
  });

  factory PhotoUploadResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data']; // nested data
    return PhotoUploadResponseModel(
      uploadedCount: data['uploadedCount'],
      totalImages: data['totalImages'],
      completionPercentage: data['completionPercentage'],
      nextStep: data['nextStep'],
    );
  }
}

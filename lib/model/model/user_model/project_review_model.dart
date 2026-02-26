class ProjectReviewRequest {
  final int rating;
  final String review;
  final List<String> pros;
  final List<String> cons;
  final String reviewType;

  ProjectReviewRequest({
    required this.rating,
    required this.review,
    required this.pros,
    required this.cons,
    required this.reviewType,
  });

  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "review": review,
      "pros": pros,
      "cons": cons,
      "reviewType": reviewType,
    };
  }
}
class Home {
  final bool success;
  final List data;
  final String message;

  Home({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      success: json['success'] ?? false,
      data: json['data'] ?? [],
      message: json['message'] ?? '',
    );
  }
}

class BulkCreateBedsResponse {
  final bool success;
  final String message;
  final List<dynamic>? data; // backend success case me beds array aata hai

  BulkCreateBedsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BulkCreateBedsResponse.fromJson(Map<String, dynamic> json) {
    return BulkCreateBedsResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}

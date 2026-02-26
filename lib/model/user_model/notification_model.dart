class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final NotificationData? details;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.details,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      details: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
    );
  }
}

class NotificationData {
  final String? image;
  final ActionButton? actionButton;

  NotificationData({this.image, this.actionButton});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      image: json['image'],
      actionButton: json['actionButton'] != null
          ? ActionButton.fromJson(json['actionButton'])
          : null,
    );
  }
}

class ActionButton {
  final bool enabled;
  final String text;
  final String actionType;
  final String actionValue;

  ActionButton({
    required this.enabled,
    required this.text,
    required this.actionType,
    required this.actionValue,
  });

  factory ActionButton.fromJson(Map<String, dynamic> json) {
    return ActionButton(
      enabled: json['enabled'],
      text: json['text'],
      actionType: json['actionType'],
      actionValue: json['actionValue'],
    );
  }
}

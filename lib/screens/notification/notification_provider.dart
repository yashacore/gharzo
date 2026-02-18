import 'package:flutter/cupertino.dart';

import '../../model/notification/notification_model.dart';

class NotificationProvider extends ChangeNotifier{
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Order Delivered',
      message: 'Your package has been delivered successfully.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: 'New Offer!',
      message: 'Get 50% off on your next purchase.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      title: 'Security Alert',
      message: 'New login detected from a Chrome browser.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
  ];

  List<NotificationModel> get notifications => _notifications;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }
}
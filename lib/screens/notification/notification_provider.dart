import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';

import '../../model/user_model/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  bool loading = false;
  String? error;

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // 🔔 Fetch notifications
  Future<void> fetchNotifications() async {
    loading = true;
    notifyListeners();

    try {
      final response = await ApiServiceMethod.getNotifications();

      if (response['success'] == true) {
        _notifications.clear();
        _notifications.addAll(
          (response['data'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList(),
        );
      } else {
        error = response['message'];
      }
    } catch (e) {
      error = "Failed to load notifications";
    }

    loading = false;
    notifyListeners();
  }

  // ✅ Mark single as read (local only)
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // ✅ Mark all as read
  Future<void> markAllAsRead() async {
    loading = true;
    notifyListeners();

    try {
      final fcmToken = await PrefService.getFcmToken();

      final response = await ApiServiceMethod.markAllNotificationsRead(
        fcmToken: fcmToken ?? "",
        device: "android",
      );

      debugPrint("📥 READ ALL RESPONSE => $response");

      if (response['success'] == true) {
        for (int i = 0; i < _notifications.length; i++) {
          if (!_notifications[i].isRead) {
            _notifications[i] = _notifications[i].copyWith(isRead: true);
          }
        }
      }
    } catch (e) {
      debugPrint("❌ PROVIDER READ ALL ERROR: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// ✅ Mark single notification as read (API + local)
  Future<void> markAsReadApi(
    String notificationId,
    BuildContext context,
  ) async {
    try {
      final fcmToken = await PrefService.getFcmToken();

      final response = await ApiServiceMethod.markNotificationRead(
        notificationId: notificationId,
        fcmToken: fcmToken ?? "",
        device: "android",
      );

      debugPrint("📥 SINGLE READ RESPONSE => $response");

      if (response['success'] == true) {
        showSnack(context, "Notification marked as read");

        final index = _notifications.indexWhere((n) => n.id == notificationId);

        if (index != -1 && !_notifications[index].isRead) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("❌ PROVIDER SINGLE READ ERROR: $e");
    }
  }

  void showSnack(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black87,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

extension NotificationCopy on NotificationModel {
  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      details: details,
    );
  }
}

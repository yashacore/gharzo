import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A robust service to handle both Foreground and Background notifications in Flutter.
///
/// Requirements:
/// 1. firebase_messaging: ^14.0.0 (or latest)
/// 2. flutter_local_notifications: ^17.0.0 (or latest)
class NotificationService {
  // Private constructor for singleton pattern
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory   NotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// Initialize the notification service
  Future<void> initialize() async {
    // 1. Request Permissions (Essential for iOS and Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    // 2. Setup Local Notifications (Needed for Foreground display)
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Fixed: Named parameter 'onDidReceiveNotificationResponse' and positional 'initSettings'
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onTapNotification,
    );

    // 3. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 4. Handle Background/Terminated Taps
    // This handles the case where the app was terminated and opened via notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageInteraction(initialMessage);
    }

    // This handles the case where the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageInteraction);
  }

  /// Get the device token for sending targeted notifications via API
  Future<String?> getDeviceToken() async {
    return await _messaging.getToken();
  }

  /// Manually show a notification when the app is in the foreground
  void _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // Fixed: The 'show' method uses positional arguments in a specific order:
      // id, title, body, notificationDetails, {payload}
      await _localNotifications.show(
        id: notification.hashCode, // Unique ID
        title: notification.title,    // Title
        body: notification.body,     // Body
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Callback when a user taps a local notification
  void _onTapNotification(NotificationResponse response) {
    if (response.payload != null) {
      final Map<String, dynamic> data = jsonDecode(response.payload!);
      _processNavigation(data);
    }
  }

  /// Callback when a user taps a Firebase notification (Background/Terminated)
  void _handleMessageInteraction(RemoteMessage message) {
    _processNavigation(message.data);
  }

  /// Logic to navigate or perform actions based on notification data
  void _processNavigation(Map<String, dynamic> data) {
    print("Notification Data: $data");
    // Example: if (data['type'] == 'chat') { navigateToChat(data['id']); }
  }
}

/// TOP-LEVEL FUNCTION for Background Messaging
/// This MUST be a top-level function (outside any class) to work in the background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need to use Firebase services here, call Firebase.initializeApp() first.
  print("Handling a background message: ${message.messageId}");
}


///TODO Home page provider => save-token Api
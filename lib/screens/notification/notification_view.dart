import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'notification_provider.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: CommonWidget.gradientAppBar(
          title: 'Notifications',
          centerTitle: false,
          onPressed: () => navigatorKey.currentState?.pop(),
          actions: [
            if (provider.notifications.any((n) => !n.isRead))
              TextButton(
                onPressed: () => provider.markAllAsRead(),
                child: Text(
                  "Mark all as read",
                  style: TextStyle(
                    color: AppThemeColors().textWhite,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        body: provider.notifications.isEmpty
            ? const Center(child: Text("No notifications yet"))
            : ListView.separated(
                itemCount: provider.notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = provider.notifications[index];

                  return Container(
                    color: notification.isRead
                        ? Colors.transparent
                        : Colors.blue.withOpacity(0.05),
                    child: ListTile(
                      onTap: () => provider.markAsRead(notification.id),
                      leading: CircleAvatar(
                        backgroundColor: notification.isRead
                            ? Colors.grey[200]
                            : Colors.blue[100],
                        child: Icon(
                          notification.isRead
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: notification.isRead
                              ? Colors.grey
                              : AppThemeColors().primary,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                           SizedBox(height: 4),
                          Text(
                            "${notification.timestamp.hour}:${notification.timestamp.minute}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: !notification.isRead
                          ? Icon(
                              Icons.circle,
                              color: AppThemeColors().primary,
                              size: 12,
                            )
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileWidget {

  /// Circular Icon Button
 static Widget circularIconButton(IconData icon, {Color iconColor = Colors.black, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  /// Stat Item for Property Details Grid
  static Widget propertyStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.blue),
            SizedBox(width: 5),
            Flexible(
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Agent Info Card
 static Widget agentInfoCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=agent_esther'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Esther Howard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Real Estate Agent', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          agentActionIcon(Icons.phone_outlined, Colors.blue),
          SizedBox(width: 8),
          agentActionIcon(Icons.message_outlined, Colors.blue),
        ],
      ),
    );
  }

  /// Agent Action Icon (Phone / Message)
  static Widget agentActionIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

}
import 'package:flutter/material.dart';

class NotificationPanel extends StatelessWidget {
  final List<String> notifications;

  const NotificationPanel({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // altura do painel
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Notificações',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text("Nenhuma notificação"))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.notification_important,
                          color: Colors.white,
                        ),
                        title: Text(notifications[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

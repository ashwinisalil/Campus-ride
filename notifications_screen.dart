import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/glass_container.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final notifications = appState.notificationsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No new notifications.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: GlassContainer(
                    borderRadius: 18,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(notif.category).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(notif.category),
                            color: _getCategoryColor(notif.category),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notif.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    notif.timestamp,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.message,
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Delay':
        return Colors.orange;
      case 'Alert':
        return Colors.redAccent;
      case 'Announcement':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Delay':
        return Icons.timer_rounded;
      case 'Alert':
        return Icons.warning_amber_rounded;
      case 'Announcement':
        return Icons.campaign_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }
}

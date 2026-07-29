class AppNotification {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final String category; // Delay, Alert, Announcement, System
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map, String id) {
    return AppNotification(
      id: id,
      title: map['title'] ?? 'Notice',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? 'Just now',
      category: map['category'] ?? 'System',
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'category': category,
      'isRead': isRead,
    };
  }
}

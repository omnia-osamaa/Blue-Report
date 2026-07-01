class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final String createdAt;
  final String? timeAgo;
  final String? color;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.timeAgo,
    this.color,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    String? createdAt,
    String? timeAgo,
    String? color,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      timeAgo: timeAgo ?? this.timeAgo,
      color: color ?? this.color,
    );
  }
}

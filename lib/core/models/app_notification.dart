/// Notification categories for Mafqood real-time alerts.
enum NotificationType { match, message, reportApproved, system }

/// Data model for an in-app notification.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.titleEn,
    required this.body,
    required this.bodyEn,
    required this.type,
    this.relatedId,
    this.isRead = false,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String titleEn;
  final String body;
  final String bodyEn;
  final NotificationType type;
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;

  String localizedTitle(bool isArabic) => isArabic ? title : titleEn;
  String localizedBody(bool isArabic) => isArabic ? body : bodyEn;

  factory AppNotification.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AppNotification(
      id: (map['id'] as String?) ?? docId ?? '',
      userId: (map['userId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      titleEn: (map['titleEn'] as String?) ?? (map['title'] as String?) ?? '',
      body: (map['body'] as String?) ?? '',
      bodyEn: (map['bodyEn'] as String?) ?? (map['body'] as String?) ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.system,
      ),
      relatedId: map['relatedId'] as String?,
      isRead: (map['isRead'] as bool?) ?? false,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'titleEn': titleEn,
      'body': body,
      'bodyEn': bodyEn,
      'type': type.name,
      'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? titleEn,
    String? body,
    String? bodyEn,
    NotificationType? type,
    String? relatedId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      body: body ?? this.body,
      bodyEn: bodyEn ?? this.bodyEn,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}

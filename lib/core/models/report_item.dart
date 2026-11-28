/// Type of report: lost item or found item.
enum ReportType { lost, found }

/// Supported item categories in Mafqood.
enum ItemCategory { wallet, phone, keys, bag, cards, other }

/// Lifecycle status of a report.
enum ReportStatus { searching, matched, found, pendingApproval, rejected }

/// Data model for a lost or found item report.
class ReportItem {
  const ReportItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.color,
    required this.location,
    required this.date,
    this.imageUrl,
    this.status = ReportStatus.searching,
    this.isApproved = true,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final ReportType type;
  final ItemCategory category;
  final String title;
  final String description;
  final String color;
  final String location;
  final DateTime date;
  final String? imageUrl;
  final ReportStatus status;
  final bool isApproved;
  final DateTime createdAt;

  factory ReportItem.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ReportItem(
      id: (map['id'] as String?) ?? docId ?? '',
      userId: (map['userId'] as String?) ?? '',
      userName: (map['userName'] as String?) ?? '',
      type: ReportType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ReportType.lost,
      ),
      category: ItemCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ItemCategory.other,
      ),
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      color: (map['color'] as String?) ?? '',
      location: (map['location'] as String?) ?? '',
      date: _parseDate(map['date']),
      imageUrl: map['imageUrl'] as String?,
      status: ReportStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReportStatus.searching,
      ),
      isApproved: (map['isApproved'] as bool?) ?? true,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'type': type.name,
      'category': category.name,
      'title': title,
      'description': description,
      'color': color,
      'location': location,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'status': status.name,
      'isApproved': isApproved,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ReportItem copyWith({
    String? id,
    String? userId,
    String? userName,
    ReportType? type,
    ItemCategory? category,
    String? title,
    String? description,
    String? color,
    String? location,
    DateTime? date,
    String? imageUrl,
    ReportStatus? status,
    bool? isApproved,
    DateTime? createdAt,
  }) {
    return ReportItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}

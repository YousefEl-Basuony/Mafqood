/// Confirmation status for a smart match between a lost and found report.
enum MatchStatus { pending, confirmed, dismissed }

/// Represents a smart match suggestion between a lost report and a found report.
class MatchResult {
  const MatchResult({
    required this.id,
    required this.lostReportId,
    required this.foundReportId,
    required this.lostItemTitle,
    required this.foundItemTitle,
    required this.lostUserId,
    required this.foundUserId,
    required this.matchPercentage,
    this.status = MatchStatus.pending,
    this.matchedAttributes = const [],
    required this.createdAt,
  });

  final String id;
  final String lostReportId;
  final String foundReportId;
  final String lostItemTitle;
  final String foundItemTitle;
  final String lostUserId;
  final String foundUserId;
  final int matchPercentage;
  final MatchStatus status;
  final List<String> matchedAttributes;
  final DateTime createdAt;

  factory MatchResult.fromMap(Map<String, dynamic> map, {String? docId}) {
    return MatchResult(
      id: (map['id'] as String?) ?? docId ?? '',
      lostReportId: (map['lostReportId'] as String?) ?? '',
      foundReportId: (map['foundReportId'] as String?) ?? '',
      lostItemTitle: (map['lostItemTitle'] as String?) ?? '',
      foundItemTitle: (map['foundItemTitle'] as String?) ?? '',
      lostUserId: (map['lostUserId'] as String?) ?? '',
      foundUserId: (map['foundUserId'] as String?) ?? '',
      matchPercentage: (map['matchPercentage'] as num?)?.toInt() ?? 0,
      status: MatchStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MatchStatus.pending,
      ),
      matchedAttributes: List<String>.from(
        (map['matchedAttributes'] as List<dynamic>?) ?? const [],
      ),
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lostReportId': lostReportId,
      'foundReportId': foundReportId,
      'lostItemTitle': lostItemTitle,
      'foundItemTitle': foundItemTitle,
      'lostUserId': lostUserId,
      'foundUserId': foundUserId,
      'matchPercentage': matchPercentage,
      'status': status.name,
      'matchedAttributes': matchedAttributes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MatchResult copyWith({
    String? id,
    String? lostReportId,
    String? foundReportId,
    String? lostItemTitle,
    String? foundItemTitle,
    String? lostUserId,
    String? foundUserId,
    int? matchPercentage,
    MatchStatus? status,
    List<String>? matchedAttributes,
    DateTime? createdAt,
  }) {
    return MatchResult(
      id: id ?? this.id,
      lostReportId: lostReportId ?? this.lostReportId,
      foundReportId: foundReportId ?? this.foundReportId,
      lostItemTitle: lostItemTitle ?? this.lostItemTitle,
      foundItemTitle: foundItemTitle ?? this.foundItemTitle,
      lostUserId: lostUserId ?? this.lostUserId,
      foundUserId: foundUserId ?? this.foundUserId,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      status: status ?? this.status,
      matchedAttributes: matchedAttributes ?? this.matchedAttributes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}

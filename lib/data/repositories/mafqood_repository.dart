import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/data/mock_data_provider.dart';
import '../../core/models/app_notification.dart';
import '../../core/models/chat_message.dart';
import '../../core/models/match_result.dart';
import '../../core/models/report_item.dart';

/// Repository contract for reports, smart matching, safe chat, and notifications.
abstract class MafqoodRepository {
  Stream<List<ReportItem>> watchReports();
  Stream<List<MatchResult>> watchMatches();
  Stream<List<ChatMessage>> watchMessages(String chatId);
  Stream<List<AppNotification>> watchNotifications(String userId);

  Future<ReportItem> createReport(ReportItem report);
  Future<void> approveReport(String reportId);
  Future<void> deleteReport(String reportId);
  Future<void> updateReportStatus(String reportId, ReportStatus status);
  Future<void> confirmMatch(String matchId);
  Future<void> sendMessage(ChatMessage message, {String? receiverUserId});
  Future<void> markNotificationRead(String notificationId);
}

/// In-memory real-time repository with Smart Matching and instant notifications.
class FakeMafqoodRepository implements MafqoodRepository {
  final List<ReportItem> _reports = List.of(MockDataProvider.initialReports);
  final List<MatchResult> _matches = List.of(MockDataProvider.initialMatches);
  final List<ChatMessage> _messages = List.of(MockDataProvider.initialMessages);
  final List<AppNotification> _notifications =
      List.of(MockDataProvider.initialNotifications);

  final _reportsController = StreamController<List<ReportItem>>.broadcast();
  final _matchesController = StreamController<List<MatchResult>>.broadcast();
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  final _notificationsController =
      StreamController<List<AppNotification>>.broadcast();

  @override
  Stream<List<ReportItem>> watchReports() async* {
    yield List.unmodifiable(_reports);
    yield* _reportsController.stream;
  }

  @override
  Stream<List<MatchResult>> watchMatches() async* {
    yield List.unmodifiable(_matches);
    yield* _matchesController.stream;
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String chatId) async* {
    yield _messages.where((m) => m.chatId == chatId).toList();
    yield* _messagesController.stream.map(
      (all) => all.where((m) => m.chatId == chatId).toList(),
    );
  }

  @override
  Stream<List<AppNotification>> watchNotifications(String userId) async* {
    yield _filterNotifications(userId);
    yield* _notificationsController.stream.map((_) => _filterNotifications(userId));
  }

  List<AppNotification> _filterNotifications(String userId) {
    final list = _notifications
        .where((n) => n.userId == userId || n.userId == 'all')
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<ReportItem> createReport(ReportItem report) async {
    final created = report.copyWith(
      id: report.id.isEmpty
          ? 'rep_${DateTime.now().millisecondsSinceEpoch}'
          : report.id,
    );
    _reports.insert(0, created);
    _runSmartMatching(created);
    _reportsController.add(List.unmodifiable(_reports));
    return created;
  }

  void _runSmartMatching(ReportItem newReport) {
    final oppositeType =
        newReport.type == ReportType.lost ? ReportType.found : ReportType.lost;
    final candidates = _reports.where(
      (r) => r.id != newReport.id && r.type == oppositeType && r.isApproved,
    );

    for (final candidate in candidates) {
      int score = 0;
      final attrs = <String>[];

      if (candidate.category == newReport.category) {
        score += 45;
        attrs.add('الفئة');
      }
      if (candidate.color.trim().isNotEmpty &&
          newReport.color.trim().isNotEmpty &&
          (candidate.color.contains(newReport.color) ||
              newReport.color.contains(candidate.color))) {
        score += 25;
        attrs.add('اللون: ${newReport.color}');
      }
      if (_locationOverlap(candidate.location, newReport.location)) {
        score += 22;
        attrs.add('الموقع القريب');
      }
      if (_keywordOverlap(candidate.title, newReport.title)) {
        score += 8;
        attrs.add('تشابه الوصف');
      }

      if (score >= 60) {
        final clamped = score.clamp(60, 99);
        final lost = newReport.type == ReportType.lost ? newReport : candidate;
        final found = newReport.type == ReportType.found ? newReport : candidate;
        final match = MatchResult(
          id: 'match_${DateTime.now().millisecondsSinceEpoch}_${candidate.id}',
          lostReportId: lost.id,
          foundReportId: found.id,
          lostItemTitle: lost.title,
          foundItemTitle: found.title,
          lostUserId: lost.userId,
          foundUserId: found.userId,
          matchPercentage: clamped,
          matchedAttributes: attrs,
          createdAt: DateTime.now(),
        );
        _matches.insert(0, match);
        _matchesController.add(List.unmodifiable(_matches));

        for (final targetUserId in {lost.userId, found.userId}) {
          _notifications.insert(
            0,
            AppNotification(
              id: 'notif_${DateTime.now().millisecondsSinceEpoch}_$targetUserId',
              userId: targetUserId,
              title: 'تطابق ذكي بنسبة $clamped%!',
              titleEn: '$clamped% Smart Match Found!',
              body: 'تم العثور على بلاغ مشابه لـ "${newReport.title}".',
              bodyEn: 'A matching report was found for "${newReport.title}".',
              type: NotificationType.match,
              relatedId: match.id,
              createdAt: DateTime.now(),
            ),
          );
        }
        _notificationsController.add(List.unmodifiable(_notifications));
      }
    }
  }

  bool _locationOverlap(String a, String b) {
    final wordsA = a.split(RegExp(r'[\s\-،,]+')).where((w) => w.length > 2);
    return wordsA.any((w) => b.contains(w));
  }

  bool _keywordOverlap(String a, String b) {
    final wordsA = a.split(RegExp(r'\s+')).where((w) => w.length > 2);
    return wordsA.any((w) => b.contains(w));
  }

  @override
  Future<void> approveReport(String reportId) async {
    final idx = _reports.indexWhere((r) => r.id == reportId);
    if (idx < 0) return;
    final updated = _reports[idx].copyWith(
      isApproved: true,
      status: ReportStatus.searching,
    );
    _reports[idx] = updated;
    _reportsController.add(List.unmodifiable(_reports));

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif_app_${DateTime.now().millisecondsSinceEpoch}',
        userId: updated.userId,
        title: 'تمت الموافقة على بلاغك',
        titleEn: 'Your report was approved',
        body: 'تم نشر "${updated.title}" بنجاح.',
        bodyEn: '"${updated.title}" is now published.',
        type: NotificationType.reportApproved,
        relatedId: updated.id,
        createdAt: DateTime.now(),
      ),
    );
    _notificationsController.add(List.unmodifiable(_notifications));
  }

  @override
  Future<void> deleteReport(String reportId) async {
    _reports.removeWhere((r) => r.id == reportId);
    _reportsController.add(List.unmodifiable(_reports));
  }

  @override
  Future<void> updateReportStatus(String reportId, ReportStatus status) async {
    final idx = _reports.indexWhere((r) => r.id == reportId);
    if (idx < 0) return;
    _reports[idx] = _reports[idx].copyWith(status: status);
    _reportsController.add(List.unmodifiable(_reports));
  }

  @override
  Future<void> confirmMatch(String matchId) async {
    final idx = _matches.indexWhere((m) => m.id == matchId);
    if (idx < 0) return;
    final match = _matches[idx].copyWith(status: MatchStatus.confirmed);
    _matches[idx] = match;
    _matchesController.add(List.unmodifiable(_matches));
    await updateReportStatus(match.lostReportId, ReportStatus.found);
    await updateReportStatus(match.foundReportId, ReportStatus.found);
  }

  @override
  Future<void> sendMessage(
    ChatMessage message, {
    String? receiverUserId,
  }) async {
    _messages.add(message);
    _messagesController.add(List.unmodifiable(_messages));

    if (receiverUserId != null && receiverUserId.isNotEmpty) {
      _notifications.insert(
        0,
        AppNotification(
          id: 'notif_msg_${DateTime.now().millisecondsSinceEpoch}',
          userId: receiverUserId,
          title: 'رسالة جديدة من ${message.senderName}',
          titleEn: 'New message from ${message.senderName}',
          body: message.text,
          bodyEn: message.text,
          type: NotificationType.message,
          relatedId: message.chatId,
          createdAt: DateTime.now(),
        ),
      );
      _notificationsController.add(List.unmodifiable(_notifications));
    }
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    final idx = _notifications.indexWhere((n) => n.id == notificationId);
    if (idx < 0) return;
    _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    _notificationsController.add(List.unmodifiable(_notifications));
  }
}

/// Production Firestore repository with real-time Streams and Smart Matching.
class FirebaseMafqoodRepository implements MafqoodRepository {
  FirebaseMafqoodRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<ReportItem>> watchReports() {
    return _firestore
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ReportItem.fromMap(doc.data(), docId: doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<MatchResult>> watchMatches() {
    return _firestore
        .collection('matches')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MatchResult.fromMap(doc.data(), docId: doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ChatMessage.fromMap(doc.data(), docId: doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AppNotification.fromMap(doc.data(), docId: doc.id))
              .toList(),
        );
  }

  @override
  Future<ReportItem> createReport(ReportItem report) async {
    final docRef = _firestore.collection('reports').doc();
    final created = report.copyWith(id: docRef.id);
    await docRef.set(created.toMap());
    await _runFirestoreSmartMatching(created);
    return created;
  }

  Future<void> _runFirestoreSmartMatching(ReportItem newReport) async {
    final opposite =
        newReport.type == ReportType.lost ? ReportType.found : ReportType.lost;
    final snap = await _firestore
        .collection('reports')
        .where('type', isEqualTo: opposite.name)
        .where('category', isEqualTo: newReport.category.name)
        .where('isApproved', isEqualTo: true)
        .get();

    for (final doc in snap.docs) {
      final candidate = ReportItem.fromMap(doc.data(), docId: doc.id);
      int score = 50;
      if (candidate.color == newReport.color) score += 25;
      if (candidate.location.contains(newReport.location) ||
          newReport.location.contains(candidate.location)) {
        score += 20;
      }
      if (score >= 65) {
        final matchRef = _firestore.collection('matches').doc();
        final lost = newReport.type == ReportType.lost ? newReport : candidate;
        final found = newReport.type == ReportType.found ? newReport : candidate;
        final match = MatchResult(
          id: matchRef.id,
          lostReportId: lost.id,
          foundReportId: found.id,
          lostItemTitle: lost.title,
          foundItemTitle: found.title,
          lostUserId: lost.userId,
          foundUserId: found.userId,
          matchPercentage: score.clamp(65, 99),
          matchedAttributes: ['الفئة', 'اللون', 'الموقع'],
          createdAt: DateTime.now(),
        );
        await matchRef.set(match.toMap());
        for (final uid in {lost.userId, found.userId}) {
          final nRef = _firestore.collection('notifications').doc();
          await nRef.set(
            AppNotification(
              id: nRef.id,
              userId: uid,
              title: 'تطابق ذكي بنسبة ${match.matchPercentage}%!',
              titleEn: '${match.matchPercentage}% Smart Match!',
              body: 'يوجد تطابق جديد لبلاغ "${newReport.title}".',
              bodyEn: 'A new match was found for "${newReport.title}".',
              type: NotificationType.match,
              relatedId: match.id,
              createdAt: DateTime.now(),
            ).toMap(),
          );
        }
      }
    }
  }

  @override
  Future<void> approveReport(String reportId) async {
    await _firestore.collection('reports').doc(reportId).update({
      'isApproved': true,
      'status': ReportStatus.searching.name,
    });
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _firestore.collection('reports').doc(reportId).delete();
  }

  @override
  Future<void> updateReportStatus(String reportId, ReportStatus status) async {
    await _firestore
        .collection('reports')
        .doc(reportId)
        .update({'status': status.name});
  }

  @override
  Future<void> confirmMatch(String matchId) async {
    await _firestore
        .collection('matches')
        .doc(matchId)
        .update({'status': MatchStatus.confirmed.name});
  }

  @override
  Future<void> sendMessage(
    ChatMessage message, {
    String? receiverUserId,
  }) async {
    final ref = _firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc();
    await ref.set(message.copyWith(id: ref.id).toMap());
    if (receiverUserId != null && receiverUserId.isNotEmpty) {
      final nRef = _firestore.collection('notifications').doc();
      await nRef.set(
        AppNotification(
          id: nRef.id,
          userId: receiverUserId,
          title: 'رسالة جديدة من ${message.senderName}',
          titleEn: 'New message from ${message.senderName}',
          body: message.text,
          bodyEn: message.text,
          type: NotificationType.message,
          relatedId: message.chatId,
          createdAt: DateTime.now(),
        ).toMap(),
      );
    }
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}

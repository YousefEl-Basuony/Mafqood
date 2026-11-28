/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: SafeChatScreen
///
/// TODO (Yousef):
/// - صمم واجهة المحادثة الآمنة (فقاعات رسائل بلونين، حالة الاتصال، حقل إرسال).
/// - اربطها بـ `MafqoodRepository.watchMessages(chatId)` و `sendMessage(...)`.
library;

import 'package:flutter/material.dart';

class SafeChatScreen extends StatelessWidget {
  const SafeChatScreen({
    super.key,
    required this.chatId,
    required this.peerName,
    required this.peerUserId,
    required this.itemTitle,
  });

  final String chatId;
  final String peerName;
  final String peerUserId;
  final String itemTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(peerName)),
      body: Center(
        child: Text('SafeChatScreen ($chatId) — TODO: Yousef UI'),
      ),
    );
  }
}

/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: SafeChatScreen — محادثة آمنة بفقاعات رسائل بلونين وحالة الاتصال في الوقت الفعلي.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/chat_message.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../ui/widgets/app_screen_container.dart';

class SafeChatScreen extends StatefulWidget {
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
  State<SafeChatScreen> createState() => _SafeChatScreenState();
}

class _SafeChatScreenState extends State<SafeChatScreen> {
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();

    final auth = context.read<AuthRepository>();
    final repo = context.read<MafqoodRepository>();
    final user = auth.currentUser;

    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: widget.chatId,
      senderId: user?.uid ?? 'guest',
      senderName: user?.name ?? 'مستخدم',
      text: text,
      timestamp: DateTime.now(),
    );

    await repo.sendMessage(msg, receiverUserId: widget.peerUserId);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final repo = context.watch<MafqoodRepository>();
    final currentUid = context.watch<AuthRepository>().currentUser?.uid ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScreenContainer(
      padding: const EdgeInsets.all(12),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.peerName, style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.foundGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppStrings.tr(
                    isArabic,
                    'متصل الآن • شات آمن',
                    'Online • Safe Chat',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.turquoise.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${AppStrings.tr(isArabic, "بخصوص:", "Regarding:")} ${widget.itemTitle}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.turquoiseDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: repo.watchMessages(widget.chatId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.tr(
                        isArabic,
                        'ابدأ المحادثة الآمنة دون مشاركة بياناتك الحساسة.',
                        'Start a safe conversation without sharing private info.',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUid;
                    final bubbleColor = isMe
                        ? AppColors.turquoiseDark
                        : (isDark
                            ? AppColors.navyCard
                            : AppColors.lightSurfaceVariant);
                    final textColor = isMe
                        ? Colors.white
                        : (isDark
                            ? AppColors.textLightPrimary
                            : AppColors.textDarkPrimary);

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.74,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(color: textColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: AppStrings.tr(
                      isArabic,
                      'اكتب رسالتك هنا...',
                      'Type your message...',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.turquoiseDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: NotificationsScreen — مركز الإشعارات: تنبيهات ملونة مصنفة "اليوم / أمس".
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/app_notification.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final repo = context.watch<MafqoodRepository>();
    final uid = context.watch<AuthRepository>().currentUser?.uid ?? '';

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'الإشعارات', 'Notifications')),
      ),
      child: StreamBuilder<List<AppNotification>>(
        stream: repo.watchNotifications(uid),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: AppCard(
                child: Text(
                  AppStrings.tr(
                    isArabic,
                    'لا توجد إشعارات جديدة حالياً.',
                    'No notifications yet.',
                  ),
                ),
              ),
            );
          }

          final now = DateTime.now();
          final today = items.where((n) => _isSameDay(n.createdAt, now)).toList();
          final earlier = items.where((n) => !_isSameDay(n.createdAt, now)).toList();

          return ListView(
            children: [
              if (today.isNotEmpty) ...[
                _SectionHeader(
                  title: AppStrings.tr(isArabic, 'اليوم', 'Today'),
                ),
                ...today.map((n) => _NotificationTile(n: n, isArabic: isArabic)),
              ],
              if (earlier.isNotEmpty) ...[
                const SizedBox(height: 12),
                _SectionHeader(
                  title: AppStrings.tr(isArabic, 'أمس / سابقاً', 'Yesterday / Earlier'),
                ),
                ...earlier.map((n) => _NotificationTile(n: n, isArabic: isArabic)),
              ],
            ],
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.turquoiseDark,
            ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.n, required this.isArabic});

  final AppNotification n;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MafqoodRepository>();
    final color = switch (n.type) {
      NotificationType.match => AppColors.turquoiseDark,
      NotificationType.message => AppColors.infoBlue,
      NotificationType.reportApproved => AppColors.foundGreen,
      NotificationType.system => AppColors.warningAmber,
    };

    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      borderColor: n.isRead ? null : color.withValues(alpha: 0.55),
      onTap: () => repo.markNotificationRead(n.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notifications_active_outlined, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.localizedTitle(isArabic),
                  style: TextStyle(
                    fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  n.localizedBody(isArabic),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (!n.isRead)
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

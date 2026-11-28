/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: ItemDetailsScreen — تفاصيل العنصر كاملة مع زر فتح الشات الآمن.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/report_item.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.report});

  final ReportItem report;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final isLost = report.type == ReportType.lost;
    final badgeColor = isLost ? AppColors.lostRed : AppColors.foundGreen;

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'تفاصيل البلاغ', 'Report Details')),
      ),
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 220,
              color: AppColors.turquoise.withValues(alpha: 0.14),
              child: report.imageUrl != null && report.imageUrl!.isNotEmpty
                  ? Image.network(
                      report.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: AppColors.turquoiseDark,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 56,
                        color: AppColors.turquoiseDark,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        AppStrings.reportTypeLabel(report.type, isArabic),
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        AppStrings.categoryLabel(report.category, isArabic),
                      ),
                    ),
                    Chip(
                      label: Text(AppStrings.statusLabel(report.status, isArabic)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  report.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Divider(height: 24),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: AppStrings.tr(isArabic, 'المكان', 'Location'),
                  value: report.location,
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.palette_outlined,
                  label: AppStrings.tr(isArabic, 'اللون', 'Color'),
                  value: report.color,
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: AppStrings.tr(isArabic, 'التاريخ', 'Date'),
                  value:
                      '${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.person_outline,
                  label: AppStrings.tr(isArabic, 'المُبلغ', 'Reporter'),
                  value: report.userName,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.safeChat,
                arguments: {
                  'chatId': 'chat_${report.id}',
                  'peerName': report.userName,
                  'peerUserId': report.userId,
                  'itemTitle': report.title,
                },
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text(
              AppStrings.tr(
                isArabic,
                isLost ? 'تواصل مع المالك' : 'تواصل مع الواجد',
                isLost ? 'Contact Owner' : 'Contact Finder',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.turquoiseDark),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}

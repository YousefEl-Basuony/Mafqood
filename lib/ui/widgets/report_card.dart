import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/report_item.dart';
import '../../core/theme/app_colors.dart';
import 'app_card.dart';

/// Reusable card displaying a lost or found report summary.
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.isArabic,
    required this.onTap,
  });

  final ReportItem report;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLost = report.type == ReportType.lost;
    final badgeColor = isLost ? AppColors.lostRed : AppColors.foundGreen;

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 82,
              height: 82,
              color: AppColors.turquoise.withValues(alpha: 0.12),
              child: report.imageUrl != null && report.imageUrl!.isNotEmpty
                  ? Image.network(
                      report.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        _categoryIcon(report.category),
                        size: 34,
                        color: AppColors.turquoiseDark,
                      ),
                    )
                  : Icon(
                      _categoryIcon(report.category),
                      size: 34,
                      color: AppColors.turquoiseDark,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppStrings.reportTypeLabel(report.type, isArabic),
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.turquoise.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppStrings.categoryLabel(report.category, isArabic),
                        style: const TextStyle(
                          color: AppColors.turquoiseDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  report.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.turquoiseDark,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        report.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(ItemCategory category) {
    switch (category) {
      case ItemCategory.wallet:
        return Icons.account_balance_wallet_outlined;
      case ItemCategory.phone:
        return Icons.smartphone_outlined;
      case ItemCategory.keys:
        return Icons.vpn_key_outlined;
      case ItemCategory.bag:
        return Icons.backpack_outlined;
      case ItemCategory.cards:
        return Icons.credit_card_outlined;
      case ItemCategory.other:
        return Icons.inventory_2_outlined;
    }
  }
}

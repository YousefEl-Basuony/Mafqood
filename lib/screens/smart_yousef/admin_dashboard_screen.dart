/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: AdminDashboardScreen — لوحة تحكم الإدارة: إحصائيات سريعة + مراجعة البلاغات المعلقة.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/report_item.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final repo = context.watch<MafqoodRepository>();

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(
          AppStrings.tr(isArabic, 'لوحة تحكم الإدارة', 'Admin Dashboard'),
        ),
      ),
      child: StreamBuilder<List<ReportItem>>(
        stream: repo.watchReports(),
        builder: (context, snapshot) {
          final all = snapshot.data ?? [];
          final activeCount =
              all.where((r) => r.isApproved && r.status != ReportStatus.found).length;
          final resolvedCount =
              all.where((r) => r.status == ReportStatus.found).length;
          final pending = all.where((r) => !r.isApproved).toList();

          return ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: AppStrings.tr(isArabic, 'بلاغات نشطة', 'Active'),
                      value: '$activeCount',
                      color: AppColors.turquoiseDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: AppStrings.tr(isArabic, 'تم العثور', 'Resolved'),
                      value: '$resolvedCount',
                      color: AppColors.foundGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: AppStrings.tr(isArabic, 'معلقة', 'Pending'),
                      value: '${pending.length}',
                      color: AppColors.warningAmber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                AppStrings.tr(
                  isArabic,
                  'البلاغات المعلقة للمراجعة',
                  'Pending Reports for Review',
                ),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              if (pending.isEmpty)
                AppCard(
                  child: Text(
                    AppStrings.tr(
                      isArabic,
                      'لا توجد بلاغات معلقة حالياً.',
                      'No pending reports right now.',
                    ),
                  ),
                )
              else
                ...pending.map(
                  (r) => AppCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${r.userName} • ${r.location}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => repo.approveReport(r.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.foundGreen,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.check_rounded),
                                label: Text(
                                  AppStrings.tr(isArabic, 'موافقة', 'Approve'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => repo.deleteReport(r.id),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.lostRed,
                                  side: const BorderSide(color: AppColors.lostRed),
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: const Icon(Icons.delete_outline_rounded),
                                label: Text(
                                  AppStrings.tr(isArabic, 'حذف', 'Delete'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

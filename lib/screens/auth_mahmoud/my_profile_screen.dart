/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: MyProfileScreen — ملفي الشخصي، بلاغاتي النشطة، الإعدادات، وتسجيل الخروج.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/report_item.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final auth = context.watch<AuthRepository>();
    final repo = context.watch<MafqoodRepository>();
    final user = auth.currentUser;

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'ملفي الشخصي', 'My Profile')),
        actions: [
          IconButton(
            tooltip: AppStrings.tr(isArabic, 'الإعدادات', 'Settings'),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      child: ListView(
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.turquoise.withValues(alpha: 0.18),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: AppColors.turquoiseDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? AppStrings.tr(isArabic, 'زائر', 'Guest'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        user?.phone ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (user?.isAdmin == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.turquoise.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      AppStrings.tr(isArabic, 'أدمن', 'Admin'),
                      style: const TextStyle(
                        color: AppColors.turquoiseDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (user?.isAdmin == true) ...[
            AppCard(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.adminDashboard),
              borderColor: AppColors.turquoiseDark.withValues(alpha: 0.5),
              child: Row(
                children: [
                  const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: AppColors.turquoiseDark,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppStrings.tr(
                        isArabic,
                        'لوحة تحكم الإدارة',
                        'Admin Dashboard',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            AppStrings.tr(isArabic, 'بلاغاتي النشطة', 'My Active Reports'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<ReportItem>>(
            stream: repo.watchReports(),
            builder: (context, snapshot) {
              final all = snapshot.data ?? [];
              final mine = user == null
                  ? all
                  : all.where((r) => r.userId == user.uid).toList();
              if (mine.isEmpty) {
                return AppCard(
                  child: Text(
                    AppStrings.tr(
                      isArabic,
                      'لا توجد بلاغات مسجلة باسمك حالياً.',
                      'No reports submitted under your account yet.',
                    ),
                  ),
                );
              }
              return Column(
                children: mine.map((report) {
                  final resolved = report.status == ReportStatus.found;
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.itemDetails,
                      arguments: report,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.title,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                report.location,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (resolved
                                    ? AppColors.foundGreen
                                    : AppColors.warningAmber)
                                .withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            AppStrings.statusLabel(report.status, isArabic),
                            style: TextStyle(
                              color: resolved
                                  ? AppColors.foundGreen
                                  : AppColors.warningAmber,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await auth.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (_) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.lostRed,
              side: const BorderSide(color: AppColors.lostRed),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: Text(AppStrings.tr(isArabic, 'تسجيل الخروج', 'Sign Out')),
          ),
        ],
      ),
    );
  }
}

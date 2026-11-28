/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: SmartMatchesScreen — التطابقات الذكية مع نسبة التطابق وزر التأكيد والمراسلة.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/match_result.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class SmartMatchesScreen extends StatelessWidget {
  const SmartMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final repo = context.watch<MafqoodRepository>();
    final currentUid = context.watch<AuthRepository>().currentUser?.uid ?? '';

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'التطابقات الذكية', 'Smart Matches')),
      ),
      child: StreamBuilder<List<MatchResult>>(
        stream: repo.watchMatches(),
        builder: (context, snapshot) {
          final matches = snapshot.data ?? [];
          if (matches.isEmpty) {
            return Center(
              child: AppCard(
                child: Text(
                  AppStrings.tr(
                    isArabic,
                    'لا توجد تطابقات ذكية حالياً. سيتم إشعارك فور وجود تطابق.',
                    'No smart matches yet. You will be notified automatically.',
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final m = matches[index];
              final isConfirmed = m.status == MatchStatus.confirmed;
              final peerId =
                  m.lostUserId == currentUid ? m.foundUserId : m.lostUserId;

              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                borderColor: AppColors.turquoise.withValues(alpha: 0.45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.turquoise.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${m.matchPercentage}% ${AppStrings.tr(isArabic, "تطابق", "Match")}',
                            style: const TextStyle(
                              color: AppColors.turquoiseDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (isConfirmed)
                          Chip(
                            label: Text(
                              AppStrings.tr(isArabic, 'تم التأكيد', 'Confirmed'),
                              style: const TextStyle(
                                color: AppColors.foundGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppStrings.tr(isArabic, "مفقود:", "Lost:")} ${m.lostItemTitle}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.tr(isArabic, "معثور عليه:", "Found:")} ${m.foundItemTitle}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (m.matchedAttributes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: m.matchedAttributes
                            .map((attr) => Chip(label: Text(attr)))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isConfirmed
                                ? null
                                : () async {
                                    await repo.confirmMatch(m.id);
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppStrings.tr(
                                            isArabic,
                                            'تم تأكيد التطابق وتحديث حالة البلاغ.',
                                            'Match confirmed and report resolved.',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.verified_outlined),
                            label: Text(
                              AppStrings.tr(isArabic, 'تأكيد', 'Confirm'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.safeChat,
                                arguments: {
                                  'chatId': '${m.lostReportId}_${m.foundReportId}',
                                  'peerName': AppStrings.tr(
                                    isArabic,
                                    'الطرف الآخر',
                                    'Match Partner',
                                  ),
                                  'peerUserId': peerId,
                                  'itemTitle': m.lostItemTitle,
                                },
                              );
                            },
                            icon: const Icon(Icons.chat_outlined),
                            label: Text(
                              AppStrings.tr(isArabic, 'المراسلة', 'Message'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

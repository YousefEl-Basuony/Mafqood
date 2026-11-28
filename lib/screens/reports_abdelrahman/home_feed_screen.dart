/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: HomeFeedScreen — الشاشة الرئيسية: شريط بحث، تبويب مفقود/معثور عليه، وأحدث البلاغات.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/app_notification.dart';
import '../../core/models/report_item.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';
import '../../ui/widgets/report_card.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  ReportType _selectedTab = ReportType.lost;
  String _quickQuery = '';

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final repo = context.watch<MafqoodRepository>();
    final uid = context.watch<AuthRepository>().currentUser?.uid ?? '';

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'مفقود', 'Mafqood')),
        actions: [
          StreamBuilder<List<AppNotification>>(
            stream: repo.watchNotifications(uid),
            builder: (context, snap) {
              final unread =
                  (snap.data ?? []).where((n) => !n.isRead).length;
              return IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.notifications),
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread'),
                  child: const Icon(Icons.notifications_outlined),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.reportItem),
        backgroundColor: AppColors.turquoiseDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(AppStrings.tr(isArabic, 'أبلغ الآن', 'Report Item')),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _quickQuery = v.trim()),
            decoration: InputDecoration(
              hintText: AppStrings.tr(
                isArabic,
                'ابحث عن محفظة، موبايل، مفاتيح، أو مكان...',
                'Search wallet, phone, keys, or location...',
              ),
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TabPill(
                  label: AppStrings.tr(isArabic, 'مفقودات (Lost)', 'Lost'),
                  selected: _selectedTab == ReportType.lost,
                  color: AppColors.lostRed,
                  onTap: () => setState(() => _selectedTab = ReportType.lost),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TabPill(
                  label: AppStrings.tr(isArabic, 'معثورات (Found)', 'Found'),
                  selected: _selectedTab == ReportType.found,
                  color: AppColors.foundGreen,
                  onTap: () => setState(() => _selectedTab = ReportType.found),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: StreamBuilder<List<ReportItem>>(
              stream: repo.watchReports(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reports = (snapshot.data ?? []).where((r) {
                  if (!r.isApproved || r.type != _selectedTab) return false;
                  if (_quickQuery.isEmpty) return true;
                  final q = _quickQuery.toLowerCase();
                  return r.title.toLowerCase().contains(q) ||
                      r.location.toLowerCase().contains(q) ||
                      r.description.toLowerCase().contains(q);
                }).toList();

                if (reports.isEmpty) {
                  return Center(
                    child: AppCard(
                      child: Text(
                        AppStrings.tr(
                          isArabic,
                          'لا توجد بلاغات مطابقة في هذا القسم حالياً.',
                          'No matching reports in this tab yet.',
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reports.length,
                  padding: const EdgeInsets.only(bottom: 72),
                  itemBuilder: (context, index) {
                    final item = reports[index];
                    return ReportCard(
                      report: item,
                      isArabic: isArabic,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.itemDetails,
                        arguments: item,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? color
                : Theme.of(context).dividerColor.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? color : null,
          ),
        ),
      ),
    );
  }
}

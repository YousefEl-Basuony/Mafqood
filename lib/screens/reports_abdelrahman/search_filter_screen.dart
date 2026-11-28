/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: SearchFilterScreen — بحث ذكي + Filter Chips أفقية للفئات ونتائج فورية.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/report_item.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';
import '../../ui/widgets/report_card.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String _query = '';
  ItemCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;
    final repo = context.watch<MafqoodRepository>();

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'البحث والفلترة', 'Search & Filter')),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: InputDecoration(
              hintText: AppStrings.tr(
                isArabic,
                'اكتب اسم الحاجة، اللون، أو المكان...',
                'Type item name, color, or location...',
              ),
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(AppStrings.tr(isArabic, 'الكل', 'All')),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  ),
                ),
                ...ItemCategory.values.map(
                  (cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(AppStrings.categoryLabel(cat, isArabic)),
                      selected: _selectedCategory == cat,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<ReportItem>>(
              stream: repo.watchReports(),
              builder: (context, snapshot) {
                final results = (snapshot.data ?? []).where((item) {
                  if (!item.isApproved) return false;
                  if (_selectedCategory != null &&
                      item.category != _selectedCategory) {
                    return false;
                  }
                  if (_query.isEmpty) return true;
                  final q = _query.toLowerCase();
                  return item.title.toLowerCase().contains(q) ||
                      item.description.toLowerCase().contains(q) ||
                      item.location.toLowerCase().contains(q) ||
                      item.color.toLowerCase().contains(q);
                }).toList();

                if (results.isEmpty) {
                  return Center(
                    child: AppCard(
                      child: Text(
                        AppStrings.tr(
                          isArabic,
                          'مفيش نتائج مطابقة للبحث ده.',
                          'No matching items found.',
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, idx) {
                    final report = results[idx];
                    return ReportCard(
                      report: report,
                      isArabic: isArabic,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.itemDetails,
                        arguments: report,
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

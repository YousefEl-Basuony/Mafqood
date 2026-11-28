/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: ReportItemScreen — نموذج الإبلاغ عن عنصر مفقود أو معثور عليه.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/models/report_item.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mafqood_repository.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController(
    text: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
  );

  ReportType _type = ReportType.lost;
  ItemCategory _category = ItemCategory.wallet;
  DateTime _selectedDate = DateTime.now();
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _colorCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final auth = context.read<AuthRepository>();
      final repo = context.read<MafqoodRepository>();
      final isArabic = context.read<AppSettingsManager>().isArabic;
      final user = auth.currentUser;

      final report = ReportItem(
        id: '',
        userId: user?.uid ?? 'guest',
        userName: user?.name ?? 'مستخدم مفقود',
        type: _type,
        category: _category,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        color: _colorCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        date: _selectedDate,
        imageUrl: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
        status: ReportStatus.searching,
        isApproved: true,
        createdAt: DateTime.now(),
      );

      await repo.createReport(report);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.tr(
              isArabic,
              'تم إرسال البلاغ وتشغيل المطابقة الذكية بنجاح!',
              'Report submitted & smart matching executed!',
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'إبلاغ عن عنصر', 'Report an Item')),
      ),
      child: SingleChildScrollView(
        child: AppCard(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<ReportType>(
                  segments: [
                    ButtonSegment(
                      value: ReportType.lost,
                      label: Text(AppStrings.tr(isArabic, 'فقدت عنصر', 'Lost Item')),
                      icon: const Icon(Icons.search_off_rounded),
                    ),
                    ButtonSegment(
                      value: ReportType.found,
                      label: Text(AppStrings.tr(isArabic, 'لقيت عنصر', 'Found Item')),
                      icon: const Icon(Icons.check_circle_outline),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ItemCategory>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'الفئة', 'Category'),
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: ItemCategory.values
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(AppStrings.categoryLabel(cat, isArabic)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _category = v);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'عنوان البلاغ', 'Report Title'),
                    hintText: AppStrings.tr(
                      isArabic,
                      'مثال: محفظة جلد بني',
                      'e.g. Brown leather wallet',
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? AppStrings.tr(isArabic, 'اكتب عنوان واضح', 'Enter a clear title')
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _colorCtrl,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'اللون', 'Color'),
                    prefixIcon: const Icon(Icons.palette_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppStrings.tr(isArabic, 'حدد اللون', 'Enter color')
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'المكان', 'Location'),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppStrings.tr(isArabic, 'حدد المكان', 'Enter location')
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'وصف إضافي', 'Description'),
                  ),
                  validator: (v) => (v == null || v.trim().length < 5)
                      ? AppStrings.tr(isArabic, 'اكتب وصف مختصر', 'Enter description')
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageCtrl,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(
                      isArabic,
                      'رابط صورة (اختياري)',
                      'Image URL (optional)',
                    ),
                    prefixIcon: const Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.turquoiseDark,
                  ),
                  title: Text(AppStrings.tr(isArabic, 'تاريخ الواقعة', 'Incident Date')),
                  subtitle: Text(
                    '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                  ),
                  trailing: TextButton(
                    onPressed: _pickDate,
                    child: Text(AppStrings.tr(isArabic, 'تغيير', 'Change')),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: const Icon(Icons.send_rounded),
                  label: Text(
                    AppStrings.tr(isArabic, 'نشر البلاغ', 'Publish Report'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

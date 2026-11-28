/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: ItemDetailsScreen
///
/// TODO (Abdelrahman):
/// - اعرض تفاصيل `report` كاملة (الصورة، الفئة، اللون، التاريخ، الموقع، الوصف).
/// - أضف زر "تواصل مع الواجد/المالك" لفتح `AppRoutes.safeChat`.
library;

import 'package:flutter/material.dart';

import '../../core/models/report_item.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.report});

  final ReportItem report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(report.title)),
      body: Center(
        child: Text('ItemDetailsScreen (${report.id}) — TODO: Abdelrahman UI'),
      ),
    );
  }
}

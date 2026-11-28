/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: ReportItemScreen
///
/// TODO (Abdelrahman):
/// - صمم نموذج الإبلاغ (مفقود/معثور عليه، الفئة `ItemCategory`، العنوان، اللون، الوصف، المكان، التاريخ، صورة).
/// - اربط الإرسال بـ `MafqoodRepository.createReport(...)` لتشغيل المطابقة الذكية تلقائياً.
library;

import 'package:flutter/material.dart';

class ReportItemScreen extends StatelessWidget {
  const ReportItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Item')),
      body: const Center(
        child: Text('ReportItemScreen — TODO: Abdelrahman UI'),
      ),
    );
  }
}

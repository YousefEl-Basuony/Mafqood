/// المسؤول عن الشاشة: عبدالرحمن محمد (Abdelrahman Mohamed)
/// Screen: HomeFeedScreen
///
/// TODO (Abdelrahman):
/// - صمم الشاشة الرئيسية (شريط بحث، تبويب Lost / Found، كروت أحدث البلاغات).
/// - استخدم `MafqoodRepository.watchReports()` و `ReportCard` لعرض العناصر.
/// - اربط أيقونة الجرس بـ `AppRoutes.notifications` وزر الإضافة بـ `AppRoutes.reportItem`.
library;

import 'package:flutter/material.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mafqood Home')),
      body: const Center(
        child: Text('HomeFeedScreen — TODO: Abdelrahman UI'),
      ),
    );
  }
}

/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: AdminDashboardScreen
///
/// TODO (Yousef):
/// - اعرض إحصائيات البلاغات (النشطة، المكتملة، المعلقة) من `MafqoodRepository.watchReports()`.
/// - أضف قائمة البلاغات المعلقة مع أزرار "موافقة" (`approveReport`) و"حذف" (`deleteReport`).
library;

import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: const Center(
        child: Text('AdminDashboardScreen — TODO: Yousef UI'),
      ),
    );
  }
}

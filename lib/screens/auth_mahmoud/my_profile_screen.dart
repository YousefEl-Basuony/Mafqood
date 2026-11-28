/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: MyProfileScreen
///
/// TODO (Mahmoud):
/// - اعرض بيانات المستخدم من `AuthRepository.currentUser`.
/// - اعرض قائمة بلاغات المستخدم النشطة من `MafqoodRepository.watchReports()`.
/// - أضف زر فتح الإعدادات (`AppRoutes.settings`) وزر لوحة الإدارة للأدمن (`AppRoutes.adminDashboard`).
/// - أضف زر تسجيل الخروج (`AuthRepository.signOut`).
library;

import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: const Center(
        child: Text('MyProfileScreen — TODO: Mahmoud UI'),
      ),
    );
  }
}

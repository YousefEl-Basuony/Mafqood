/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: SplashScreen
///
/// TODO (Mahmoud):
/// - صمم شاشة البداية (اللوجو + اسم التطبيق "مفقود" + Animation بسيط).
/// - استخدم `AuthRepository` للتحقق من حالة تسجيل الدخول والانتقال تلقائياً
///   إلى `AppRoutes.mainShell` أو `AppRoutes.login`.
library;

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SplashScreen — TODO: Mahmoud UI'),
      ),
    );
  }
}

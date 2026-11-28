/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: LoginScreen
///
/// TODO (Mahmoud):
/// - صمم واجهة تسجيل الدخول (Email + Password + زر Google Sign-In).
/// - اربطها بـ `AuthRepository.signInWithEmail` و `AuthRepository.signInWithGoogle`.
/// - أضف رابط للانتقال إلى `AppRoutes.register`.
library;

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('LoginScreen — TODO: Mahmoud UI'),
      ),
    );
  }
}

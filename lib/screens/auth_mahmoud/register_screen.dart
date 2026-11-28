/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: RegisterScreen
///
/// TODO (Mahmoud):
/// - صمم نموذج إنشاء الحساب (الاسم الكامل، رقم الهاتف، الإيميل، كلمة المرور).
/// - اربطه بـ `AuthRepository.registerWithEmail` و `SavedAccountManager.saveAccount`.
library;

import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(
        child: Text('RegisterScreen — TODO: Mahmoud UI'),
      ),
    );
  }
}

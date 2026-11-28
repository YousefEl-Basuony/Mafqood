/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: RegisterScreen — إنشاء حساب جديد (الاسم، الهاتف، الإيميل، كلمة المرور).
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/local/saved_account_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final auth = context.read<AuthRepository>();
      final saved = context.read<SavedAccountManager>();
      final user = await auth.registerWithEmail(
        name: _nameCtrl.text,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
      );
      await saved.saveAccount(user);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.mainShell,
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'إنشاء حساب', 'Create Account')),
      ),
      child: SingleChildScrollView(
        child: AppCard(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'الاسم الكامل', 'Full Name'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? AppStrings.tr(isArabic, 'اكتب اسمك الكامل', 'Enter full name')
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'رقم الهاتف', 'Phone Number'),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().length < 8)
                      ? AppStrings.tr(isArabic, 'اكتب رقم هاتف صحيح', 'Enter valid phone')
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'البريد الإلكتروني', 'Email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? AppStrings.tr(isArabic, 'اكتب إيميل صحيح', 'Enter valid email')
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(isArabic, 'كلمة المرور', 'Password'),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (v) => (v == null || v.length < 6)
                      ? AppStrings.tr(
                          isArabic,
                          'كلمة المرور 6 أحرف على الأقل',
                          'Minimum 6 characters',
                        )
                      : null,
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppStrings.tr(isArabic, 'تسجيل الحساب', 'Register')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

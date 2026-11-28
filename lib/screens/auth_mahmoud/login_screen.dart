/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: LoginScreen — تسجيل الدخول بالإيميل والباسورد + Google Sign-In.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/local/saved_account_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../navigation/app_routes.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'abdelrahman@mafqood.app');
  final _passwordCtrl = TextEditingController(text: '123456');
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final auth = context.read<AuthRepository>();
      final saved = context.read<SavedAccountManager>();
      final user = await auth.signInWithEmail(
        _emailCtrl.text,
        _passwordCtrl.text,
      );
      await saved.saveAccount(user);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final auth = context.read<AuthRepository>();
      final saved = context.read<SavedAccountManager>();
      final user = await auth.signInWithGoogle();
      await saved.saveAccount(user);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
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
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.turquoise.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.travel_explore_rounded,
                    size: 40,
                    color: AppColors.turquoiseDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.tr(isArabic, 'أهلاً بك في مفقود', 'Welcome to Mafqood'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.tr(
                  isArabic,
                  'سجل دخولك لمتابعة بلاغاتك والتواصل بأمان',
                  'Sign in to track reports and chat safely',
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppStrings.tr(isArabic, 'البريد الإلكتروني', 'Email'),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || !v.contains('@')) {
                            return AppStrings.tr(
                              isArabic,
                              'اكتب إيميل صحيح',
                              'Enter a valid email',
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: AppStrings.tr(isArabic, 'كلمة المرور', 'Password'),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return AppStrings.tr(
                              isArabic,
                              'كلمة المرور 6 أحرف على الأقل',
                              'Minimum 6 characters',
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _handleLogin,
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(AppStrings.tr(isArabic, 'تسجيل الدخول', 'Sign In')),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _loading ? null : _handleGoogleSignIn,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                        label: Text(
                          AppStrings.tr(
                            isArabic,
                            'المتابعة بحساب Google',
                            'Continue with Google',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.tr(isArabic, 'معندكش حساب؟', "Don't have an account?"),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.register),
                    child: Text(
                      AppStrings.tr(isArabic, 'إنشاء حساب جديد', 'Create Account'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// المسؤول عن الشاشة: محمود أبو النادي (Mahmoud Abo El-Nady)
/// Screen: SplashScreen — شاشة البداية باللوجو واسم "مفقود" والانتقال التلقائي.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../navigation/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _timer = Timer(const Duration(milliseconds: 1600), _navigateNext);
  }

  void _navigateNext() {
    if (!mounted) return;
    final auth = context.read<AuthRepository>();
    final target =
        auth.currentUser != null ? AppRoutes.mainShell : AppRoutes.login;
    Navigator.of(context).pushReplacementNamed(target);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navyDeep, AppColors.navyPrimary],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  color: AppColors.turquoise.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.turquoise,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.travel_explore_rounded,
                  size: 56,
                  color: AppColors.turquoiseLight,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              AppStrings.tr(isArabic, 'مفقود', 'Mafqood'),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.tr(
                isArabic,
                'منصة ذكية للمفقودات والمعثورات',
                'Smart Lost & Found Platform',
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLightSecondary,
                  ),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.6,
                color: AppColors.turquoiseLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Unified screen container with adaptive Dark/Light background, optional
/// gradient header, and smooth fade-in animation.
class AppScreenContainer extends StatelessWidget {
  const AppScreenContainer({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.useSafeArea = true,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget body = TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      builder: (context, value, childWidget) => Opacity(
        opacity: value,
        child: childWidget,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (useSafeArea) {
      body = SafeArea(child: body);
    }

    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.navyDeep, const Color(0xFF131D33)]
                : [AppColors.lightBackground, const Color(0xFFF1F5F9)],
          ),
        ),
        child: body,
      ),
    );
  }
}

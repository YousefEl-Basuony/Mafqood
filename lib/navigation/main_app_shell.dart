import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/localization/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../data/local/app_settings_manager.dart';
import '../screens/auth_mahmoud/my_profile_screen.dart';
import '../screens/reports_abdelrahman/home_feed_screen.dart';
import '../screens/reports_abdelrahman/search_filter_screen.dart';
import '../screens/smart_yousef/smart_matches_screen.dart';

/// Main bottom-navigation shell hosting the 4 primary tabs of Mafqood.
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  static const List<Widget> _tabs = [
    HomeFeedScreen(),
    SearchFilterScreen(),
    SmartMatchesScreen(),
    MyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppSettingsManager>().isArabic;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        indicatorColor: AppColors.turquoise.withValues(alpha: 0.2),
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: AppStrings.tr(isArabic, 'الرئيسية', 'Home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search_rounded),
            label: AppStrings.tr(isArabic, 'البحث', 'Search'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome_rounded),
            label: AppStrings.tr(isArabic, 'التطابقات', 'Matches'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: AppStrings.tr(isArabic, 'ملفي', 'Profile'),
          ),
        ],
      ),
    );
  }
}

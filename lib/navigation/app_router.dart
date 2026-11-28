import 'package:flutter/material.dart';

import '../core/models/report_item.dart';
import '../screens/auth_mahmoud/login_screen.dart';
import '../screens/auth_mahmoud/my_profile_screen.dart';
import '../screens/auth_mahmoud/register_screen.dart';
import '../screens/auth_mahmoud/splash_screen.dart';
import '../screens/reports_abdelrahman/home_feed_screen.dart';
import '../screens/reports_abdelrahman/item_details_screen.dart';
import '../screens/reports_abdelrahman/report_item_screen.dart';
import '../screens/reports_abdelrahman/search_filter_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/smart_yousef/admin_dashboard_screen.dart';
import '../screens/smart_yousef/notifications_screen.dart';
import '../screens/smart_yousef/safe_chat_screen.dart';
import '../screens/smart_yousef/smart_matches_screen.dart';
import 'app_routes.dart';
import 'main_app_shell.dart';

/// Application route generator connecting all 13 screens cleanly.
class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const MainAppShell());
      case AppRoutes.homeFeed:
        return MaterialPageRoute(builder: (_) => const HomeFeedScreen());
      case AppRoutes.reportItem:
        return MaterialPageRoute(builder: (_) => const ReportItemScreen());
      case AppRoutes.searchFilter:
        return MaterialPageRoute(builder: (_) => const SearchFilterScreen());
      case AppRoutes.smartMatches:
        return MaterialPageRoute(builder: (_) => const SmartMatchesScreen());
      case AppRoutes.myProfile:
        return MaterialPageRoute(builder: (_) => const MyProfileScreen());
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.itemDetails:
        final report = settings.arguments as ReportItem;
        return MaterialPageRoute(
          builder: (_) => ItemDetailsScreen(report: report),
        );
      case AppRoutes.safeChat:
        final args =
            (settings.arguments as Map<String, dynamic>?) ?? const {};
        return MaterialPageRoute(
          builder: (_) => SafeChatScreen(
            chatId: (args['chatId'] as String?) ?? 'default_chat',
            peerName: (args['peerName'] as String?) ?? 'مستخدم مفقود',
            peerUserId: (args['peerUserId'] as String?) ?? '',
            itemTitle: (args['itemTitle'] as String?) ?? 'بلاغ مفقود',
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}

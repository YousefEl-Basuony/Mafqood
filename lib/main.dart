import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/local/app_settings_manager.dart';
import 'data/local/saved_account_manager.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/mafqood_repository.dart';
import 'navigation/app_router.dart';
import 'navigation/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsManager = AppSettingsManager();
  final savedAccountManager = SavedAccountManager();
  await Future.wait([
    settingsManager.load(),
    savedAccountManager.load(),
  ]);

  // Uses Fake repositories by default so the app runs immediately without
  // requiring google-services.json. Swap to FirebaseAuthRepository and
  // FirebaseMafqoodRepository after running `flutterfire configure`.
  final AuthRepository authRepository = FakeAuthRepository(
    initialUser: savedAccountManager.activeAccount,
  );
  final MafqoodRepository mafqoodRepository = FakeMafqoodRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsManager),
        ChangeNotifierProvider.value(value: savedAccountManager),
        Provider<AuthRepository>.value(value: authRepository),
        Provider<MafqoodRepository>.value(value: mafqoodRepository),
      ],
      child: const MafqoodApp(),
    ),
  );
}

class MafqoodApp extends StatelessWidget {
  const MafqoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsManager>();

    return MaterialApp(
      title: 'مفقود | Mafqood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

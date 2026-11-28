/// شاشة مشتركة: الإعدادات، التبديل بين الحسابات، وقسم عن الفريق.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/app_settings_manager.dart';
import '../../data/local/saved_account_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_screen_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsManager>();
    final savedAccounts = context.watch<SavedAccountManager>();
    final auth = context.read<AuthRepository>();
    final isArabic = settings.isArabic;

    return AppScreenContainer(
      appBar: AppBar(
        title: Text(AppStrings.tr(isArabic, 'الإعدادات', 'Settings')),
      ),
      child: ListView(
        children: [
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  value: settings.notificationsEnabled,
                  onChanged: settings.toggleNotifications,
                  secondary: const Icon(Icons.notifications_outlined),
                  title: Text(
                    AppStrings.tr(isArabic, 'تفعيل الإشعارات', 'Notifications'),
                  ),
                  subtitle: Text(
                    AppStrings.tr(
                      isArabic,
                      'تنبيهات التطابقات الذكية والرسائل',
                      'Smart match & chat alerts',
                    ),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: settings.isDarkMode,
                  onChanged: settings.toggleDarkMode,
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: Text(AppStrings.tr(isArabic, 'الوضع الليلي', 'Dark Mode')),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(AppStrings.tr(isArabic, 'اللغة', 'Language')),
                  subtitle: Text(isArabic ? 'العربية' : 'English'),
                  trailing: FilledButton.tonal(
                    onPressed: settings.toggleLanguage,
                    child: Text(isArabic ? 'English' : 'العربية'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.tr(
              isArabic,
              'التبديل السريع بين الحسابات المحفوظة',
              'Quick Account Switcher',
            ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: savedAccounts.savedAccounts.map((acc) {
                final isActive = auth.currentUser?.uid == acc.uid;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.turquoise.withValues(alpha: 0.18),
                    child: Icon(
                      acc.isAdmin ? Icons.shield_outlined : Icons.person_outline,
                      color: AppColors.turquoiseDark,
                    ),
                  ),
                  title: Text(acc.name),
                  subtitle: Text(
                    '${acc.email} • ${acc.isAdmin ? "Admin" : "User"}',
                  ),
                  trailing: isActive
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.foundGreen,
                        )
                      : TextButton(
                          onPressed: () async {
                            await savedAccounts.setActiveAccount(acc.uid);
                            await auth.switchUser(acc);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppStrings.tr(
                                    isArabic,
                                    'تم التبديل إلى ${acc.name}',
                                    'Switched to ${acc.name}',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(AppStrings.tr(isArabic, 'تبديل', 'Switch')),
                        ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.tr(isArabic, 'عن تطبيق مفقود والفريق', 'About Mafqood & Team'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TeamMemberRow(
                  name: 'يوسف محمد البسيوني (Yousef Mohamed El-Basuony)',
                  role: AppStrings.tr(
                    isArabic,
                    'قائد الفريق والباك إند والمطابقة الذكية',
                    'Team Lead, Architecture & Smart Backend',
                  ),
                ),
                const Divider(),
                _TeamMemberRow(
                  name: 'عبدالرحمن محمد (Abdelrahman Mohamed)',
                  role: AppStrings.tr(
                    isArabic,
                    'واجهات البلاغات والبحث ومشارك الباك إند',
                    'Reports & Search UI + Backend Co-developer',
                  ),
                ),
                const Divider(),
                _TeamMemberRow(
                  name: 'محمود أبو النادي (Mahmoud Abo El-Nady)',
                  role: AppStrings.tr(
                    isArabic,
                    'واجهات الدخول والبروفايل',
                    'Auth & Profile UI',
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    const Icon(
                      Icons.mail_outline_rounded,
                      size: 18,
                      color: AppColors.turquoiseDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.tr(
                        isArabic,
                        'التواصل: contact@mafqood.app',
                        'Contact: contact@mafqood.app',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberRow extends StatelessWidget {
  const _TeamMemberRow({required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(role, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

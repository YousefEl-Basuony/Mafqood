/// المسؤول عن الشاشة: يوسف محمد البسيوني (Yousef Mohamed El-Basuony)
/// Screen: NotificationsScreen
///
/// TODO (Yousef):
/// - اعرض الإشعارات الفورية من `MafqoodRepository.watchNotifications(uid)`.
/// - صنّف الإشعارات إلى "اليوم / أمس" مع تمييز غير المقروء وربط النقر بـ `markNotificationRead`.
library;

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Text('NotificationsScreen — TODO: Yousef UI'),
      ),
    );
  }
}

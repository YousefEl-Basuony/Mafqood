import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/mock_data_provider.dart';
import '../../core/models/app_user.dart';

/// Stores saved user/admin accounts locally for quick switching during demos.
class SavedAccountManager extends ChangeNotifier {
  static const _keySavedAccounts = 'mafqood_saved_accounts';
  static const _keyActiveUid = 'mafqood_active_uid';

  List<AppUser> _savedAccounts = [];
  String? _activeUid;

  List<AppUser> get savedAccounts => List.unmodifiable(_savedAccounts);
  String? get activeUid => _activeUid;

  AppUser? get activeAccount {
    if (_savedAccounts.isEmpty) return null;
    if (_activeUid == null) return _savedAccounts.first;
    return _savedAccounts.firstWhere(
      (u) => u.uid == _activeUid,
      orElse: () => _savedAccounts.first,
    );
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keySavedAccounts);
    if (raw == null || raw.isEmpty) {
      // Seed demo user and admin accounts for immediate quick-switch demo.
      _savedAccounts = List.of(MockDataProvider.demoUsers);
      _activeUid = _savedAccounts.first.uid;
      await _persist();
    } else {
      _savedAccounts = raw
          .map((item) => AppUser.fromMap(jsonDecode(item) as Map<String, dynamic>))
          .toList();
      _activeUid = prefs.getString(_keyActiveUid) ?? _savedAccounts.firstOrNull?.uid;
    }
    notifyListeners();
  }

  Future<void> saveAccount(AppUser user) async {
    final idx = _savedAccounts.indexWhere((u) => u.uid == user.uid);
    if (idx >= 0) {
      _savedAccounts[idx] = user;
    } else {
      _savedAccounts.add(user);
    }
    _activeUid = user.uid;
    notifyListeners();
    await _persist();
  }

  Future<void> setActiveAccount(String uid) async {
    _activeUid = uid;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveUid, uid);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keySavedAccounts,
      _savedAccounts.map((u) => jsonEncode(u.toMap())).toList(),
    );
    if (_activeUid != null) {
      await prefs.setString(_keyActiveUid, _activeUid!);
    }
  }
}

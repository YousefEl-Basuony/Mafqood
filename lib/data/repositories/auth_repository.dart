import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/data/mock_data_provider.dart';
import '../../core/models/app_user.dart';

/// Authentication repository contract for Mafqood.
abstract class AuthRepository {
  AppUser? get currentUser;
  Stream<AppUser?> get authStateChanges;

  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> registerWithEmail({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  Future<AppUser> signInWithGoogle();
  Future<void> switchUser(AppUser user);
  Future<void> signOut();
}

/// In-memory fake auth implementation for immediate UI & flow testing.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? initialUser})
      : _currentUser = initialUser ?? MockDataProvider.demoUsers.first;

  final _controller = StreamController<AppUser?>.broadcast();
  final List<AppUser> _users = List.of(MockDataProvider.demoUsers);
  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> get authStateChanges async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final normalized = email.trim().toLowerCase();
    final existing = _users.where((u) => u.email.toLowerCase() == normalized);
    if (existing.isNotEmpty) {
      _currentUser = existing.first;
    } else {
      _currentUser = AppUser(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: normalized.split('@').first,
        email: normalized,
        phone: '01000000000',
        role: normalized.contains('admin') ? 'admin' : 'user',
        createdAt: DateTime.now(),
      );
      _users.add(_currentUser!);
    }
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final user = AppUser(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
      role: 'user',
      createdAt: DateTime.now(),
    );
    _users.add(user);
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _currentUser = MockDataProvider.demoUsers[1];
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> switchUser(AppUser user) async {
    _currentUser = user;
    _controller.add(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}

/// Production Firebase Auth + Firestore profile implementation.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    fb_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  AppUser? _cachedUser;

  @override
  AppUser? get currentUser => _cachedUser;

  @override
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) {
        _cachedUser = null;
        return null;
      }
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (doc.exists && doc.data() != null) {
        _cachedUser = AppUser.fromMap(doc.data()!, docId: doc.id);
      } else {
        _cachedUser = AppUser(
          uid: fbUser.uid,
          name: fbUser.displayName ?? 'مستخدم مفقود',
          email: fbUser.email ?? '',
          phone: fbUser.phoneNumber ?? '',
          createdAt: DateTime.now(),
        );
      }
      return _cachedUser;
    });
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = cred.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    final user = doc.exists && doc.data() != null
        ? AppUser.fromMap(doc.data()!, docId: uid)
        : AppUser(
            uid: uid,
            name: cred.user?.displayName ?? email.split('@').first,
            email: email.trim(),
            phone: '',
            createdAt: DateTime.now(),
          );
    _cachedUser = user;
    return user;
  }

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name.trim());
    final user = AppUser(
      uid: cred.user!.uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      role: 'user',
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    _cachedUser = user;
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.authenticate();
    final authTokens = googleAccount.authentication;
    final cred = fb_auth.GoogleAuthProvider.credential(
      idToken: authTokens.idToken,
    );
    final userCred = await _auth.signInWithCredential(cred);
    final fbUser = userCred.user!;
    final docRef = _firestore.collection('users').doc(fbUser.uid);
    final doc = await docRef.get();
    if (doc.exists && doc.data() != null) {
      _cachedUser = AppUser.fromMap(doc.data()!, docId: fbUser.uid);
    } else {
      _cachedUser = AppUser(
        uid: fbUser.uid,
        name: fbUser.displayName ?? googleAccount.displayName ?? 'مستخدم مفقود',
        email: fbUser.email ?? googleAccount.email,
        phone: fbUser.phoneNumber ?? '',
        avatarUrl: fbUser.photoURL,
        createdAt: DateTime.now(),
      );
      await docRef.set(_cachedUser!.toMap());
    }
    return _cachedUser!;
  }

  @override
  Future<void> switchUser(AppUser user) async {
    _cachedUser = user;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    _cachedUser = null;
  }
}

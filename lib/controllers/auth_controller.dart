import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:taskly/models/app_user_model.dart';
import 'package:taskly/services/auth_service.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/utils/app_snackbar.dart';

class AuthController extends GetxController {
  AuthController({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<AppUserModel> appUser = Rxn<AppUserModel>();
  final isLoginLoading = false.obs;
  final isSignupLoading = false.obs;
  final isProfileUpdating = false.obs;

  final Completer<void> _authReadyCompleter = Completer<void>();
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AppUserModel?>? _profileSubscription;

  bool get isLoggedIn => firebaseUser.value != null;

  String get displayName {
    final profileName = appUser.value?.name.trim() ?? '';
    if (profileName.isNotEmpty) {
      return profileName;
    }
    final authName = firebaseUser.value?.displayName?.trim() ?? '';
    if (authName.isNotEmpty) {
      return authName;
    }
    return 'Productive You';
  }

  String get emailAddress =>
      appUser.value?.email ?? firebaseUser.value?.email ?? '';

  Future<void> ensureInitialized() => _authReadyCompleter.future;

  @override
  void onInit() {
    super.onInit();
    _authSubscription = _authService.authStateChanges().listen((user) {
      firebaseUser.value = user;
      _bindProfile(user);

      if (!_authReadyCompleter.isCompleted) {
        _authReadyCompleter.complete();
      }
    });
  }

  void _bindProfile(User? user) {
    _profileSubscription?.cancel();

    if (user == null) {
      appUser.value = null;
      return;
    }

    _profileSubscription = _authService.streamUserProfile(user.uid).listen((
      profile,
    ) {
      appUser.value = profile ?? AppUserModel.fromFirebaseUser(user);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoginLoading.value = true;
      await _authService.signIn(email: email, password: password);
      AppSnackbar.success('Welcome back. Your workspace is ready.');
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (error) {
      AppSnackbar.error(_mapAuthError(error));
    } catch (_) {
      AppSnackbar.error('We could not sign you in right now.');
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isSignupLoading.value = true;
      await _authService.signUp(name: name, email: email, password: password);
      AppSnackbar.success('Account created successfully.');
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (error) {
      AppSnackbar.error(_mapAuthError(error));
    } catch (_) {
      AppSnackbar.error('We could not create your account right now.');
    } finally {
      isSignupLoading.value = false;
    }
  }

  Future<void> updateProfileName(String name) async {
    final user = firebaseUser.value;
    if (user == null) {
      return;
    }

    try {
      isProfileUpdating.value = true;
      await _authService.updateProfileName(user.uid, name);
      AppSnackbar.success('Profile updated.');
    } catch (_) {
      AppSnackbar.error('We could not update your profile right now.');
    } finally {
      isProfileUpdating.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.login);
      AppSnackbar.success('You have been logged out.');
    } catch (_) {
      AppSnackbar.error('Logout failed. Please try again.');
    }
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'That email is already connected to another account.';
      case 'weak-password':
        return 'Use a stronger password with at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Your email or password does not match our records.';
      case 'too-many-requests':
        return 'Too many attempts detected. Please wait a moment.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.onClose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskly/models/app_user_model.dart';
import 'package:taskly/utils/app_constants.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Stream<AppUserModel?> streamUserProfile(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) {
            return null;
          }
          return AppUserModel.fromMap(snapshot.data()!, snapshot.id);
        });
  }

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await credential.user?.updateDisplayName(name.trim());

    final user = AppUserModel(
      id: credential.user!.uid,
      name: name.trim(),
      email: email.trim(),
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> updateProfileName(String uid, String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
    await _firestore.collection(AppConstants.usersCollection).doc(uid).set({
      'name': name.trim(),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

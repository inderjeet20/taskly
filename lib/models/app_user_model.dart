import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserModel {
  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  factory AppUserModel.fromMap(Map<String, dynamic> map, String id) {
    return AppUserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory AppUserModel.fromFirebaseUser(User user) {
    return AppUserModel(
      id: user.uid,
      name: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : user.email?.split('@').first ?? 'Taskly User',
      email: user.email ?? '',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppUserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

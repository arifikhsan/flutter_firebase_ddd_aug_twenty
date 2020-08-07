import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/user.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/value_objects.dart';

extension FirebaseUserDomainExtension on FirebaseUser {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}

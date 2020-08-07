import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/user.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/value_objects.dart';

abstract class AuthFacadeInterface {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<Option<User>> getSignedInUser();
  Future<void> signedOut();
}

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/auth_facade_interface.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/user.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_aug/infrastructure/auth/firebase_user_mapper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthFacadeInterface)
class FirebaseAuthFacade implements AuthFacadeInterface {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthFacade(
    this._firebaseAuth,
    this._googleSignIn,
  );

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  }) async {
    final emailAddressString = emailAddress.getOrCrash() as String;
    final passwordString = password.getOrCrash() as String;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddressString,
        password: passwordString,
      );
      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  }) async {
    final emailAddressString = emailAddress.getOrCrash() as String;
    final passwordString = password.getOrCrash() as String;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddressString,
        password: passwordString,
      );
      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD' ||
          e.code == 'ERROR_USER_NOT_FOUND') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(const AuthFailure.cancelledByUser());
      }

      final googleAuthentication = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );

      return _firebaseAuth
          .signInWithCredential(authCredential)
          .then((value) => right(unit));
    } on PlatformException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Option<User>> getSignedInUser() {
    return _firebaseAuth
        .currentUser()
        .then((firebaseUser) => optionOf(firebaseUser?.toDomain()));
  }

  @override
  Future<void> signedOut() => Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
}

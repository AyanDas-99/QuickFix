import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickfix/state/auth/models/auth_result.dart';
import 'package:quickfix/state/auth/models/auth_state.dart';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepositoryNotifier extends _$AuthRepositoryNotifier {
  @override
  AuthState build() {
    if (_fAUth.currentUser != null &&
        _fAUth.currentUser?.emailVerified == true) {
      return AuthState(
          authResult: AuthResult.success,
          isLoading: false,
          userId: _fAUth.currentUser?.uid);
    }
    return const AuthState.unknown();
  }

  final FirebaseAuth _fAUth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // final userStorage = UserStorageRepository();

  Future googleLogin() async {
    state = state.copyWithIsLoading(true);
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await _fAUth.signInWithCredential(credential);
      // final stored = await userStorage.storeUserToDb(_fAUth.currentUser!);
      state = AuthState(
          authResult: AuthResult.success,
          isLoading: false,
          userId: _fAUth.currentUser?.uid);
    } catch (e) {
      developer.log("Google login error", error: e);
    }
    state = state.copyWithIsLoading(false);
  }

  Future createAccountWithEmail(
      {required String email,
      required String password,
      required VoidCallback onVerificationSent}) async {
    try {
      await _fAUth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _fAUth.currentUser?.sendEmailVerification();
      developer.log("Email verification sent");
      onVerificationSent();
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWithIsLoading(true);
      Timer.periodic(const Duration(seconds: 15), (timer) async {
        _fAUth.currentUser?.reload();
        if (_fAUth.currentUser?.emailVerified == true) {
          timer.cancel();

          // final stored = await userStorage.storeUserToDb(_fAUth.currentUser!);
          state = AuthState(
              authResult: AuthResult.success,
              isLoading: false,
              userId: _fAUth.currentUser?.uid);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        developer.log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        developer.log('The account already exists for that email.');
      } else {
        developer.log(e.toString());
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

  Future emailLogin({required String email, required String password}) async {
    // state = true;
    state = state.copyWithIsLoading(true);
    try {
      await _fAUth.signInWithEmailAndPassword(email: email, password: password);
      state = AuthState(
          authResult: AuthResult.success,
          isLoading: false,
          userId: _fAUth.currentUser?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        developer.log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        developer.log('Wrong password provided for that user.');
      }
    }
    // state = false;
    state = state.copyWithIsLoading(false);
  }

  // Phone sign up
  Future<void> phoneSignUp(
      {required String phoneNumber,
      required Function(String) showMessage,
      required Function(String) codeSent}) async {
    state = state.copyWithIsLoading(true);
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (cred) async {
            await auth.signInWithCredential(cred);
          },
          verificationFailed: (e) {
            if (e.code == 'invalid-phone-number') {
              showMessage("Invalid phone number");
            } else {
              showMessage("Sign in with phone number failed");
            }
            state = const AuthState(
                authResult: AuthResult.failed, isLoading: false, userId: null);
          },
          codeSent: (verificationId, code) {
            developer.log("Code is sent");
            codeSent(verificationId);
          },
          codeAutoRetrievalTimeout: (s) {});
    } catch (e) {
      developer.log("Sign in with phone", error: e);
    }
    state = state.copyWithIsLoading(false);
  }

  // CheckOTP
  Future<bool> checkOTP(
      {required String verificationId,
      required String otp,
      required String name}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      state = AuthState(
          authResult: AuthResult.success,
          isLoading: false,
          userId: FirebaseAuth.instance.currentUser!.uid);
      return true;
    } catch (e) {
      developer.log("OTP check error", error: e);
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWithIsLoading(true);
    try {
      _fAUth.signOut();
      _googleSignIn.signOut();
      state = const AuthState.unknown();
    } catch (e) {
      developer.log("Sign out error", error: e);
    }
    state = state.copyWithIsLoading(false);
  }
}

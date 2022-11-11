// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hub/service/globas_service.dart';

class AuthRepo {
  static Future<void> singUpWithEmailAndPassword(email, password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> loginWithEmailAndPassword(email, password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> sendEmailVerification() async {
    try {
      auth.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  static get uid {
    return auth.currentUser!.uid;
  }

  static Future<void> updateUserName(storeName) async {
    await auth.currentUser!.updateDisplayName(storeName);
  }

  static Future<void> updateProfileImage(storeLogo) async {
    await auth.currentUser!.updatePhotoURL(storeLogo);
  }

  static Future<void> reloadUserData() async {
    await auth.currentUser!.reload();
  }

  static Future<bool> checkEmailVerification() async {
    try {
      bool emailVerified = auth.currentUser!.emailVerified;
      return emailVerified == true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logOut() async {
    await auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      var credetialResult =
          await auth.currentUser!.reauthenticateWithCredential(authCredential);

      return credetialResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> updateUserPassword(newPassword) async {
    try {
      await auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      print(e);
    }
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  bool isFirstTime = true;
  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitalScreen);
  }

  _setInitalScreen(User? user) {
    if (isFirstTime) {
      isFirstTime = false;
      Future.delayed(const Duration(seconds: 0), () {
        user == null
            ? Get.offAllNamed("/login")
            : Get.offAllNamed("/dashboard");
      });
    } else {
      user == null ? Get.offAllNamed("/login") : Get.offAllNamed("/dashboard");
    }
  }

  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final userId = userCredential.user?.uid;

      return userId;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          log(e.toString());
          Get.offAndToNamed("/login");
          return null;
        }
        log(e.toString());
      }
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

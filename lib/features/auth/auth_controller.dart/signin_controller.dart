import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final FirebaseAuth firestore = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> loginUser() async {
    try {
      log("message");
      print(email.text);
      log(password.text);

      UserCredential loggedIn = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());

      Get.snackbar(
        'Success',
        'Login successful',
        backgroundColor: const Color.fromARGB(233, 65, 65, 73),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Success',
        'Login Failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      log('Error while logging in: $e');
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retry/retry.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/authentication_controller.dart';
import 'package:videoplayer/model/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final controller = Get.put(AuthenticationController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();



  Future<String?> uploadPic(String name, File file) async {
    try {
      Reference ref = _storage.ref().child(name);
      const RetryOptions retryOptions = RetryOptions(
        maxAttempts: 3,
        delayFactor: Duration(seconds: 1),
      );
      final uploadTask = ref.putFile(file);
      final snapshot = await retryOptions.retry(
        () => uploadTask,
        retryIf: (e) => e is TimeoutException,
      );
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      log("Error uploading pic: $e");
      return null;
    }
  }

  void register() async {
    try {
      if (name.text.isEmpty ||
          dob.text.isEmpty ||
          email.text.isEmpty ||
          password.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all fields',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String? uid = await controller.createUserWithEmailAndPassword(
          email.text, password.text);
      if (uid != null) {
        String? imageUrl;
        if (_imageBytes != null) {
          imageUrl = await uploadPic(uid, _imageBytes!);
        }

        Usermodel user = Usermodel(
          name: name.text,
          dob: dob.text,
          email: email.text,
          photo: imageUrl,
        );

        await Usermodel.collection.doc(uid).set(user.toJson());
        Get.snackbar(
          'Success',
          'Registration successful',
          backgroundColor: const Color.fromARGB(233, 65, 65, 73),
          colorText: Colors.white,
        );

        name.clear();
        dob.clear();
        email.clear();
        password.clear();
        log("Registration successful");
        log(_auth.currentUser.toString());
      }
    } catch (e) {
      log('Registration Failed: $e');
      Get.snackbar(
        'Error',
        'Registration failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  File? _imageBytes;

  void setImageFile(File? imageFile) {
    _imageBytes = imageFile;
  }
}

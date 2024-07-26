import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:videoplayer/model/user_model.dart';

class Profilecontroller extends GetxController {
  static Profilecontroller get instance => Get.find();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<Usermodel> getuserdata() async* {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      try {
        final snapshots = firestore.collection('users').doc(userId).snapshots();
        yield* snapshots.map((snapshot) => Usermodel.fromSnapshot(snapshot));
      } catch (e) {
        log("Error fetching Userdata: $e");
        rethrow;
      }
    } else {
      log("No user logged in");
    }
  }
}

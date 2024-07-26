import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('users');

  final String? id;
  final String? name;
  final String? dob;
  final String? email;
  final String? photo;

  Usermodel({
    this.id,
    required this.name,
    required this.dob,
    required this.email,
    this.photo,
  });

  factory Usermodel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Usermodel(
      id: snapshot.id,
      name: data['name'] ?? '',
      dob: data['dob'].toString(),
      email: data['email'].toString(),
      photo: data['photo'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "dob": dob,
        "email": email,
        "photo": photo,
      };
}

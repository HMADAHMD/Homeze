import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String fullname;
  final String email;
  final String number;
  final String uid;
  final String photoURL;

  const User({
    required this.fullname,
    required this.email,
    required this.number,
    required this.uid,
    required this.photoURL,
  });
  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'email': email,
        'number': number,
        'uid': uid,
        'photoURL': photoURL,
      };

  static User getUser(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
        fullname: snap['fullname'],
        email: snap['email'],
        number: snap['number'],
        uid: snap['uid'],
        photoURL: snap['photoURL']);
  }
}

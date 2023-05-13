import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeze_screens/models/user.dart' as model;
import 'package:homeze_screens/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get userDetails
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.getUser(documentSnapshot);
  }

  //signup tasker
  Future<String> signupUser(
      {required String email,
      required String password,
      required String fullname,
      required String number,
      required Uint8List file}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          number.isNotEmpty ||
          fullname.isNotEmpty ||
          file != null) {
        //only this(email and password) will be stored in firebase auth rest of it will be stored in FirebaseFirestore
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoURL =
            await StorageMethod().uploadImage('profilePics', file);

        model.User user = model.User(
            fullname: fullname,
            email: email,
            number: number,
            uid: cred.user!.uid,
            photoURL: photoURL);

        //create a user in db
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some Error Occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

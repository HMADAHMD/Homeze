import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeze_screens/models/accepted_offer.dart';
import 'package:homeze_screens/models/tasks.dart';
import 'package:homeze_screens/resources/storage_methods.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadTask(
      String description,
      Uint8List file,
      String uid,
      String fullname,
      String title,
      String address,
      String date,
      String time,
      String price) async {
    String res = 'Some Error Ocurred';
    try {
      String photoURL =
          await StorageMethod().uploadTaskImage('tasks', file, true);
      String taskId = const Uuid().v1();
      Task post = Task(
        fullname: fullname,
        description: description,
        taskId: taskId,
        uid: uid,
        datePublished: DateTime.now(),
        postURL: photoURL,
        title: title,
        address: address,
        date: date,
        time: time,
        price: price,
      );
      _firestore.collection('tasks').doc(taskId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> offerAccepted(
    String fullname,
    String address,
    String offerPrice,
    String title,
    String date,
    String time,
    String uid,
    String taskId,
  ) async {
    String res = 'Some Error Ocurred';
    try {
      
      AcceptedOffer acceptedOffer = AcceptedOffer(
        fullname: fullname,
        address: address,
        offerPrice: offerPrice,
        title: title,
        date: date,
        time: time,
        uid: uid,
        taskId: taskId,
      );
      //_firestore.collection('tasks').doc(taskId).set(acceptedOffer.toJson());
      _firestore
          .collection('taskers')
          .doc(uid)
          .collection('assignedTasks')
          .doc(taskId)
          .set(acceptedOffer.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteTask(String taskId) async {
    String res = "Some error occurred";
    try {
      // Delete all offers in the subcollection
      QuerySnapshot offersQuery = await _firestore
          .collection('tasks')
          .doc(taskId)
          .collection('offers')
          .get();
      List<Future<void>> deleteOfferFutures = [];
      offersQuery.docs.forEach((offerDoc) {
        deleteOfferFutures.add(offerDoc.reference.delete());
      });
      await Future.wait(deleteOfferFutures);

      // Delete the task document
      await _firestore.collection('tasks').doc(taskId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

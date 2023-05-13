import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedOffer {
  final String fullname;
  final String address;
  final String offerPrice;
  final String title;
  final String date;
  final String time;
  final String uid;
  final String taskId;

  const AcceptedOffer({
    required this.fullname,
    required this.address,
    required this.offerPrice,
    required this.title,
    required this.date,
    required this.time,
    required this.uid,
    required this.taskId,
  });
  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'address': address,
        'offerPrice': offerPrice,
        'title': title,
        'date': date,
        'time': time,
        'uid': uid,
        'taskId': taskId,
      };

  static AcceptedOffer getUser(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return AcceptedOffer(
      fullname: snap['fullname'],
      address: snap['address'],
      offerPrice: snap['offerPrice'],
      title: snap['title'],
      date: snap['date'],
      time: snap['time'],
      uid: snap['uid'],
      taskId: snap['taskId'],
    );
  }
}

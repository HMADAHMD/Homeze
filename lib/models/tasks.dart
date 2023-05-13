import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  final String fullname;
  final String title;
  final String description;
  final String taskId;
  final String uid;
  final datePublished;
  final String postURL;
  final String date;
  final String time;
  final String address;
  final String price;

  const Task({
    required this.fullname,
    required this.title,
    required this.description,
    required this.taskId,
    required this.uid,
    required this.datePublished,
    required this.postURL,
    required this.date,
    required this.time,
    required this.address,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'title': title,
        'description': description,
        'taskId': taskId,
        'uid': uid,
        'datePublished': datePublished,
        'postURL': postURL,
        'date': date,
        'time': time,
        'address': address,
        'price': price,
      };

  static Task getUser(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Task(
      fullname: snap['fullname'],
      title: snap['title'],
      description: snap['description'],
      taskId: snap['postId'],
      uid: snap['uid'],
      datePublished: snap['datePublished'],
      postURL: snap['postURL'],
      date: snap['date'],
      time: snap['time'],
      address: snap['address'],
      price: snap['price'],
    );
  }
}

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/global.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ActiveTaskersScreen extends StatefulWidget {
  final taskCost;
  DatabaseReference? refTaskRequest;
  ActiveTaskersScreen({super.key, this.refTaskRequest, required this.taskCost});

  @override
  State<ActiveTaskersScreen> createState() => _ActiveTaskersScreenState();
}

class _ActiveTaskersScreenState extends State<ActiveTaskersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: skyclr,
          title: const Text(
            'Available Taskers',
            style: TextStyle(
                color: blueclr, fontWeight: FontWeight.w500, fontSize: 25),
          ),
          elevation: 1,
          leading: IconButton(
              onPressed: () {
                widget.refTaskRequest!.remove();
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  restartApp();
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: orangeclr,
              ))),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                seletedTaskerId = dList[index]['id'].toString();
              });
              Navigator.pop(context, 'taskerSelected');
              Fluttertoast.showToast(msg: "Go to Home Screen Now!!");
            },
            child: Card(
              color: grayclr,
              elevation: 3,
              shadowColor: blueclr,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Image.asset(
                  'assets/images2/' +
                      dList[index]['profession']['profession'].toString() +
                      '.png',
                  //"assets/images2/Cleaning.png",
                  width: 50,
                ),
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dList[index]['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text("Working for " +
                          dList[index]['profession']['experience'].toString() +
                          " years"),
                      SmoothStarRating(
                        rating: 3.5,
                        color: Colors.amber[600],
                        borderColor: Colors.black,
                        allowHalfRating: true,
                        starCount: 5,
                        size: 15,
                      ),
                    ]),
                trailing: Column(
                  children: [Text("Rs." + widget.taskCost.toString())],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/resources/firestore_methods.dart';
import 'package:homeze_screens/screens/offer_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:homeze_screens/models/user.dart' as model;

class TaskCard extends StatefulWidget {
  final snap;
  const TaskCard({super.key, required this.snap});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  deleteYourTask(String taskId) async {
    try {
      String res = await FirestoreMethods().deleteTask(taskId);
      if (res == 'success') {
        showSnackBar('Deleted!', context);
      }
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            color: grayclr, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          widget.snap['title'].toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          widget.snap['price'].toString(),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: orangeclr),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        deleteYourTask(widget.snap['taskId'].toString());
                      },
                      child: Container(
                        height: 45,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Text("Delete",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: blueclr)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfferScreen(
                                      title:  widget.snap['title'].toString(),
                                      taskId: widget.snap['taskId'],
                                      fullname: widget.snap['fullname'],
                                      address: widget.snap['address'],
                                      date: widget.snap['date'],
                                      time: widget.snap['time'],
                                    )));
                      },
                      child: Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                            color: orangeclr,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Text("View Offers",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: blueclr)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

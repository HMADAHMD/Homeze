import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeze_screens/resources/firestore_methods.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/utils.dart';
import 'package:http/http.dart';

class OfferCard extends StatefulWidget {
  final snap, title, fullname, address, date, time, taskId;

  final Function(String) deleted;
  OfferCard({
    super.key,
    required this.snap,
    required this.deleted,
    required this.title,
    required this.fullname,
    required this.address,
    required this.date,
    required this.time,
    required this.taskId,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  acceptOffer(
    String fullname,
    String address,
    String offerPrice,
    String title,
    String date,
    String time,
    String taskId,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().offerAccepted(
        fullname,
        address,
        offerPrice,
        title,
        date,
        time,
        widget.snap.data()['uid'],
        taskId,
      );
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        showSnackBar('Posted!', context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String fullname = widget.fullname;
    String address = widget.address;
    String offerPrice = widget.snap.data()['offerPrice'];
    String title = widget.title;
    String date = widget.date;
    String time = widget.time;
    //String tuid = widget.snap.data()['uid'];
    String taskId = widget.taskId;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
            color: grayclr, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: double.infinity,
                height: 49,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(widget.snap.data()['photoURL']),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.snap.data()['fullname'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: blueclr),
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: orangeclr,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    Text(widget.title),
                    Spacer(),
                    Text(
                      "Rs. ${widget.snap.data()['offerPrice']}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: blueclr,
                          fontWeight: FontWeight.bold),
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
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        widget.deleted(widget.snap.data()['offerId']);
                      },
                      child: Container(
                        height: 45,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Text("Decline"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        acceptOffer(fullname, address, offerPrice, title, date,
                            time, taskId);
                        print(title);
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        decoration: BoxDecoration(
                            color: orangeclr,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Text("Accept",
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

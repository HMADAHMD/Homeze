import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeze_screens/screens/offer_card.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/utils.dart';

class OfferScreen extends StatefulWidget {
  final title, taskId, fullname, address, date, time;
  const OfferScreen({
    super.key,
    required this.title,
    required this.taskId,
    required this.fullname,
    required this.address,
    required this.date,
    required this.time,
  });

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  declineOffer(String offerId) async {
    String res = 'Some error occured';
    setState(() {
      _isLoading = true;
    });
    try {
      await _firestore
          .collection('tasks')
          .doc(widget.taskId)
          .collection('offers')
          .doc(offerId)
          .delete();
      res = 'success';
      setState(() {
        _isLoading = false;
      });
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: orangeclr,
            )),
        elevation: 0,
        backgroundColor: skyclr,
        title: const Text(
          'Received Offers',
          style: TextStyle(
              color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .collection('offers')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: orangeclr,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => OfferCard(
              snap: snapshot.data!.docs[index],
              deleted: declineOffer,
              title: widget.title,
              fullname: widget.fullname,
              address: widget.address,
              date: widget.date,
              time: widget.time,
              taskId: widget.taskId,
            ),
          );
        },
      ),
    );
  }
}

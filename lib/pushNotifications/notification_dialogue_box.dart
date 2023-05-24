import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeze_screens/models/user_task_request.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/global.dart';

class NotificationDialogueBox extends StatefulWidget {
  UserTaskRequest? userTaskRequest;
  NotificationDialogueBox({super.key, this.userTaskRequest});

  @override
  State<NotificationDialogueBox> createState() =>
      _NotificationDialogueBoxState();
}

class _NotificationDialogueBoxState extends State<NotificationDialogueBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: skyclr,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),

            //title
            const Text(
              "Bargain Request",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22, color: blueclr),
            ),
            const SizedBox(height: 14.0),

            const Divider(
              height: 3,
              thickness: 3,
            ),
            const SizedBox(height: 14.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task: ${widget.userTaskRequest!.title!}',
                    style: const TextStyle(
                        color: blueclr,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Details: ${widget.userTaskRequest!.description!} dsbfjksbfkjsdjvklsdklvbsdlkbvkldbsnklbvjbsdvkjb kjdsbv',
                    style: const TextStyle(
                        color: blueclr,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Your Price: ${widget.userTaskRequest!.price!}',
                    style: const TextStyle(
                        color: orangeclr,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Text(
              'Bargain Price: ${widget.userTaskRequest!.bargainPrice!}',
              style: const TextStyle(
                  color: blueclr, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: skyclr,
                          elevation: 0),
                      onPressed: () {
                        // audioPlayer.pause();
                        // audioPlayer.stop();
                        // audioPlayer = AssetsAudioPlayer();

                        //cancel the rideRequest
                        declineTaskRequest(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Decline".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeclr,
                      ),
                      onPressed: () {
                        // audioPlayer.pause();
                        // audioPlayer.stop();
                        // audioPlayer = AssetsAudioPlayer();

                        //accept the rideRequest
                        acceptTaskRequest(context);
                        // Navigator.pop(context);
                      },
                      child: Text(
                        "Accept".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  declineTaskRequest(BuildContext context) {
    FirebaseDatabase.instance
            .ref()
            .child("tasksRequest")
            .child(widget.userTaskRequest!.taskRequestId!)
            .child("bargainPrice")
            .set('');
  }

  acceptTaskRequest(BuildContext context) async {
    // final DatabaseReference ref = FirebaseDatabase.instance.ref();
    // DataSnapshot dataSnapshot = await ref
    //     .child(widget.userTaskRequest!.taskRequestId!)
    //     .child('bargainPrice')
    //     .once();
    // final DatabaseReference ref = FirebaseDatabase.instance.ref();
    // DatabaseEvent event = await ref
    //     .child(widget.userTaskRequest!.taskRequestId!)
    //     .child('bargainPrice')
    //     .once();
    // DataSnapshot dataSnapshot = event.snapshot;
    // dynamic value = dataSnapshot.value;
    // print('the value is ' + value.toString());
    String bargainPrice = widget.userTaskRequest!.bargainPrice!;
    print(bargainPrice);
    FirebaseDatabase.instance
            .ref()
            .child("tasksRequest")
            .child(widget.userTaskRequest!.taskRequestId!)
            .child("finalPrice")
            .set(bargainPrice);

    //ref.child(widget.userTaskRequest!.taskRequestId!).child('finalPrice').set(value)
    // final auth = FirebaseAuth.instance;
    // User tasker = auth.currentUser!;
    // DatabaseReference tasker = FirebaseDatabase.instance
    //     .ref()
    //     .child('tasksRequests')
    //     .child(referTaskID!.toString())
    //     .child(seletedTaskerId!);

    // String getTaskRequestId = "";
    // FirebaseDatabase.instance
    //     .ref()
    //     .child("tasker")
    //     .child(tasker.toString())
    //     .child("taskerStatus")
    //     .once()
    //     .then((snap) {
    //   if (snap.snapshot.value != null) {
    //     getTaskRequestId = snap.snapshot.value.toString();
    //     print(getTaskRequestId);
    //   } else {
    //     Fluttertoast.showToast(msg: 'This task Request does not existss');
    //   }

    //   if (getTaskRequestId == widget.userTaskRequest!.taskRequestId) {
    //     // send driver to new ride screen
    //     FirebaseDatabase.instance
    //         .ref()
    //         .child("tasker")
    //         .child(tasker.toString())
    //         .child("taskerStatus")
    //         .set('accepted');
    //     FirebaseDatabase.instance
    //         .ref()
    //         .child("tasksRequest")
    //         .child(getTaskRequestId)
    //         .child("finalPrice")
    //         .set("bargainPrice");
    //   } else {
    //     Fluttertoast.showToast(msg: 'This task Request does not exists');
    //   }
    // });
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeze_screens/models/user_task_request.dart';
import 'package:homeze_screens/pushNotifications/notification_dialogue_box.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future initializeCloudMessaging(BuildContext context) async {
    // terminated
    messaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readUserTaskRequestInfo(remoteMessage!.data['tasksRequestId'], context);
      }
    });
    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readUserTaskRequestInfo(remoteMessage!.data['tasksRequestId'], context);
    });
    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readUserTaskRequestInfo(remoteMessage!.data['tasksRequestId'], context);
    });
  }

  readUserTaskRequestInfo(String userTaskRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child('tasksRequest')
        .child(userTaskRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        double workLocationlatitude = double.parse(
            (snapData.snapshot.value! as Map)['workLocation']['latitude']
                .toString());
        double workLocationlongitude = double.parse(
            (snapData.snapshot.value! as Map)['workLocation']['longitude']
                .toString());
        String userName =
            (snapData.snapshot.value! as Map)['userName'].toString();
        String userPhone =
            (snapData.snapshot.value! as Map)['userPhone'].toString();

        String workLocationAddress =
            (snapData.snapshot.value! as Map)['workLocationAddress'].toString();
        String tasktitle =
            (snapData.snapshot.value! as Map)['title'].toString();
        String taskdetails =
            (snapData.snapshot.value! as Map)['description'].toString();
        String askedprice =
            (snapData.snapshot.value! as Map)['askedPrice'].toString();
        String bargianPrice =
            (snapData.snapshot.value! as Map)['bargainPrice'].toString();
        String finalPrice =
            (snapData.snapshot.value! as Map)['finalPrice'].toString();

        String? mytaskRequestId = snapData.snapshot.key;
        UserTaskRequest userTaskRequest = UserTaskRequest();
        userTaskRequest.workLocationLatLng =
            LatLng(workLocationlatitude, workLocationlongitude);
        userTaskRequest.userName = userName;
        userTaskRequest.userPhone = userPhone;
        userTaskRequest.workLocationAddress = workLocationAddress;
        userTaskRequest.taskRequestId = mytaskRequestId;
        userTaskRequest.title = tasktitle;
        userTaskRequest.description = taskdetails;
        userTaskRequest.price = askedprice;
        userTaskRequest.bargainPrice = bargianPrice;
        userTaskRequest.finalPrice = finalPrice;

        showDialog(
            context: context,
            builder: (BuildContext context) =>
                NotificationDialogueBox(userTaskRequest: userTaskRequest));
      } else {
        Fluttertoast.showToast(msg: 'this task request id does not exists');
      }
    });
  }

  Future generateTokens() async {
    final auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    String? registrationToken = await messaging.getToken();
    print("FCM token");
    print(registrationToken);
    FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.uid)
        .child('token')
        .set(registrationToken);
    messaging.subscribeToTopic('allTaskers');
    messaging.subscribeToTopic('allUsers');
  }
}

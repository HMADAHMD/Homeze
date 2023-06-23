import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static sendNotificationToTaskerNow(
      String deviceRegistrationToken, String userTaskRequestId, context) async {
    var destinationAddress = Provider.of<UserProvider>(context, listen: false).useraddress;
    //notification header
    Map<String, String> headerNotification = {
      "Content-Type": "application/json",
      "Authorization": cloudMessagingServerToken,
    };

    //notification body
    Map<String, String> bodyNotification = {
      "body": "Destination: $destinationAddress",
      "title": "New Task Request",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": 1,
      "status": "done",
      "tasksRequestId": userTaskRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat));
  }
}

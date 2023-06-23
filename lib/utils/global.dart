import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:homeze_screens/models/user_data.dart';
import 'package:homeze_screens/models/user_model.dart';

List dList = [];
UserModel? userModelInfo;
UserData onlineUserData = UserData();
String? seletedTaskerId = '';
DatabaseReference? referTaskID;
String cloudMessagingServerToken =
    "key=AAAAQ3Gq2f8:APA91bHl_H63FMkhhEZKaooSZyl5tPNjf2RjXS62_JAwf1ZPDtLCkJFOLZeghG9bQZcoPHJkmjM9hrmBwIwo_-hTU2MBrUvIYo936iyoEeKT9V3fp7ow5udyJNQNgqCRzhSHj-1ziS8r";
// "key=AAAAQ3Gq2f8:APA91bHl_H63FMkhhEZKaooSZyl5tPNjf2RjXS62_JAwf1ZPDtLCkJFOLZeghG9bQZcoPHJkmjM9hrmBwIwo_-hTU2MBrUvIYo936iyoEeKT9V3fp7ow5udyJNQNgqCRzhSHj-1ziS8r";
void restartApp() async {
  const platform = const MethodChannel('com.example.myapp/restart');
  try {
    await platform.invokeMethod('restart');
  } on PlatformException catch (e) {
    print('Failed to restart app: ${e.message}');
  }
}

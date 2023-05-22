import 'package:flutter/services.dart';
import 'package:homeze_screens/models/user_model.dart';

List dList = [];
UserModel? userModelInfo;
void restartApp() async {
  const platform = const MethodChannel('com.example.myapp/restart');
  try {
    await platform.invokeMethod('restart');
  } on PlatformException catch (e) {
    print('Failed to restart app: ${e.message}');
  }
}

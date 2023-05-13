import 'package:flutter/material.dart';
import 'package:homeze_screens/models/directions.dart';
import 'package:homeze_screens/models/user.dart';
import 'package:homeze_screens/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
  //..................................Direction Provider
  Directions? useraddress;
  void updateUserAddress(Directions userAddress) {
    useraddress = userAddress;
  }

}

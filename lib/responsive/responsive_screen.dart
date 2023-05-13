import 'package:flutter/material.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/responsive/mobile_screen.dart';
import 'package:homeze_screens/responsive/web_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:provider/provider.dart';

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > dimensions) {
          return WebScreen();
        }
        return MobileScreen();
      },
    );
  }
}

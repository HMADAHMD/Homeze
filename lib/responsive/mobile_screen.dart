import 'package:flutter/material.dart';
import 'package:homeze_screens/screens/create_task.dart';
import 'package:homeze_screens/screens/home_screen.dart';
import 'package:homeze_screens/screens/order_screen.dart';
import 'package:homeze_screens/screens/profile_screen.dart';
import 'package:homeze_screens/screens/service_screen.dart';
import 'package:homeze_screens/utils/bottom_tabs.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';

class MobileScreen extends StatefulWidget {
  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  //method to get access to the collection and then getting the username

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationTabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: blueclr,
        unselectedItemColor: Colors.grey[750],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            label: 'Handyman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

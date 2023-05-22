import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:homeze_screens/screens/create_task.dart';
import 'package:homeze_screens/screens/home_screen.dart';
import 'package:homeze_screens/screens/order_screen.dart';
import 'package:homeze_screens/screens/post_job.dart';
import 'package:homeze_screens/screens/profile_screen.dart';
import 'package:homeze_screens/screens/search_handyman.dart';
import 'package:homeze_screens/screens/service_screen.dart';

List<Widget> navigationTabs = [
  HomeScreen(),
  ServiceScreen(),
  SearchHandyman(),
  OrderScreen(),
  ProfileScreen()
];

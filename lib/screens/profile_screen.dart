import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/screens/login_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';
import 'package:homeze_screens/models/user.dart' as model;
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  logoutButton() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                color: grayclr,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullname,
                          style: TextStyle(
                              fontSize: 30,
                              color: orangeclr,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(fontSize: 15, color: blueclr),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(user.number,
                            style: TextStyle(fontSize: 15, color: blueclr)),
                      ],
                    )
                  ],
                ),
              )),
          Container(
            height: 1,
            color: blueclr,
          ),
          Flexible(
              flex: 3,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      ListItems(
                          listName: 'Account',
                          listIcon: const Icon(
                            Icons.person,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'About Us',
                          listIcon: const Icon(
                            Icons.info,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'Invite Friends',
                          listIcon: const Icon(
                            Icons.share,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'Wallet',
                          listIcon: const Icon(
                            Icons.wallet,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'Privacy Policy',
                          listIcon: const Icon(
                            Icons.lock_outline_rounded,
                            size: 40,
                          )),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Logout'),
                                content:
                                    Text('Are you sure you want to Logout?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Perform some action
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: blueclr),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      logoutButton();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListItems(
                            listName: 'Log Out',
                            listIcon: const Icon(
                              Icons.logout_outlined,
                              size: 40,
                            )),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}

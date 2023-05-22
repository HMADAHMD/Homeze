import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/screens/chatrooms_screen.dart';
import 'package:homeze_screens/screens/map_screen.dart';
import 'package:homeze_screens/screens/profile_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';
import 'package:provider/provider.dart';
import 'package:homeze_screens/models/user.dart' as model;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
  }

  //get data from firebasefirestore
  // showData() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   User currentUser = _auth.currentUser!;
  //   final userRef = _firestore.collection('users').doc(currentUser.uid);
  //   await userRef.get().then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       Map<String, dynamic> userData =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       String userName = userData['fullname'];
  //       String email = userData['email'];
  //       String photo = userData['photoURL'];
  //       setState(() {
  //         _fullname = userName;
  //         _email = email;
  //         _photoURL = photo;
  //       });
  //     }
  //   });
  // }
  Set<Marker> markersSet = {};

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: skyclr,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: blueclr,
              ));
        }),
        title: const Text(
          'Dashboard',
          style: TextStyle(
              color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatroomsList()));
              },
              icon: const Icon(
                Icons.chat_rounded,
                color: blueclr,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapScreen()));
              },
              icon: const Icon(
                Icons.location_pin,
                color: blueclr,
              ))
        ],
        elevation: 1,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: skyclr),
              accountName: Text(
                user.fullname,
                style: TextStyle(color: blueclr),
              ),
              accountEmail: Text(
                user.email,
                style: TextStyle(color: blueclr),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
              ),
            ),
            ListItems(
                listName: 'Account',
                listIcon: const Icon(
                  Icons.person,
                  size: 30,
                )),
            ListItems(
                listName: 'About Us',
                listIcon: const Icon(
                  Icons.info,
                  size: 30,
                )),
            ListItems(
                listName: 'Invite Friends',
                listIcon: const Icon(
                  Icons.share,
                  size: 30,
                )),
            ListItems(
                listName: 'Wallet',
                listIcon: const Icon(
                  Icons.wallet,
                  size: 30,
                )),
            ListItems(
                listName: 'Privacy Policy',
                listIcon: const Icon(
                  Icons.lock_outline_rounded,
                  size: 30,
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: ListItems(
                  listName: 'Profile',
                  listIcon: const Icon(
                    Icons.person,
                    size: 30,
                  )),
            ),
          ],
        ),
      ),
      body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: skyclr,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi! ${user.fullname}",
                                style: TextStyle(
                                    color: orangeclr,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "What service do\nyou need?",
                                style: TextStyle(
                                    color: blueclr,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                      color: blueclr,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: orangeclr,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 15.0, left: 20.0),
                          child: Image.asset('assets/images/handyman.webp'),
                        )
                      ],
                    ),
                  ),

                  // this is the container for services
                  Categories(
                    type: 'Category',
                    isCheck: false,
                  ),

                  // this is the third container of popular services
                  Container(
                    height: 180,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Popular Services",
                            style: TextStyle(
                                color: blueclr,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: grayclr,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          child: Image.asset(
                                              'assets/images/cleaning2.png'),
                                        )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Flexible(
                                        flex: 2,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Home Cleaning',
                                                        style: TextStyle(
                                                            color: blueclr,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Spacer(),
                                                      Text('4.7')
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('Michele Richard'),
                                                      Spacer(),
                                                      Text('⭐')
                                                    ],
                                                  ),
                                                  Text(
                                                    "Rs.25",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: blueclr,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ]),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Subscription",
                            style: TextStyle(
                                color: blueclr,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: grayclr,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          child: Image.asset(
                                              'assets/images/maintain.webp'),
                                        )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Flexible(
                                        flex: 2,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Maintained by Homeze',
                                                    style: TextStyle(
                                                        color: blueclr,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'See all plans',
                                                        style: TextStyle(
                                                            color: orangeclr),
                                                      ))
                                                ]),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}

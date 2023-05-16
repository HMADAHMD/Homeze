import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeze_screens/models/user.dart' as model;
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/resources/firestore_methods.dart';
import 'package:homeze_screens/screens/chat_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:provider/provider.dart';

class ChatroomsList extends StatefulWidget {
  const ChatroomsList({super.key});

  @override
  State<ChatroomsList> createState() => _ChatroomsListState();
}

class _ChatroomsListState extends State<ChatroomsList> {
  Stream<QuerySnapshot>? chatRooms;
  String? myName;

  Widget chatRoomsList() {
    model.User user = Provider.of<UserProvider>(context).getUser;
    myName = user.fullname;
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final userName = data["chatRoomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(myName!.toString(), "");
                  final chatRoomId = data["chatRoomId"];
                  return ChatRoomsTile(
                      userName: userName, chatRoomId: chatRoomId);
                  // return ChatRoomsTile(
                  //   userName: snapshot.data.documents[index].data['chatRoomId']
                  //       .toString()
                  //       .replaceAll("_", "")
                  //       .replaceAll(user.fullname.toString(), ""),
                  //   chatRoomId:
                  //       snapshot.data.documents[index].data["chatRoomId"],
                  // );
                })
            : Container();
      },
    );
  }

  getUserInfogetChats() async {
    //Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    model.User user = Provider.of<UserProvider>(context, listen: false).getUser;
    FirestoreMethods().getUserChats(user.fullname).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${user.fullname}");
      });
    });
  }

  // getUserInfogetChats() async {
  //   //Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  //   model.Tasker tasker =
  //       Provider.of<TaskerProvider>(context, listen: false).getTasker;
  //   FirestoreMethods().getUserChats(tasker.fullname).then((snapshots) {
  //     setState(() {
  //       chatRooms = snapshots;
  //       print("we got the data + ${chatRooms} this is name " + tasker.fullname);
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();
    getUserInfogetChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: skyclr,
        title: const Text(
          'Chats',
          style: TextStyle(
              color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: orangeclr,
            )),
      ),
      body: chatRoomsList(),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: skyclr,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: darkgray, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blueclr,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: orangeclr,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}

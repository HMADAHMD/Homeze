import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeze_screens/models/active_nearby_taskers.dart';
import 'package:homeze_screens/resources/goefire_assistant.dart';
import 'package:homeze_screens/screens/map_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';

class CreateTask extends StatefulWidget {
  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _infoController = TextEditingController();
  final _priceController = TextEditingController();
  final _titleController = TextEditingController();
  Uint8List? _image;
  String _taskPrice = '0';

  List<ActiveNearbyTaskers> nearbyAvailableTaskers = [];

  myAlertView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add price'),
          content: TextField(
            controller: _priceController,
            autocorrect: false,
            keyboardType: TextInputType.number,
            cursorColor: orangeclr,
            decoration: const InputDecoration(
                hintText: "add your price",
                fillColor: grayclr,
                filled: true,
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: darkgray)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: orangeclr)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: orangeclr))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _taskPrice = _priceController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: blueclr),
              ),
            ),
          ],
        );
      },
    );
  }

  void addPostImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  saveTaskInformation() {
    nearbyAvailableTaskers = GeofireAssistant.activeNearbyTaskersList;
    searchNearbyTasker();
  }

  searchNearbyTasker() async {
    if (nearbyAvailableTaskers.length == 0) {
      
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: skyclr,
          title: const Text(
            'Create a Task',
            style: TextStyle(
                color: blueclr, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Text(
                'Get anything done in minutes',
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w400, color: blueclr),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Title',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w400, color: blueclr),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: _titleController,
                cursorColor: orangeclr,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: grayclr,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: darkgray)),
                    errorBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeclr)),
                    hintText: 'e.g. fix my car'),
              ),
              Text(
                'Details',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w400, color: blueclr),
              ),
              Container(
                  height: 160,
                  child: TextField(
                    controller: _infoController,
                    autocorrect: false,
                    cursorColor: orangeclr,
                    maxLines: 6,
                    decoration: InputDecoration(
                        fillColor: grayclr,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: darkgray),
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: orangeclr)),
                        hintText: 'provide details about your problem'),
                  )),
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: skyclr),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      addPostImage();
                    },
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            fit: BoxFit.fill,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/upload.png',
                                height: 70,
                              ),
                              Text(
                                'upload image',
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: darkgray,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Add Your Price: ',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                        )),
                    Spacer(),
                    GestureDetector(
                      onTap: myAlertView,
                      child: Container(
                          decoration: BoxDecoration(
                              color: darkgray,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Rs. ${_taskPrice}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              MyTextButtons(
                  name: 'Search',
                  myOnPressed: () {
                    if (_taskPrice != '0' && _image != null) {
                      saveTaskInformation();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapScreen()));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please provide all details correctly");
                    }
                  })
            ],
          ),
        ));
  }
}

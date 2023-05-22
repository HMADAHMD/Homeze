import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/resources/firestore_methods.dart';
import 'package:homeze_screens/screens/map_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';
import 'package:http/retry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:homeze_screens/models/user.dart' as model;
import '../utils/utils.dart';

class PostJob extends StatefulWidget {
  const PostJob({super.key});

  @override
  State<PostJob> createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _priceController = TextEditingController();
  String _taskPrice = '0';
  Uint8List? _image;
  bool _isLoading = false;
  String? userProvider;

  DateTime _selectedDate = DateTime.now();
  String? dateSelected;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? timeSelected;

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        String _selectedDateString = DateFormat('yMd').format(_selectedDate);
        dateSelected = _selectedDateString;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        String _selectedTimeString = _selectedTime.format(context);
        timeSelected = _selectedTimeString;
      });
    }
  }

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

  // pick the image form the gallery
  void addPostImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  postTask(
    String fullname,
    String uid,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadTask(
          _detailController.text,
          _image!,
          uid,
          fullname,
          _titleController.text,
          userProvider!,
          dateSelected!,
          timeSelected!,
          _priceController.text);
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        showSnackBar('Posted!', context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = "";
    _timeController.text = "";
    print(_dateController);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context).useraddress!.locationName;
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: skyclr,
        title: const Text(
          'Post Job',
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
          child: Column(
            children: [
              // ..............................address container
              Container(
                decoration: BoxDecoration(
                    color: orangeclr, borderRadius: BorderRadius.circular(10)),
                height: 50,
                width: double.infinity,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => MapScreen()));
                    },
                    child: Text(
                      Provider.of<UserProvider>(context).useraddress != null
                          ? Provider.of<UserProvider>(context)
                              .useraddress!
                              .locationName!
                          : 'My Address',
                      style: TextStyle(color: blueclr),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              // ..............................title container
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title'),
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
                          hintText: 'e.g. fix my toilet'),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // ..............................details container
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Details'),
                    const SizedBox(
                      height: 2,
                    ),
                    TextField(
                      controller: _detailController,
                      cursorColor: orangeclr,
                      maxLines: 5,
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
                          hintText:
                              'e.g. fix my wash basin and toilet seat is not working properly...'),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // ..............................date & time container
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: grayclr),
                height: 130,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Text("${_selectedDate.toLocal()}".split(' ')[0]),
                              Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: skyclr,
                                    borderRadius: BorderRadius.circular(10)),
                                child: GestureDetector(
                                    onTap: () => selectDate(),
                                    child: Center(
                                        child: Text(
                                      "${_selectedDate.toLocal()}"
                                              .split(' ')[0] +
                                          '   ⬇️',
                                      style: TextStyle(fontSize: 20),
                                    ))),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: skyclr,
                                    borderRadius: BorderRadius.circular(10)),
                                child: GestureDetector(
                                    onTap: () => selectTime(),
                                    child: Center(
                                        child: Text(
                                      "${_selectedTime.format(context)}" +
                                          '   ⬇️',
                                      style: TextStyle(fontSize: 20),
                                    ))),
                              )
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 1,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // ..............................price container
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: grayclr,
                  ),
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                              Spacer(),
                              GestureDetector(
                                onTap: myAlertView,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: darkgray,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'Rs. ${_taskPrice}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row()
                      ],
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),
              // ..............................post task container
              Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: orangeclr,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: blueclr,
                          )
                        : MyTextButtons(
                            name: 'Post',
                            myOnPressed: ()async {
                              postTask(user.fullname, user.uid);
                              await Future.delayed(Duration(microseconds: 3));
                              Navigator.pop(context);
                            },
                          ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeze_screens/models/active_nearby_taskers.dart';
import 'package:homeze_screens/provider/user_provider.dart';
import 'package:homeze_screens/resources/goefire_assistant.dart';
import 'package:homeze_screens/resources/http_response.dart';
import 'package:homeze_screens/screens/active_taskers_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/global.dart';
import 'package:homeze_screens/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:homeze_screens/models/user.dart' as model;

class SearchHandyman extends StatefulWidget {
  // Set<Marker> markersSet;
  SearchHandyman({super.key});

  @override
  State<SearchHandyman> createState() => _SearchHandymanState();
}

class _SearchHandymanState extends State<SearchHandyman> {
  final _infoController = TextEditingController();
  final _priceController = TextEditingController();
  final _titleController = TextEditingController();
  Uint8List? _image;
  String taskCost = '0';

  List<ActiveNearbyTaskers> nearbyAvailableTaskers = [];
  DatabaseReference? refTaskRequest;
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
                  taskCost = _priceController.text;
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
    model.User user = Provider.of<UserProvider>(context, listen: false).getUser;
    // 1. save task request in database
    refTaskRequest =
        FirebaseDatabase.instance.ref().child('tasksRequest').push();

    var workLocation =
        Provider.of<UserProvider>(context, listen: false).useraddress;

    Map workLocationMap = {
      'latitude': workLocation!.locationLatitude.toString(),
      'longitude': workLocation!.locationLongitude.toString(),
    };

    Map userInfoMap = {
      'workLocation': workLocationMap,
      'time': DateTime.now().toString(),
      'userName': user.fullname,
      'userPhone': user.number,
      'workLocationAddress': workLocation.locationName,
      'taskerId': 'waiting',
      'title': _titleController.text,
      'description': _infoController.text,
      'askedPrice': taskCost,
      'userId': user.uid,
      'bargainPrice': "",
      'finalPrice': "",
    };
    refTaskRequest!.set(userInfoMap);
    referTaskID = refTaskRequest!;

    nearbyAvailableTaskers = GeofireAssistant.activeNearbyTaskersList;
    searchNearbyTasker();
  }

  searchNearbyTasker() async {
    if (nearbyAvailableTaskers.length == 0) {
      refTaskRequest!.remove();
      setState(() {
        markersSet.clear();
        circlesSet.clear();
      });
      Fluttertoast.showToast(msg: 'No Tasker Available');
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        restartApp();
      }
      return;
    }
    await retrieveOnlineTaskers(nearbyAvailableTaskers);
    var response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActiveTaskersScreen(
                refTaskRequest: refTaskRequest, taskCost: taskCost)));

    if (response == "taskerSelected") {
      FirebaseDatabase.instance
          .ref()
          .child('tasker')
          .child(seletedTaskerId!)
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          //send notifocaiton to that specific tasker
          sendNotificationToTaskerNow(seletedTaskerId!);
        } else {
          Fluttertoast.showToast(msg: 'This tasker do not exist');
        }
      });
    }
  }

  sendNotificationToTaskerNow(String selectedTaskerId) {
    FirebaseDatabase.instance
        .ref()
        .child('tasker')
        .child(seletedTaskerId!)
        .child('taskerStatus')
        .set(refTaskRequest!.key);
  }

  retrieveOnlineTaskers(List onlineTaskers) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('tasker');
    for (int i = 0; i < onlineTaskers.length; i++) {
      await ref
          .child(onlineTaskers[i].taskerId.toString())
          .once()
          .then((dataSnapshot) {
        var taskerKeyInfo = dataSnapshot.snapshot.value;
        dList.add(taskerKeyInfo);
        print('tasker info' + dList.toString());
      });
    }
  }

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  GoogleMapController? newMapController;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  bool activeNearbyTaskersLoaded = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.33802241013048, 74.36075742817873),
    zoom: 14.4746,
  );

  Position? userPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  checkPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locatePosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userPosition = currentPosition;

    LatLng LatLngPosition =
        LatLng(userPosition!.latitude, userPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: LatLngPosition, zoom: 14);

    newMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String readableAddress =
        await HttpResponse.responseGot(userPosition!, context);
    print('Address: ' + readableAddress);

    initializeGeofireListener();
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addCustomMarker() {
    ImageConfiguration imageConfig =
        const ImageConfiguration(devicePixelRatio: 2.5);
    //createLocalImageConfiguration(context, size: const Size(1, 1));
    BitmapDescriptor.fromAssetImage(imageConfig, 'assets/images/tasker.png')
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    //markersSet = widget.markersSet;
  }

  @override
  Widget build(BuildContext context) {
    addCustomMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            //markers: widget.markersSet,
            markers: markersSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              locatePosition();
              newMapController = controller;
              _mapController.complete(controller);
              newMapController = controller;
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(200, 240, 249, 254),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: 180,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      cursorColor: orangeclr,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: grayclr,
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: grayclr)),
                          errorBorder: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: orangeclr)),
                          hintText: 'e.g. fix my car'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextField(
                      controller: _infoController,
                      autocorrect: false,
                      cursorColor: orangeclr,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          fillColor: grayclr,
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: grayclr)),
                          errorBorder: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: orangeclr)),
                          hintText: 'provide details about your problem'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        // Expanded(
                        //     flex: 1,
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         addPostImage();
                        //       },
                        //       child: Container(
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //             color: darkgray,
                        //             borderRadius: BorderRadius.circular(10)),
                        //         child: _image != null
                        //             ? Image.memory(
                        //                 _image!,
                        //                 fit: BoxFit.fill,
                        //               )
                        //             : Center(child: Text('Add Image')),
                        //       ),
                        //     )),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: myAlertView,
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: darkgray,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Rs. ${taskCost}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  if (taskCost != '0') {
                                    saveTaskInformation();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please provide all details correctly");
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: orangeclr,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                      child: Text(
                                    "Search",
                                    style: TextStyle(
                                        color: blueclr,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  )),
                                )))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void restartApp() async {
    const platform = const MethodChannel('com.example.myapp/restart');
    try {
      await platform.invokeMethod('restart');
    } on PlatformException catch (e) {
      print('Failed to restart app: ${e.message}');
    }
  }

  initializeGeofireListener() {
    Geofire.initialize('activeTaskers');
    Geofire.queryAtLocation(
            userPosition!.latitude, userPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            ActiveNearbyTaskers activeNearbyTaskers = ActiveNearbyTaskers();
            activeNearbyTaskers.locationlatitide = map['latitude'];
            activeNearbyTaskers.locationlongitude = map['longitude'];
            activeNearbyTaskers.taskerId = map['key'];
            GeofireAssistant.activeNearbyTaskersList.add(activeNearbyTaskers);
            displayActiveTaskers();
            break;

          case Geofire.onKeyExited:
            GeofireAssistant.deleteTaskerFromList(map['key']);
            displayActiveTaskers();
            break;

          case Geofire.onKeyMoved:
            ActiveNearbyTaskers activeNearbyTaskers = ActiveNearbyTaskers();
            activeNearbyTaskers.locationlatitide = map['latitude'];
            activeNearbyTaskers.locationlongitude = map['longitude'];
            activeNearbyTaskers.taskerId = map['key'];
            GeofireAssistant.updateNearbyTaskerLocation(activeNearbyTaskers);
            displayActiveTaskers();
            break;

          case Geofire.onGeoQueryReady:
            displayActiveTaskers();

            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveTaskers() {
    setState(() {
      //widget.markersSet.clear();
      markersSet.clear();
      circlesSet.clear();
      Set<Marker> taskersMarkerSet = Set<Marker>();
      for (ActiveNearbyTaskers eachTasker
          in GeofireAssistant.activeNearbyTaskersList) {
        LatLng eachTaskerPostion =
            LatLng(eachTasker.locationlatitide!, eachTasker.locationlongitude!);
        Marker marker = Marker(
            markerId: MarkerId(eachTasker.taskerId!),
            position: eachTaskerPostion,
            icon: markerIcon,
            rotation: 360);
        taskersMarkerSet.add(marker);
      }
      // setState(() {
      //   markersSet = taskersMarkerSet;
      // });
      setState(() {
        //widget.markersSet = taskersMarkerSet;
        markersSet = taskersMarkerSet;
      });
      //widget.markersSet = taskersMarkerSet;
      // if (mounted) {
      //   setState(() {
      //     // No need to update markersSet here
      //   });
      // }
    });
  }
}

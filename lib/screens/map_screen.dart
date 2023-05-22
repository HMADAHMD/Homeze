import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeze_screens/models/active_nearby_taskers.dart';
import 'package:homeze_screens/resources/goefire_assistant.dart';
import 'package:homeze_screens/resources/http_response.dart';
import 'package:homeze_screens/utils/constants.dart';

class MapScreen extends StatefulWidget {
  // Set<Marker> markersSet;
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  GoogleMapController? newMapController;
  // Set<Marker> markersSet = {};
  // Set<Circle> circlesSet = {};
  // bool activeNearbyTaskersLoaded = false;

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

    //initializeGeofireListener();
  }

  // BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  // void addCustomMarker() {
  //   ImageConfiguration imageConfig =
  //       const ImageConfiguration(devicePixelRatio: 2.5);
  //   //createLocalImageConfiguration(context, size: const Size(1, 1));
  //   BitmapDescriptor.fromAssetImage(imageConfig, 'assets/images/tasker.png')
  //       .then(
  //     (icon) {
  //       setState(() {
  //         markerIcon = icon;
  //       });
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    checkPermission();
    //markersSet = widget.markersSet;
  }

  @override
  Widget build(BuildContext context) {
    //addCustomMarker();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: skyclr,
        title: Text(
          'My Location',
          style: TextStyle(
              color: blueclr, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: orangeclr,
            )),
        elevation: 1,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              //markers: markersSet,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                locatePosition();
                newMapController = controller;
                _mapController.complete(controller);
                newMapController = controller;
              },
            )
          ],
        ),
      ),
    );
  }

  // initializeGeofireListener() {
  //   Geofire.initialize('activeTaskers');
  //   Geofire.queryAtLocation(
  //           userPosition!.latitude, userPosition!.longitude, 10)!
  //       .listen((map) {
  //     print(map);
  //     if (map != null) {
  //       var callBack = map['callBack'];

  //       //latitude will be retrieved from map['latitude']
  //       //longitude will be retrieved from map['longitude']

  //       switch (callBack) {
  //         case Geofire.onKeyEntered:
  //           ActiveNearbyTaskers activeNearbyTaskers = ActiveNearbyTaskers();
  //           activeNearbyTaskers.locationlatitide = map['latitude'];
  //           activeNearbyTaskers.locationlongitude = map['longitude'];
  //           activeNearbyTaskers.taskerId = map['key'];
  //           GeofireAssistant.activeNearbyTaskersList.add(activeNearbyTaskers);
  //           displayActiveTaskers();
  //           break;

  //         case Geofire.onKeyExited:
  //           GeofireAssistant.deleteTaskerFromList(map['key']);
  //           displayActiveTaskers();
  //           break;

  //         case Geofire.onKeyMoved:
  //           ActiveNearbyTaskers activeNearbyTaskers = ActiveNearbyTaskers();
  //           activeNearbyTaskers.locationlatitide = map['latitude'];
  //           activeNearbyTaskers.locationlongitude = map['longitude'];
  //           activeNearbyTaskers.taskerId = map['key'];
  //           GeofireAssistant.updateNearbyTaskerLocation(activeNearbyTaskers);
  //           displayActiveTaskers();
  //           break;

  //         case Geofire.onGeoQueryReady:
  //           displayActiveTaskers();

  //           break;
  //       }
  //     }

  //     setState(() {});
  //   });
  // }

  // displayActiveTaskers() {
  //   setState(() {
  //     //widget.markersSet.clear();
  //     markersSet.clear();
  //     circlesSet.clear();
  //     Set<Marker> taskersMarkerSet = Set<Marker>();
  //     for (ActiveNearbyTaskers eachTasker
  //         in GeofireAssistant.activeNearbyTaskersList) {
  //       LatLng eachTaskerPostion =
  //           LatLng(eachTasker.locationlatitide!, eachTasker.locationlongitude!);
  //       Marker marker = Marker(
  //           markerId: MarkerId(eachTasker.taskerId!),
  //           position: eachTaskerPostion,
  //           icon: markerIcon,
  //           rotation: 360);
  //       taskersMarkerSet.add(marker);
  //     }
  //     // setState(() {
  //     //   markersSet = taskersMarkerSet;
  //     // });
  //     setState(() {
  //       //widget.markersSet = taskersMarkerSet;
  //       markersSet = taskersMarkerSet;
  //     });
  //     //widget.markersSet = taskersMarkerSet;
  //     // if (mounted) {
  //     //   setState(() {
  //     //     // No need to update markersSet here
  //     //   });
  //     // }
  //   });
  // }
}

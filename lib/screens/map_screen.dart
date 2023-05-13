import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeze_screens/resources/http_response.dart';
import 'package:homeze_screens/utils/constants.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  GoogleMapController? newMapController;

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
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
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
}

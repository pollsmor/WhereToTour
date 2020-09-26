import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'CountriesAPI.dart';

class CountryPage extends StatelessWidget {
  final Country country;

  CountryPage({this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                MyMap(latitude: country.latitude, longitude: country.longitude),
          ),
        ],
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  MyMap({this.latitude, this.longitude});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _location;

  @override
  void initState() {
    _location = CameraPosition(
        target: LatLng(widget.latitude, widget.longitude), zoom: 5);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _location,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}

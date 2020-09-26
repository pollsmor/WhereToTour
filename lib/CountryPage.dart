import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            child: SvgPicture.network(
                              country.flagURL,
                              semanticsLabel: country.name,
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                child: Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(),
                                    height: 64.0,
                                    width: 32.0,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                            ),
                            width: 64.0,
                            height: 64.0,
                            padding: EdgeInsets.all(8.0),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  country.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star_border),
                                  Text(country.capital),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Top level domain"),
                            Text(country.tld),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Calling code"),
                            Text("+" + country.callingCode),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Population"),
                            Text("${country.population}"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Area"),
                            Text("${country.area}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Languages"),
                            Text("${country.languages}"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Currencies"),
                            Text("${country.currencies}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: MyMap(country.latitude, country.longitude),
          ),
        ],
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  double latitude;
  double longitude;

  MyMap(double latitude, double longitude) {
    if (latitude == null) latitude = 0;
    if (longitude == null) longitude = 0;

    this.latitude = latitude;
    this.longitude = longitude;
  }

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

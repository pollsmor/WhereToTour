import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CountriesAPI.dart';

class CountryPage extends StatelessWidget {
  final Country country;

  CountryPage({this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blueAccent[700]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey[100],
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(4.0))),
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
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star_border),
                                  Text(
                                    country.capital,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
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
                            Text(
                              "Top level domain",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.pink,
                              ),
                            ),
                            Text(country.tld),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Calling code",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            ),
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
                            Text(
                              "Population",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.teal,
                              ),
                            ),
                            Text("${country.population}"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Area",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                              ),
                            ),
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
                            Text(
                              "Languages",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.indigoAccent,
                              ),
                            ),
                            Text("${country.languages}"),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2.0, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Currencies",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.brown,
                                  ),
                                ),
                                Text("${country.currencies}"),
                              ],
                            ),
                          ),
                          onTap: () {
                            _launchURL(country.currencies[0] + " to USD");
                          },
                        ),
                      ],
                    ),
                  ),
                  country.hardToVisit
                      ? Text(
                          "This country may be particularly difficult to visit for U.S. citizens.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
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

  _launchURL(String query) async {
    String url = "https://www.google.com/search?q=" + query;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

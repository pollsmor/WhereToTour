import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'CountriesAPI.dart';

class HomePage extends StatefulWidget {
  final String region;

  HomePage({this.region});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Country>> countries;
  bool lowDensity, medDensity, highDensity;

  @override
  void initState() {
    countries = fetchCountries(widget.region);
    lowDensity = true;
    medDensity = true;
    highDensity = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WhereToTour')),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  child: RegionPicker(),
                  color: Colors.white,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Population density"),
                      GestureDetector(
                        child: Container(
                          child: Text(
                            "Low",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.all(8.0),
                          width: 72.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lowDensity ? Colors.green : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            lowDensity = !lowDensity;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text(
                            "Medium",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.all(8.0),
                          width: 72.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: medDensity
                                ? Colors.orangeAccent[700]
                                : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            medDensity = !medDensity;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text(
                            "High",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.all(8.0),
                          width: 72.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: highDensity ? Colors.red : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            highDensity = !highDensity;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: CountryCard(country: snapshot.data[index]),
                        padding: EdgeInsets.all(8.0),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: !(snapshot.hasError)
                  ? CircularProgressIndicator()
                  : Container(
                      child: Text('${snapshot.error}'),
                      padding: EdgeInsets.all(8.0),
                    ),
            );
          }
        },
      ),
    );
  }
}

class RegionPicker extends StatefulWidget {
  RegionPicker();

  @override
  _RegionPickerState createState() => _RegionPickerState();
}

class _RegionPickerState extends State<RegionPicker> {
  String region = 'All';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Select a region:  "),
        DropdownButton<String>(
          value: region,
          icon: Icon(Icons.language),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              region = newValue;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(region: region),
                  ));
            });
          },
          items: <String>[
            'All',
            'Americas',
            'Europe',
            'Oceania',
            'Asia',
            'Africa'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CountryCard extends StatelessWidget {
  final Country country;

  CountryCard({this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: SvgPicture.network(
                country.flagURL,
                semanticsLabel: country.name,
                placeholderBuilder: (BuildContext context) => Container(
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
              margin: EdgeInsets.all(8.0),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
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
          )
        ],
      ),
      height: 64.0,
    );
  }
}

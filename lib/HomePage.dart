import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'CountriesAPI.dart';
import 'CountryPage.dart';

String density = "All";
String region = "All";

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Country>> countries;

  @override
  void initState() {
    countries = fetchCountries(region);

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
                  child: DensityPicker(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(density);
                      if (snapshot.data[index].area == null) {
                        return Container();
                      }

                      if (density == "Low") {
                        if (snapshot.data[index].population /
                                snapshot.data[index].area >
                            50) {
                          print("xd");
                          return Container();
                        } else {
                          return Container(
                            child: CountryCard(country: snapshot.data[index]),
                            padding: EdgeInsets.all(4.0),
                          );
                        }
                      } else if (density == "Medium") {
                        if (snapshot.data[index].population / snapshot.data[index].area <= 50 ||
                            snapshot.data[index].population / snapshot.data[index].area >= 200) {
                          return Container();
                        } else {
                          return Container(
                            child: CountryCard(country: snapshot.data[index]),
                            padding: EdgeInsets.all(4.0),
                          );
                        }
                      } else if (density == "High") {
                        if (snapshot.data[index].population / snapshot.data[index].area < 200) {
                          return Container();
                        } else {
                          return Container(
                            child: CountryCard(country: snapshot.data[index]),
                            padding: EdgeInsets.all(4.0),
                          );
                        }
                      }

                      return Container(
                        child: CountryCard(country: snapshot.data[index]),
                        padding: EdgeInsets.all(4.0),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Region:  "),
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
                    builder: (BuildContext context) => HomePage(),
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

class DensityPicker extends StatefulWidget {
  DensityPicker();

  @override
  _DensityPickerState createState() => _DensityPickerState();
}

class _DensityPickerState extends State<DensityPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Population density:  "),
        DropdownButton<String>(
          value: density,
          icon: Icon(Icons.accessibility),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              density = newValue;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ));
            });
          },
          items: <String>['All', 'Low', 'Medium', 'High']
              .map<DropdownMenuItem<String>>((String value) {
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
    return InkWell(
      child: Container(
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
                padding: EdgeInsets.all(8.0),
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
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CountryPage(country: country)),
        );
      },
    );
  }
}

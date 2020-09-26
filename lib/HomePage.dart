import 'package:flutter/material.dart';
import 'CountriesAPI.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Country>> countries;

  @override
  void initState() {
    countries = fetchCountries('all');
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
                RegionPicker(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Text(snapshot.data[index].name),
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
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
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
          dropdownValue = newValue;
        });
      },
      items: <String>['All', 'Americas', 'Europe', 'Oceania', 'Asia', 'Africa']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

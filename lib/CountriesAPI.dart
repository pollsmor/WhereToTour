import 'dart:convert'; // for JSON parsing
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; //for compute()

const base_url = 'https://restcountries.eu/rest/v2/';

Future<List<Country>> fetchCountries(String region) async {
  // by region
  final response = (region == 'all') // different API endpoint if we want "all" countries
      ? await http.get(base_url + 'all')
      : await http.get(base_url + 'region/' + region);

  return compute(parseCountries, response.body);
}

List<Country> parseCountries(String responseBody) {
  var list = json.decode(responseBody);
  List<Country> countries =
      List<Country>.from(list.map((i) => Country.fromJson(i)));

  return countries;
}

class Country {
  final String name;
  final String tld;
  final String callingCode;
  final String capital;
  final int population;
  final int area; // in sq km
  final double latitude, longitude;
  final List<String> currencies;
  final List<String> languages;
  final String flagURL;

  Country(
      {this.name,
      this.tld,
      this.callingCode,
      this.capital,
      this.population,
      this.area,
      this.latitude,
      this.longitude,
      this.currencies,
      this.languages,
      this.flagURL});

  factory Country.fromJson(Map<String, dynamic> json) {
    List<String> currencies = List<String>();
    for (var currency in json['currencies']) currencies.add(currency['code']);

    List<String> languages = List<String>();
    for (var language in json['languages']) languages.add(language['name']);

    return Country(
        name: json['name'],
        tld: json['topLevelDomain'][0],
        callingCode: json['callingCodes'][0],
        capital: json['capital'],
        population: json['population'],
        latitude: json['latlng'].length != 0 ? json['latlng'][0] : null,
        longitude: json['latlng'].length != 0 ? json['latlng'][1] : null,
        currencies: currencies,
        languages: languages,
        flagURL: json['flag']);
  }
}

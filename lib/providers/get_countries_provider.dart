import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GetCountriesProvider with ChangeNotifier {
  Future<List<DropdownMenuItem<String>>> getCountries() async {
    var request =
        await get(Uri.https('covid-193.p.rapidapi.com', 'countries'), headers: {
      'X-RapidAPI-Key': 'd7b1359095msh2f3d1cf03fadfc9p17d1dcjsnb8086ea2665c',
      'X-RapidAPI-Host': 'covid-193.p.rapidapi.com'
    });

    return countryDataFromJson(request.body)
        .response
        .map<DropdownMenuItem<String>>((country) {
      return DropdownMenuItem<String>(
        value: country,
        child: Text(country),
      );
    }).toList();
  }
}

CountryData countryDataFromJson(String str) =>
    CountryData.fromJson(json.decode(str));

String countryDataToJson(CountryData data) => json.encode(data.toJson());

class CountryData {
  List<String> response;
  CountryData(
    this.response,
  );

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        List<String>.from(json["response"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "response": List<dynamic>.from(response.map((x) => x)),
      };
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class CovidCasesCounterProvider with ChangeNotifier {
  String _totalCases = '0';
  String _activeCases = '0';
  String _recoveries = '0';
  String _deaths = '0';
  String _newAdditionalCases = "+0";
  String _newDeaths = "+0";
  String _lastUpdate = '';

  String get totalCases => _totalCases;
  String get activeCases => _activeCases;
  String get recoveries => _recoveries;
  String get deaths => _deaths;
  String get newAdditionalCases => _newAdditionalCases;
  String get newDeaths => _newDeaths;
  String get lastUpdate => _lastUpdate;

  Future<void> getCovidEntities(String country) async {
    var request = await get(
        Uri.https(
            'covid-193.p.rapidapi.com', 'statistics', {'country': country}),
        headers: {
          'X-RapidAPI-Key':
              'd7b1359095msh2f3d1cf03fadfc9p17d1dcjsnb8086ea2665c',
          'X-RapidAPI-Host': 'covid-193.p.rapidapi.com'
        });

    var covidEntites = covidCasesFromJson(request.body);
    var numberFormatter = NumberFormat.decimalPattern('en_us');

    _activeCases =
        numberFormatter.format(covidEntites.response[0].cases.active ??= 0);
    _totalCases =
        numberFormatter.format(covidEntites.response[0].cases.total ??= 0);
    _newAdditionalCases = covidEntites.response[0].cases.casesNew ??= "+0";
    _deaths =
        numberFormatter.format(covidEntites.response[0].deaths.total ??= 0);
    _newDeaths = covidEntites.response[0].deaths.deathsNew ??= "+0";
    _recoveries =
        numberFormatter.format(covidEntites.response[0].cases.recovered ??= 0);
    _lastUpdate =
        'Last update: ${DateFormat.yMMMMEEEEd().format(covidEntites.response[0].time)}';

    notifyListeners();
  }
}

CovidCases covidCasesFromJson(String str) =>
    CovidCases.fromJson(json.decode(str));
String covidCasesToJson(CovidCases data) => json.encode(data.toJson());

class CovidCases {
  List<Response> response;
  CovidCases(
    this.response,
  );

  factory CovidCases.fromJson(Map<String, dynamic> json) => CovidCases(
        List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Parameters {
  Parameters(
    this.country,
  );

  String country;

  factory Parameters.fromJson(Map<String, dynamic> json) => Parameters(
        json["country"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
      };
}

class Response {
  Response(
    this.continent,
    this.country,
    this.population,
    this.cases,
    this.deaths,
    this.tests,
    this.day,
    this.time,
  );

  String continent;
  String country;
  int population;
  Cases cases;
  Deaths deaths;
  Tests tests;
  DateTime day;
  DateTime time;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        json["continent"],
        json["country"],
        json["population"],
        Cases.fromJson(json["cases"]),
        Deaths.fromJson(json["deaths"]),
        Tests.fromJson(json["tests"]),
        DateTime.parse(json["day"]),
        DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "continent": continent,
        "country": country,
        "population": population,
        "cases": cases.toJson(),
        "deaths": deaths.toJson(),
        "tests": tests.toJson(),
        "day":
            "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
        "time": time.toIso8601String(),
      };
}

class Cases {
  Cases(
    this.casesNew,
    this.active,
    this.recovered,
    this.total,
  );

  String? casesNew; //
  int? active; //
  int? recovered; //
  int? total; //

  factory Cases.fromJson(Map<String, dynamic> json) => Cases(
        json["new"],
        json["active"],
        json["recovered"],
        json["total"],
      );

  Map<String, dynamic> toJson() => {
        "new": casesNew,
        "active": active,
        "recovered": recovered,
        "total": total,
      };
}

class Deaths {
  Deaths(
    this.deathsNew,
    this.total,
  );

  String? deathsNew;
  int? total;

  factory Deaths.fromJson(Map<String, dynamic> json) => Deaths(
        json["new"],
        json["total"],
      );

  Map<String, dynamic> toJson() => {
        "new": deathsNew,
        "total": total,
      };
}

class Tests {
  Tests(
    this.the1MPop,
    this.total,
  );

  String the1MPop;
  int total;

  factory Tests.fromJson(Map<String, dynamic> json) => Tests(
        json["1M_pop"],
        json["total"],
      );

  Map<String, dynamic> toJson() => {
        "1M_pop": the1MPop,
        "total": total,
      };
}

import 'package:covid_tracker/providers/covid_cases_provider.dart';
import 'package:covid_tracker/providers/get_countries_provider.dart';
import 'package:covid_tracker/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Color(0xFF222834),
  ));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CovidCasesCounterProvider()),
      ChangeNotifierProvider(create: (_) => GetCountriesProvider())
    ],
    child: MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': ((context) => const Home()),
      },
    ),
  ));
}

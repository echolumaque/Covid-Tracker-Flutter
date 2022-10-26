import 'package:covid_tracker/providers/covid_cases_provider.dart';
import 'package:covid_tracker/providers/get_countries_provider.dart';
import 'package:covid_tracker/views/cases_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String? _selectedCountry = 'Afghanistan';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CovidCasesCounterProvider>(context, listen: false)
          .getCovidEntities(_selectedCountry!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            Image.asset('assets/upper.png',
                width: MediaQuery.of(context).size.width),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('SARS NCoV 2019 Tracker',
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FutureBuilder(
                        future: Provider.of<GetCountriesProvider>(context,
                                listen: false)
                            .getCountries(),
                        builder: (context, countries) {
                          if (countries.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator()));
                          } else {
                            var items = countries.data
                                as List<DropdownMenuItem<String>>;
                            return DropdownButton<String>(
                              isExpanded: true,
                              selectedItemBuilder: (context) {
                                return items.map((country) {
                                  return DropdownMenuItem<String>(
                                      value: country.value,
                                      child: Text(country.value!,
                                          style: const TextStyle(
                                              color: Colors.white)));
                                }).toList();
                              },
                              value: _selectedCountry,
                              items: items,
                              onChanged: (selectedCountry) {
                                _selectedCountry = selectedCountry;
                                Provider.of<CovidCasesCounterProvider>(context,
                                        listen: false)
                                    .getCovidEntities(_selectedCountry!);
                              },
                            );
                          }
                        }),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                          context.watch<CovidCasesCounterProvider>().lastUpdate,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 190, left: 20, right: 20),
              child: Container(
                color: const Color(0xFFEAEAEA),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: .65,
                  children: [
                    CasesEntity(
                        'Total',
                        context.watch<CovidCasesCounterProvider>().totalCases,
                        context
                            .watch<CovidCasesCounterProvider>()
                            .newAdditionalCases,
                        const Color(0xFFE91D52),
                        true),
                    CasesEntity(
                        'Active',
                        context.watch<CovidCasesCounterProvider>().activeCases,
                        "0",
                        const Color(0xFF0E73DF),
                        false),
                    CasesEntity(
                        'Recovered',
                        context.watch<CovidCasesCounterProvider>().recoveries,
                        "0",
                        const Color(0xFF33A142),
                        false),
                    CasesEntity(
                        'Deceased',
                        context.watch<CovidCasesCounterProvider>().deaths,
                        context.watch<CovidCasesCounterProvider>().newDeaths,
                        const Color(0xFFA5A5A5),
                        true),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

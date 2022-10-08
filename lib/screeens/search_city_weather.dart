// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:info_app/screeens/main_info_screen.dart';

import 'package:info_app/services/weather_api.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class SearchWeather extends StatefulWidget {
  const SearchWeather({super.key});

  @override
  State<SearchWeather> createState() => _SearchWeatherState();
}

class _SearchWeatherState extends State<SearchWeather> {
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;
  List<WeatherModel> weatherInCity = [];
  bool _isLoading = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _textEditingController.dispose();
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const MainScreen();
                        },
                      ));
                    },
                    icon: const Icon(IconlyLight.arrow_left)),
                Flexible(
                    child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Provide Locations',
                  ),
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  onEditingComplete: () async {
                    setState(() {
                      _isLoading = true;
                      weatherInCity.clear();
                      _focusNode.unfocus();
                    });
                    try {
                      weatherInCity =
                          await WeatherAPiServices.getWeatherFromSearchScreen(
                              cityName: _textEditingController.text);
                    } catch (e) {
                      rethrow;
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                )),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            _isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : _textEditingController.text.isEmpty
                    ? Container()
                    : weatherInCity.isNotEmpty
                        ? GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 20,
                              color: Theme.of(context).cardColor,
                              child: ListTile(
                                leading: Image.network(
                                  'http://openweathermap.org/img/wn/${weatherInCity[0].weather![0].icon}@2x.png',
                                ),
                                title: Text(
                                  '${weatherInCity[0].name!}, ${weatherInCity[0].sys!.country}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                trailing: PopUpWidget(fct: () async {
                                  await weatherProvider.addWeatcherFromLoc(
                                      latitude: weatherInCity[0]
                                          .coord!
                                          .lat
                                          .toString(),
                                      longitude: weatherInCity[0]
                                          .coord!
                                          .lon
                                          .toString());
                                }),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/CityNotFound.jpg'),
                              const Expanded(
                                child: SizedBox(
                                  height: 30,
                                ),
                              ),
                              const Text(
                                'City not found',
                                style: TextStyle(fontSize: 30),
                              ),
                              Expanded(child: Container()),
                            ],
                          )),
          ]),
        ),
      ),
    );
  }

  PopUpWidget({required Function fct}) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => fct(),
          child: Row(
            children: const [
              Icon(Icons.star),
              SizedBox(
                width: 10,
              ),
              Text("Add to list")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 50),
      elevation: 20,
    );
  }
}

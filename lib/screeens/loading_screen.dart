// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:info_app/providers/weather_provider.dart';
import 'package:info_app/screeens/main_info_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      Future.delayed(const Duration(seconds: 1), () async {
        await Provider.of<WeatherProvider>(context, listen: false)
            .addWeatcherFromLoc(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        );

        Navigator.pushNamed(context, MainScreen.routeName);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: Image.asset(
            'assets/images/loadingImg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black87,
          child: const Center(
            child: SpinKitCircle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

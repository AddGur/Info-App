import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:info_app/models/weather_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    dynamic weatherModel = Provider.of<WeatherModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.blue,
            highlightColor: Colors.lightBlue,
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(weatherModel.main.temp.toStringAsFixed(0) + "°",
                          style: GoogleFonts.alegreya(fontSize: 60)),
                      Image.network(
                          'http://openweathermap.org/img/wn/${weatherModel.weather[0].icon}@2x.png'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        weatherModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.heebo(fontSize: 25),
                      ),
                      const Icon(
                        IconlyBold.location,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                  Text(
                    '${weatherModel.main.tempMax.toStringAsFixed(0)}° / ${weatherModel.main.tempMin.toStringAsFixed(0)}° Feels like ${weatherModel.main.feelsLike.toStringAsFixed(0)}',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.heebo(fontSize: 25),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';

class LocationModel with ChangeNotifier {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});
}

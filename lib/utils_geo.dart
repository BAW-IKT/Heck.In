import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkLocationPermissions() async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    final requestedPermission = await Geolocator.requestPermission();
    return requestedPermission == LocationPermission.always ||
        requestedPermission == LocationPermission.whileInUse;
  }
  return true;
}

Future<void> getLastKnownLocation() async {
  final hasPermission = await checkLocationPermissions();
  if (hasPermission) {
    final position = await Geolocator.getLastKnownPosition();

    if (position != null) {
      await writeToPrefs(position.latitude.toString(),
          position.longitude.toString(), position.timestamp.toString());
    }
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("geo_latitude") &&
        !prefs.containsKey("geo_longitude") &&
        !prefs.containsKey("geo_last_change")) {
      prefs.setString("geo_latitude", "48.1970");
      prefs.setString("geo_longitude", "16.3389");
      prefs.setString("geo_last_change", "n/a");
    }
  }
}

Future<void> writeToPrefs(String lat, String lon, String timestamp) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("geo_latitude", lat);
  prefs.setString("geo_longitude", lon);
  prefs.setString("geo_last_change", timestamp);
}

Future<void> updateLocation() async {
  final hasPermission = await checkLocationPermissions();
  if (hasPermission) {
    final position = await Geolocator.getCurrentPosition();
      await writeToPrefs(position.latitude.toString(),
          position.longitude.toString(), DateTime.now().toString());
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Check if location services are available
Future<void> _checkLocationPermissions() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled. '
        'Enable in Settings > Location.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied. '
          'Enable in Settings > Apps > hedge_profiler.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied. '
        'Enable in Settings > Location and Settings > Apps > hedge_profiler.');
  }
}

/// returns last known location
Future<Position?> getLastKnownLocation() async {
  return await Geolocator.getLastKnownPosition(
      forceAndroidLocationManager: true);
}

/// checks if location permissions are given
/// updates location
/// writes coordinates and timestamp to memory
/// returns error message as string or empty string
Future<String> updateLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    // check permissions
    await _checkLocationPermissions();

    // set last position as fallback
    await setLastPosWithFallback(prefs);

    // set current position
    _setCurrentPos(prefs);
  } catch (e) {
    await setLastPosWithFallback(prefs);
    return e.toString();
  }
  return '';
}

Future<void> setLastPosWithFallback(SharedPreferences prefs) async {
  _checkLocationPermissions();
  Position? lastPos =
      await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
  if (lastPos != null) {
    prefs.setString("latitude", lastPos.latitude.toString());
    prefs.setString("longitude", lastPos.longitude.toString());
    prefs.setString("geoLastChange", lastPos.timestamp.toString());
  } else {
    // if not available, set to defaults (vienna)
    prefs.setString("latitude", "48.1970");
    prefs.setString("longitude", "16.3389");
    prefs.setString("geoLastChange", "n/a");
  }
}

// void getLastPosWithFallback() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   _setLastPosWithFallback(prefs);
// }

void _setCurrentPos(SharedPreferences prefs) async {
  Position currPos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  prefs.setString("latitude", currPos.latitude.toString());
  prefs.setString("longitude", currPos.longitude.toString());
  prefs.setString("geoLastChange", DateTime.now().toString());
}

/// shows an alert dialog that geo coordinates could not be retrieved
showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Geo coordinates not available"),
    content:
        const Text("Could not get location. Make sure Location services are "
            "enabled (Android: Settings -- >Location --> Enable)."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';

void main() => runApp(const HedgeProfilerApp());

class HedgeProfilerApp extends StatefulWidget {
  const HedgeProfilerApp({super.key});

  @override
  _HedgeProfilerAppState createState() => _HedgeProfilerAppState();

  /// ↓↓ ADDED
  /// InheritedWidget style accessor to our State object.
  static _HedgeProfilerAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_HedgeProfilerAppState>()!;
}

class _HedgeProfilerAppState extends State<HedgeProfilerApp> {
  /// 1) our themeMode "state" field
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedge Profiler',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode, // 2) ← ← ← use "state" field here //////////////
      home: const WebViewPage(),
    );
  }

  /// 3) Call this to change theme from any context using "of" accessor
  /// e.g.:
  /// HedgeProfilerApp.of(context).changeTheme(ThemeMode.dark);
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  var loadingPercentage = 0;
  late final WebViewController _controller;
  bool _showNameForm = true;
  final NameForm _nameForm = const NameForm();
  String _currentUrlStem = '';
  String _geoLastChange = 'not initialized';
  String _geoLastKnown = 'not initialized';
  String _geoWarning = 'test';
  bool _darkMode = true;

  _updateLocationWrapper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? warning = await _updateLocation();
    setState(() {
      _geoWarning = warning;
      _geoLastChange = prefs.getString("geoLastChange")?.split(".")[0] ?? 'n/a';
      String lat = prefs.getString("latitude") ?? "n/a";
      String lon = prefs.getString("longitude") ?? "n/a";
      _geoLastKnown = "lat: $lat\nlon: $lon";
    });
  }

  @override
  void initState() {
    super.initState();

    _updateLocationWrapper();

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
            debugPrint('Page started loading: $url');
          },
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
            debugPrint('WebView is loading (progress: $progress%)');
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              loadingPercentage = 0;
            });
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedge Profiler'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text(
                      'Hedge Profiler',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: _updateLocationWrapper,
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      icon: _darkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
                      // icon: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
                      onPressed: () {
                        setState(() {
                          _darkMode = !_darkMode;
                          if (_darkMode) {
                            HedgeProfilerApp.of(context).changeTheme(ThemeMode.dark);
                          } else {
                            HedgeProfilerApp.of(context).changeTheme(ThemeMode.light);
                          }
                        });
                      },

                    )
                  ]),
                  const Text('Last known location',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(_geoLastKnown,
                      style: const TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic
                      )
                  ),
                  Text(_geoLastChange,
                      style: const TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic
                      )
                  ),
                  Text(_geoWarning,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.eco_rounded, color: Colors.green),
              title: const Text('Rate Hedge'),
              onTap: () {
                setState(() {
                  _showNameForm = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined, color: Colors.red),
              title: const Text('Arcanum'),
              onTap: () {
                setState(() {
                  _showNameForm = false;
                });
                _loadPage(context, 'https://maps.arcanum.com/');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined, color: Colors.blue),
              title: const Text('Bodenkarte'),
              onTap: () {
                setState(() {
                  _showNameForm = false;
                });
                _loadPage(context, 'https://bodenkarte.at/');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
          if (_showNameForm)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: _nameForm,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _loadPage(BuildContext context, String url) async {
    // prevent loading of page if page was already loaded before
    String stem = RegExp("http.*(com|at)").firstMatch(url)?.group(0) ?? '';
    if (_currentUrlStem != stem && stem != '') {
      _currentUrlStem = stem;

      // update geo info
      // _updateLocation();
      _updateLocationWrapper();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var latitude = prefs.getString("latitude");
      var longitude = prefs.getString("longitude");
      var zoom =
          "15"; // change location zoom depending on whether location can be loaded

      if (latitude == "16.3389" || longitude == "48.1970") {
        zoom = "10";
      }

      // re-build boden karte URL with updated coords
      if (url.startsWith("https://bodenkarte.at")) {
        url = "https://bodenkarte.at/#/center/$longitude,$latitude/zoom/$zoom";
      }

      if (url.startsWith("https://maps.arcanum.com/")) {
        String stem = "https://maps.arcanum.com/en/map";
        String map = "europe-19century-secondsurvey";
        url = "$stem/$map/?lon=$longitude&lat=$latitude&zoom=$zoom";
      }

      // load page via controller
      _controller.loadRequest(Uri.parse(url));
    }
  }
}

class NameForm extends StatefulWidget {
  const NameForm({Key? key}) : super(key: key);

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _persistInputStorage();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _populateInputFields();
  }

  void _populateInputFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _numberController.text = prefs.getString('number') ?? '';
  }

  void _persistInputStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text.trim());
    prefs.setString('number', _numberController.text.trim());
  }

  void _clearInputStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _populateInputFields();
  }

  void _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var position = await _getLastKnownLocation();
    //TODO: implement writing to database
    final name = _nameController.text.trim();
    showAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile the Hedge!',
              style: TextStyle(fontSize: 24),
            ),
            Text('Some text', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _saveFormData();
                }
              },
              child: const Text('Submit'),
            ),
            ElevatedButton(
                onPressed: _clearInputStorage, child: const Text('Clear')),
          ],
        ),
      ),
    );
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
void _checkLocationPermissions() async {
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

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.

  // return Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high
  // );
}

Future<Position?> _getLastKnownLocation() async {
  return await Geolocator.getLastKnownPosition(
      forceAndroidLocationManager: true);
}

Future<String> _updateLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    // try to get current position
    _checkLocationPermissions();
    Position currPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    prefs.setString("latitude", currPos.latitude.toString());
    prefs.setString("longitude", currPos.longitude.toString());
    prefs.setString("geoLastChange", DateTime.now().toString());
  } catch (e) {
    // if not available, get last known position
    Position? lastPos = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
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

    return e.toString();
  }
  return '';
}

// void _checkIfLocationServicesAreEnabled() async {
//   Location location = new Location();
//
//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;
//
//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }
//
//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }
//
//   _locationData = await location.getLocation();
// }

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

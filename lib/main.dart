import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'form.dart';
import 'colors.dart';
import 'utils_geo_v2.dart' as geo;
import 'snackbar.dart';

void main() => runApp(const HedgeProfilerApp());

class HedgeProfilerApp extends StatefulWidget {
  const HedgeProfilerApp({super.key});

  @override
  HedgeProfilerAppState createState() => HedgeProfilerAppState();

  static HedgeProfilerAppState of(BuildContext context) =>
      context.findAncestorStateOfType<HedgeProfilerAppState>()!;
}

class HedgeProfilerAppState extends State<HedgeProfilerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedge Profiler',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
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

/// main page, instantiates WebView controller and NameForm (displayed as overlay)
class _WebViewPageState extends State<WebViewPage> {
  ValueNotifier<double> _loadingPercentage = ValueNotifier<double>(0.0);
  late final WebViewController _controller;

  bool _showNameForm = true;
  final GlobalKey<NameFormState> _nameFormKey = GlobalKey<NameFormState>();

  String _currentUrlStem = '';
  String _geoLastChange = 'never updated';
  String _geoLastKnown = 'no location available';
  String systemLocale = Platform.localeName.startsWith("de") ? "DE" : "EN";
  String currentLocale = "EN";
  bool _darkMode = true;
  bool _isLoading = true;

  /// initializes the firebase app
  _initDatabase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _updateLocationAndLocales();
    _initDatabase();

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _loadingPercentage.value = 0;
            // debugPrint('Page started loading: $url');
          },
          onProgress: (int progress) {
            _loadingPercentage.value = progress.toDouble();
            // debugPrint('WebView is loading (progress: $progress%)');
          },
          onPageFinished: (String url) {
            _loadingPercentage.value = 100;
            // debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            _loadingPercentage.value = 0;
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
            showSnackbar(context, error.description.toString());
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller = controller;
  }

  /// refreshes geo coordinates and updates variables for menu accordingly
  _updateLocationAndLocales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // initially set locale
    if (!prefs.containsKey("locale")) {
      prefs.setString("locale", systemLocale);
    }

    // load last stored locale
    currentLocale = prefs.getString("locale")!;

    // set to last known pos
    await geo.getLastKnownLocation();
    setState(() {
      _geoLastChange = prefs.getString("geoLastChange")?.split(".")[0] ?? 'n/a';
      String lat = prefs.getString("latitude") ?? "n/a";
      String lon = prefs.getString("longitude") ?? "n/a";
      _geoLastKnown = "lat: $lat\nlon: $lon";
      _isLoading = false;
    });

    // wait for refresh of coords
    await geo.updateLocation();
    setState(() {
      _geoLastChange = prefs.getString("geoLastChange")?.split(".")[0] ?? 'n/a';
      String lat = prefs.getString("latitude") ?? "n/a";
      String lon = prefs.getString("longitude") ?? "n/a";
      _geoLastKnown = "lat: $lat\nlon: $lon";
    });
  }

  /// scaffold of app with menu drawer and WebViewWidget as body
  /// NameForm is stacked on top and controlled with _showNameForm
  @override
  Widget build(BuildContext context) {
    /// loads a page
    void loadPage(BuildContext context, String url) async {
      // prevent loading of page if page was already loaded before
      String stem = RegExp("http.*(com|at)").firstMatch(url)?.group(0) ?? '';
      if (_currentUrlStem != stem && stem != '') {
        _currentUrlStem = stem;

        // update geo info
        // _updateLocation();
        _updateLocationAndLocales();

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
          url =
              "https://bodenkarte.at/#/center/$longitude,$latitude/zoom/$zoom";
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

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              currentLocale == "EN" ? "Hedge Profiler" : "Hecken Profiler"),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: MyColors.blue,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            currentLocale == "EN"
                                ? "Hedge Profiler"
                                : "Hecken Profiler",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildGeoStatusText(),
                        ],
                      ),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.eco_rounded, color: MyColors.green),
                      title: Text(currentLocale == "EN"
                          ? "Rate Hedge"
                          : "Hecke Bewerten"),
                      onTap: () {
                        setState(() {
                          _showNameForm = true;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.map_outlined, color: MyColors.coral),
                      title: Text(currentLocale == "EN"
                          ? "View Arcanum Map"
                          : "Arcanum Karte Öffnen"),
                      onTap: () {
                        setState(() {
                          _showNameForm = false;
                        });
                        loadPage(context, 'https://maps.arcanum.com/');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.map_outlined, color: MyColors.teal),
                      title: Text(currentLocale == "EN"
                          ? "View Bodenkarte"
                          : "Bodenkarte Öffnen"),
                      onTap: () {
                        setState(() {
                          _showNameForm = false;
                        });
                        loadPage(context, 'https://bodenkarte.at/');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLanguageToggleButton(),
                        _buildGeoRefreshButton(),
                        _buildDarkmodeToggleButton(),
                      ]),
                  const SizedBox(height: 30),
                  Image.asset(
                    'data/lsw_logo.png',
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: _controller,
            ),
            ValueListenableBuilder<double>(
              valueListenable: _loadingPercentage,
              builder: (context, value, child) {
                return value < 100
                    ? LinearProgressIndicator(
                        value: value / 100.0,
                      )
                    : const SizedBox.shrink();
              },
            ),
            if (_showNameForm)
              Positioned.fill(
                child: Container(
                  color: MyColors.black.withOpacity(0.5),
                  child: Center(
                    child: NameForm(formKey: _nameFormKey),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  void _toggleLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("locale") == "EN") {
      prefs.setString("locale", "DE");
      currentLocale = "DE";
    } else {
      prefs.setString("locale", "EN");
      currentLocale = "EN";
    }

    // Rebuild form
    setState(() {});
  }

  Widget _buildLanguageToggleButton() {
    // return Row(children: [
    //   IconButton(
    //     icon: currentLocale == "EN"
    //         ? const Icon(Icons.translate, color: MyColors.green)
    //         : const Icon(Icons.translate, color: MyColors.orange),
    //     onPressed: _toggleLanguage,
    //     tooltip:
    //     currentLocale == "EN" ? "Switch to German" : "Switch to English",
    //   ),
    //   Text(
    //     currentLocale == "EN" ? "EN" : "DE",
    //     style: TextStyle(
    //       color: currentLocale == "EN" ? MyColors.green : MyColors.orange,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // ]);

    return ElevatedButton(
      onPressed: _toggleLanguage,
      child: Column(children: [
        const Icon(Icons.translate, ),
        currentLocale == "EN" ? const Text("Deutsch") : const Text("English"),
      ]),
    );
  }

  Widget _buildDarkmodeToggleButton() {
    // return IconButton(
    //   icon: _darkMode
    //       ? const Icon(Icons.light_mode, color: MyColors.yellow)
    //       : const Icon(Icons.dark_mode, color: MyColors.black,),
    //   // icon: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
    //   onPressed: () {
    //     setState(() {
    //       _darkMode = !_darkMode;
    //       if (_darkMode) {
    //         HedgeProfilerApp.of(context).changeTheme(ThemeMode.dark);
    //       } else {
    //         HedgeProfilerApp.of(context).changeTheme(ThemeMode.light);
    //       }
    //     });
    //   },
    // );

    String light = currentLocale == "EN" ? "Light" : "Hell";
    String dark = currentLocale == "EN" ? "Dark" : "Dunkel";

    return ElevatedButton(
      child: Column(
        children: [
          _darkMode
              ? const Icon(Icons.light_mode, color: MyColors.yellow)
              : const Icon(
                  Icons.dark_mode,
                  color: MyColors.black,
                ),
          _darkMode ? Text(light) : Text(dark),
        ],
      ),
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
    );
  }

  Widget _buildGeoRefreshButton() {
    // return IconButton(
    //   onPressed: _updateLocationAndLocales,
    //   icon: const Icon(
    //     Icons.my_location_sharp,
    //     color: MyColors.coral,
    //     size: 20,
    //   ),
    // );
    return ElevatedButton(
        onPressed: _updateLocationAndLocales,
        child: Column(children: [
          const Icon(Icons.my_location_sharp, color: MyColors.coral),
          currentLocale == "EN"
              ? const Text("Location")
              : const Text("Standort")
        ]));
  }

  Widget _buildGeoStatusText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              currentLocale == "EN"
                  ? "Location updated: "
                  : "Standort aktualisiert: ",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              _geoLastChange,
              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            _geoLastKnown,
            style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Action'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

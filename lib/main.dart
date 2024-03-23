import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hedge_profiler_flutter/form_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'colors.dart';
import 'form.dart';
import 'history.dart';
import 'snackbar.dart';
import 'utils_geo.dart' as geo;
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "data/.env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstTime = !(prefs.containsKey("first_time_launch") &&
      prefs.getString("first_time_launch") == "false");
  runApp(HedgeProfilerApp(firstTime: firstTime));
}

class HedgeProfilerApp extends StatefulWidget {
  final bool firstTime;

  const HedgeProfilerApp({Key? key, required this.firstTime}) : super(key: key);

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
      title: 'Heck.In',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: widget.firstTime
          ? const SplashScreen(darkMode: false)
          : const WebViewPage(),
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
  State<WebViewPage> createState() => WebViewPageState();
}

/// main page, instantiates WebView controller and NameForm (displayed as overlay)
class WebViewPageState extends State<WebViewPage> {
  final ValueNotifier<double> _loadingPercentage = ValueNotifier<double>(0.0);
  late final WebViewController _controller;

  final bool _showGeoCoordsInSidebar = false;
  bool _showNameForm = true;
  GlobalKey<NameFormState> _nameFormKey = GlobalKey<NameFormState>();

  MapDescriptor _currentMapDescriptor = MapDescriptor.NULL;
  String _geoLastChange = 'never updated';
  String _geoLastKnown = 'no location available';
  String systemLocale = Platform.localeName.startsWith("de") ? "DE" : "EN";
  String currentLocale = "EN";
  bool _darkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _updateDarkMode();
    _updateLocationAndLocales();

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
            showSnackbar(context, error.description.toString());
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller = controller;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final brightness = MediaQuery.of(context).platformBrightness;
  //   setState(() {
  //     _darkMode = brightness == Brightness.dark;
  //   });
  // }

  void _checkPermissions() async {
    PermissionStatus locationStatus = await Permission.location.status;
    PermissionStatus storageStatus = await Permission.storage.status;
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (!locationStatus.isGranted) await Permission.location.request();
    if (!storageStatus.isGranted) await Permission.storage.request();
    if (!cameraStatus.isGranted) await Permission.camera.request();
  }

  void _updateDarkMode() async {
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// refreshes geo coordinates and updates variables for menu accordingly
  _updateLocationAndLocales() async {
    String geoLastChange = "n/a";
    String lat = "n/a";
    String lon = "n/a";
    String geoLastKnown = "$lat,$lon";

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // initially set locale
      if (!prefs.containsKey("locale")) {
        prefs.setString("locale", systemLocale);
      }

      // load last stored locale
      currentLocale = prefs.getString("locale") ?? "EN";

      // set to last known pos
      await geo.getLastKnownLocation().timeout(const Duration(seconds: 5),
          onTimeout: () {
        showSnackbar(
            context,
            currentLocale == "EN"
                ? "Timeout when fetching geo information"
                : "Geo koordinaten konnten nicht abgerufen werden");
      });

      geoLastChange =
          prefs.getString("geo_last_change")?.split(".")[0] ?? 'n/a';
      lat = prefs.getString("geo_latitude") ?? "n/a";
      lon = prefs.getString("geo_longitude") ?? "n/a";
      geoLastKnown = "$lat,$lon";

      // wait for refresh of coords with a timeout of 5 seconds
      await geo.updateLocation().timeout(const Duration(seconds: 5),
          onTimeout: () {
        showSnackbar(
            context,
            currentLocale == "EN"
                ? "Timeout when updating geo information"
                : "Geo koordinaten konnten nicht aktualisiert werden");
      });

      geoLastChange =
          prefs.getString("geo_last_change")?.split(".")[0] ?? 'n/a';
      lat = prefs.getString("geo_latitude") ?? "n/a";
      lon = prefs.getString("geo_longitude") ?? "n/a";
      geoLastKnown = "$lat,$lon";
    } catch (e) {
      showSnackbar(context, "Error when updating geo information: $e");
    } finally {
      setState(() {
        _isLoading = false;
        _geoLastChange = geoLastChange;
        _geoLastKnown = geoLastKnown;
      });
    }
  }

  /// scaffold of app with menu drawer and WebViewWidget as body
  /// NameForm is stacked on top and controlled with _showNameForm
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.topBarColor,
          title: Text(currentLocale == "EN" ? "Rate Hedge" : "Hecke Bewerten"),
        ),
        drawer: _buildMainMenuDrawer(),
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
            Offstage(
              offstage: !_showNameForm,
              // when _showNameForm is false, the Container will be off the screen
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: MyColors.black.withOpacity(0.5),
                      child: Center(
                        child: NameForm(
                          formKey: _nameFormKey,
                          webViewPageState: this,
                          showForm: _showNameForm,
                          darkMode: _darkMode,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildMainMenuDrawer() {
    List<Widget> drawerChildren = [];
    drawerChildren.add(_buildMainMenuDrawerHeader());
    drawerChildren.add(_buildMainMenuDrawerRateHedgeListTile());
    for (ListTile mapListTile in _buildMainMenuDrawerMapListTiles()) {
      drawerChildren.add(mapListTile);
    }

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: drawerChildren,
            ),
          ),
          _buildBottomPartForMainMenuDrawer(),
        ],
      ),
    );
  }

  void _showFirstLaunchDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("first_time_launch", "true");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SplashScreen(darkMode: _darkMode)));
  }

  ListTile _buildMainMenuDrawerRateHedgeListTile() {
    return ListTile(
      leading: const Icon(Icons.eco_rounded, color: MyColors.green),
      title: Text(currentLocale == "EN" ? "Rate Hedge" : "Hecke Bewerten"),
      onTap: () {
        setState(() {
          _showNameForm = true;
        });
        Navigator.pop(context);
      },
    );
  }

  List<ListTile> _buildMainMenuDrawerMapListTiles() {
    return [
      getMapListTile(const Icon(Icons.map_outlined, color: MyColors.blueDark),
          MapDescriptor.arcanum, loadMapArcanum),
      getMapListTile(
          const Icon(Icons.map_outlined, color: MyColors.blueLight),
          MapDescriptor.bodenkarteNutzbareFeldkapazitaet,
          loadMapBodenkarteNutzbareFeldkapazitaet),
      getMapListTile(const Icon(Icons.map_outlined, color: MyColors.blueDark),
          MapDescriptor.bodenkarteHumusBilanz, loadMapBodenkarteHumusBilanz),
      getMapListTile(
          const Icon(Icons.map_outlined, color: MyColors.blueLight),
          MapDescriptor.geonodeLebensraumVernetzung,
          loadMapGeonodeLebensraumverletzung),
      getMapListTile(const Icon(Icons.map_outlined, color: MyColors.blueDark),
          MapDescriptor.ecosystem, loadMapEcosystemAccounts),
      getMapListTile(const Icon(Icons.map_outlined, color: MyColors.blueLight),
          MapDescriptor.geoland, loadMapGeoland),
      getMapListTile(const Icon(Icons.map_outlined, color: MyColors.blueDark),
          MapDescriptor.noeNaturschutz, loadMapNoeNaturschutz),
      getMapListTile(const Icon(Icons.map_outlined, color: MyColors.blueLight),
          MapDescriptor.eeaProtectedAreas, loadMapEEAEuropa),
    ];
  }

  ListTile getMapListTile(Icon icon, MapDescriptor mapDesc, Function mapFunc) {
    return ListTile(
      leading: icon,
      title: Text(getMapDescriptionForMenu(mapDesc, currentLocale)),
      onTap: () {
        mapFunc();
      },
    );
  }

  Widget _buildMainMenuDrawerHeader() {
    return Container(
      height: 150,
      color: _darkMode ? MyColors.topBarColor : MyColors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Heck.In",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.info_outline, color: MyColors.blueDark),
                  onPressed: () {
                    _showFirstLaunchDialog();
                  },
                ),
                _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      )
                    : Container(),
              ],
            ),
            _buildGeoStatusText(),
          ],
        ),
      ),
    );
  }

  Column _buildBottomPartForMainMenuDrawer() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildLanguageToggleButton(),
          // _buildGeoRefreshButton(),
          _buildHistoryButton(),
          _buildDarkmodeToggleButton(),
        ]),
        const SizedBox(height: 30),
        Image.asset(
          'data/lsw_logo.png',
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  Future<bool> _onBackButtonPressed() async {
    if (!_showNameForm) {
      // If _showNameForm is false, toggle it to true and rebuild the widget
      setState(() {
        _showNameForm = true;
      });
      // Cancel the back button action (Do not minimize the app)
      return false;
    } else {
      // If _showNameForm is true, execute the default back button action
      return true;
    }
  }

  void loadMapFromDescriptor(MapDescriptor descriptor) {
    switch (descriptor) {
      case MapDescriptor.NULL:
        break;
      case MapDescriptor.arcanum:
        loadMapArcanum();
        break;
      case MapDescriptor.bodenkarte:
        loadMapBodenkarte();
        break;
      case MapDescriptor.bodenkarteNutzbareFeldkapazitaet:
        loadMapBodenkarteNutzbareFeldkapazitaet();
        break;
      case MapDescriptor.bodenkarteHumusBilanz:
        loadMapBodenkarteHumusBilanz();
        break;
      case MapDescriptor.geonodeLebensraumVernetzung:
        loadMapGeonodeLebensraumverletzung();
        break;
      case MapDescriptor.ecosystem:
        loadMapEcosystemAccounts();
        break;
      case MapDescriptor.geoland:
        loadMapGeoland();
        break;
      case MapDescriptor.noeNaturschutz:
        loadMapNoeNaturschutz();
        break;
      case MapDescriptor.eeaProtectedAreas:
        loadMapEEAEuropa();
        break;
    }
  }

  void loadMapArcanum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getString("geo_latitude");
    var longitude = prefs.getString("geo_longitude");
    String stem = "https://maps.arcanum.com/en/map";
    String map = "europe-19century-secondsurvey";
    loadPageWrapper("$stem/$map/?lon=$longitude&lat=$latitude&zoom=15",
        MapDescriptor.arcanum);
  }

  void loadMapBodenkarte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getString("geo_latitude");
    var longitude = prefs.getString("geo_longitude");
    loadPageWrapper(
        "https://bodenkarte.at/#/center/$longitude,$latitude/zoom/15",
        MapDescriptor.bodenkarte);
  }

  void loadMapBodenkarteNutzbareFeldkapazitaet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getString("geo_latitude");
    var longitude = prefs.getString("geo_longitude");
    loadPageWrapper(
        "https://bodenkarte.at/#/d/baw/l/nf,false,60,kb/center/$longitude,$latitude/zoom/15",
        MapDescriptor.bodenkarteNutzbareFeldkapazitaet);
  }

  void loadMapBodenkarteHumusBilanz() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getString("geo_latitude");
    var longitude = prefs.getString("geo_longitude");
    loadPageWrapper(
        "https://bodenkarte.at/#/d/bfa/l/hb,false,60,kb/center/$longitude,$latitude/zoom/15",
        MapDescriptor.bodenkarteHumusBilanz);
  }

  void loadMapGeonodeLebensraumverletzung() {
    // localized URL not available according to roland.grillmayer@umweltbundesamt.at
    loadPageWrapper("https://geonode.lebensraumvernetzung.at/maps/63/view#/",
        MapDescriptor.geonodeLebensraumVernetzung);
  }

  void loadMapEcosystemAccounts() {
    // TODO: email sent to: jrc-inca@ec.europa.eu
    loadPageWrapper("https://ecosystem-accounts.jrc.ec.europa.eu/map",
        MapDescriptor.ecosystem);
  }

  void loadMapGeoland() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getString("geo_latitude");
    var longitude = prefs.getString("geo_longitude");
    loadPageWrapper(
        "https://www.geoland.at/webgisviewer/geoland/map/Geoland_Viewer/Geoland"
        "?center=$longitude,$latitude&scale=20000",
        MapDescriptor.geoland);
  }

  void loadMapNoeNaturschutz() {
    // TODO: email sent to: gis-support@noel.gv.at
    loadPageWrapper(
        "https://atlas.noe.gv.at/atlas/portal/noe-atlas/map/Naturraum/Naturschutz",
        MapDescriptor.noeNaturschutz);
  }

  void loadMapEEAEuropa() {
    // localized URL not available according to Mayra.ZURBARAN-NUCCI@ec.europa.eu
    loadPageWrapper(
        "https://www.eea.europa.eu/data-and-maps/explore-interactive-maps/european-protected-areas-1",
        MapDescriptor.eeaProtectedAreas);
  }

  void loadPageWrapper(String pageURL, MapDescriptor mapDescriptor) async {
    if (mounted) {
      setState(() {
        _showNameForm = false;
      });
    }
    if (_currentMapDescriptor != mapDescriptor) {
      setState(() {
        _currentMapDescriptor = mapDescriptor;
      });
      // loadPage(context, pageURL);
      _controller.loadRequest(Uri.parse(pageURL));
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
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
    // Rebuild main form
    setState(() {});

    // // re-initialize form (delayed)
    // Future.delayed(Duration.zero, () {
    //   _nameFormKey.currentState?.initState();
    // });

    // reset form key
    _nameFormKey = GlobalKey<NameFormState>();
  }

  Widget _buildLanguageToggleButton() {
    return ElevatedButton(
      onPressed: _toggleLanguage,
      child: Column(children: [
        const Icon(
          Icons.translate,
        ),
        currentLocale == "EN" ? const Text("Deutsch") : const Text("English"),
      ]),
    );
  }

  Widget _buildDarkmodeToggleButton() {
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

  Widget _buildHistoryButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfFileList(
                    currentLocale: currentLocale, darkMode: _darkMode)),
          );
        },
        child: Column(children: [
          const Icon(Icons.history, color: MyColors.coral),
          currentLocale == "EN" ? const Text("History") : const Text("Verlauf")
        ]));
  }

  Widget _buildGeoRefreshButton() {
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
            IconButton(
              icon: const Icon(Icons.my_location_sharp,
                  color: MyColors.blueDark, size: 20),
              onPressed: () {
                _updateLocationAndLocales();
              },
            ),
          ],
        ),
        Visibility(
          visible: _showGeoCoordsInSidebar,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              _geoLastKnown,
              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
            ),
          ),
        )
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

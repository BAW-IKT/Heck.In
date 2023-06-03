import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dynamic_dropdowns.dart';
import 'form_data.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'form_utils.dart';
import 'utils_geo_v2.dart' as geo;
import 'utils_db.dart' as db;
import 'snackbar.dart';
import 'radar_chart.dart';
import 'dart:math';

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
  var loadingPercentage = 0;
  late final WebViewController _controller;

  bool _showNameForm = true;
  final GlobalKey<NameFormState> _nameFormKey = GlobalKey<NameFormState>();

  String _currentUrlStem = '';
  String _geoLastChange = 'never updated';
  String _geoLastKnown = 'no location available';
  String _geoOrDatabaseWarning = 'not initialized';
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
      _geoOrDatabaseWarning += e.toString();
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
      // _geoOrDatabaseWarning = warning;
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
          title: const Text('Hedge Profiler'),
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
                        color: Color.fromRGBO(0, 96, 205, 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(children: [
                            const Text(
                              'Hedge Profiler',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: currentLocale == "EN"
                                  ? const Icon(Icons.language, color: Colors.green)
                                  : const Icon(Icons.language, color: Colors.orange),
                              // icon: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
                              onPressed: () async {
                                // toggle and update locale
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (prefs.getString("locale") == "EN") {
                                  prefs.setString("locale", "DE");
                                  currentLocale = "DE";
                                } else {
                                  prefs.setString("locale", "EN");
                                  currentLocale = "EN";
                                }

                                // rebuild form
                                setState(() {});
                                // _nameFormKey.currentState?.rebuildForm();
                              },
                            ),
                            IconButton(
                              icon: _darkMode
                                  ? const Icon(Icons.light_mode)
                                  : const Icon(Icons.dark_mode),
                              // icon: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
                              onPressed: () {
                                setState(() {
                                  _darkMode = !_darkMode;
                                  if (_darkMode) {
                                    HedgeProfilerApp.of(context)
                                        .changeTheme(ThemeMode.dark);
                                  } else {
                                    HedgeProfilerApp.of(context)
                                        .changeTheme(ThemeMode.light);
                                  }
                                });
                              },
                            )
                          ]),
                          Row(
                            children: [
                              const Text('Last known location',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: _updateLocationAndLocales,
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Text(_geoLastKnown,
                              style: const TextStyle(
                                  fontSize: 10, fontStyle: FontStyle.italic)),
                          Text(_geoLastChange,
                              style: const TextStyle(
                                  fontSize: 10, fontStyle: FontStyle.italic)),
                          Text(_geoOrDatabaseWarning,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.eco_rounded, color: Colors.green),
                      title: const Text('Rate Hedge'),
                      onTap: () {
                        setState(() {
                          _showNameForm = true;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.map_outlined, color: Colors.red),
                      title: const Text('Arcanum'),
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
                          const Icon(Icons.map_outlined, color: Colors.blue),
                      title: const Text('Bodenkarte'),
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
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
            if (_showNameForm)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
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
}

class NameForm extends StatefulWidget {
  final GlobalKey<NameFormState> formKey;

  const NameForm({Key? key, required this.formKey}) : super(key: key);

  @override
  State<NameForm> createState() => NameFormState();
}

/// form page
class NameFormState extends State<NameForm> {
  // final _formKey = GlobalKey<FormState>();
  // GlobalKey<NameFormState> get _formKey => widget.formKey;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<File> _selectedImages = [];

  // bool _isSaving = false;
  ValueNotifier<bool> _isSaving = ValueNotifier<bool>(false);
  List<Map<String, dynamic>> inputFields = [];
  List<Map<String, dynamic>> dynamicFields = [];
  List<Map<String, dynamic>> sections = getSections();
  List<GlobalKey<DynamicDropdownsState>> _dropdownsKeys = [];
  Map<String, double> _radarChartData =
      {}; // after weighting etc. to display in graph
  Map<String, dynamic> _radarChartDataListsReduced =
      {}; // after reading raw scores and calculating means/sums
  Map<String, dynamic> _radarChartDataFull = {};

  int _selectedIndex = 0;
  int _selectedIndexCheck = 0;
  bool _triggeredByMenu = false;
  Map<String, bool> menuStatus = {};

  final Map<String, String> _radarDataToGroup = {
    'Rohstoffe': 'Bereitstellend',
    'Ertragssteigerung': 'Bereitstellend',
    'Klimaschutz': 'Regulierend',
    'Wasserschutz': 'Regulierend',
    'Bodenschutz': 'Regulierend',
    'Nähr- & Schadstoffkreisläufe': 'Regulierend',
    'Bestäubung': 'Regulierend',
    'Schädlings- & Krankheitskontrolle': 'Regulierend',
    'Nahrungsquelle': 'Habitat',
    'Korridor': 'Habitat',
    'Fortpflanzungs- & Ruhestätte': 'Habitat',
    'Erholung & Tourismus': 'Kulturell',
    'Kulturerbe': 'Kulturell'
  };
  final Map<String, Color> _radarGroupColors = {
    'Bereitstellend': Colors.red,
    'Regulierend': Colors.blue,
    'Habitat': Colors.green,
    'Kulturell': Colors.orange,
  };

  late String currentLocale = '';
  LocaleMap localeMap = LocaleMap();
  Map<String, String> localeToOriginal = {};
  Map<String, String> originalToLocale = {};

  // top menu stuff
  String selectedMenuItem = "";
  List<String> menuItems = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeForm();
  }

  Future<void> initializeForm() async {
    await refreshCurrentLocale();
    inputFields = createFormFields();
    dynamicFields = createDynamicFormFields();

    localeMap.initialize(inputFields, dynamicFields, sections);
    localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
    originalToLocale = localeMap.getOriginalToLocale(currentLocale);

    _dropdownsKeys = List.generate(
        dynamicFields.length, (_) => GlobalKey<DynamicDropdownsState>());

    menuItems =
        sections.map((s) => s["label$currentLocale"].toString()).toList();

    for (var menu in sections) {
      menuStatus[menu["label"]] = false;
    }

    _populateStaticInputFields();
    _checkPermissions();
    _getLostImageData();
    _loadPersistedImages();
  }

  /// populate input fields on page init;
  /// dynamic fields are populated in DynamicDropdowns class
  /// from SharedPreferences
  void _populateStaticInputFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var field in inputFields) {
      if (field['type'] == 'text' || field['type'] == 'number') {
        field['controller'].text = prefs.getString(field['label']) ?? '';
      } else if (field['type'] == 'dropdown') {
        field['selectedValue'] = prefs.getString(field['label']) ?? '';
      }
    }
    setState(() {});
  }

  /// action triggered by DynamicDropdowns onChanged events (select + remove)
  void onDynamicDropdownsChanged(
      String dropdownKey, String dropdownValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? originalDropdownKey = localeToOriginal[dropdownKey];
    // in case dropdown gets removed, remove key/val from preferences
    if (dropdownValue == "" &&
        sharedPreferences.get(originalDropdownKey!) != null) {
      sharedPreferences.remove(originalDropdownKey);
    } else {
      // otherwise, add/update preferences with dropdown values
      sharedPreferences.setString(originalDropdownKey!, dropdownValue);
    }
  }

  /// action triggered by static widgets onChanged events
  void onStaticWidgetChanged(String widgetLabel, String widgetValue) async {
    // inputFields[widgetLabel]["selectedValue"] = widgetValue;
    // write to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widgetLabel, widgetValue);

    // validate all widgets of that section are checked
    print("$widgetLabel $widgetValue");
  }

  /// action for Clear button
  void _clearInputStorage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Are you sure you want to clear the form data?',
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    );
    if (confirmed == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Object? lat = prefs.get("latitude");
      Object? lon = prefs.get("longitude");
      Object? geoLastChange = prefs.get("geoLastChange");
      prefs.clear();
      prefs.setString("latitude", lat.toString());
      prefs.setString("longitude", lon.toString());
      prefs.setString("geoLastChange", geoLastChange.toString());
      _populateStaticInputFields();

      // trigger rebuild of dynamic dropdowns
      for (GlobalKey<DynamicDropdownsState> dropdownKey in _dropdownsKeys) {
        dropdownKey.currentState?.rebuild();
      }
    }
  }

  /// get form and image data and persist to database
  void _saveFormData() async {
    // clear validation warnings
    // setState(() {});

    // re-map preferences (contains all input fields)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataMap = {};
    for (String key in prefs.getKeys()) {
      dataMap[key] = prefs.get(key);
    }

    // start loading indicator
    _isSaving.value = true;

    // write to the database, show snackbar with result, stop loading indicator
    db.writeDocument(dataMap, _selectedImages, (success, message) {
      _isSaving.value = false;
      showSnackbar(context, message, success: success);
    });
  }

  Future<void> _loadPersistedImages() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    final imagesDirectory = Directory('${directory?.path}/Pictures');
    if (await imagesDirectory.exists()) {
      final files = await imagesDirectory.list().toList();
      _selectedImages = files.map((file) => File(file.path)).toList();
      setState(() {});
    }
  }

  Future<void> _persistImages() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    final imagesDirectory = Directory('${directory?.path}/Pictures');
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create();
    }
    for (final image in _selectedImages) {
      final path = '${imagesDirectory.path}/${image.path.split('/').last}';
      await image.copy(path);
    }
  }

  Future<void> _addImage(ImageSource source) async {
    final picker = ImagePicker();
    // set image quality to 50% to save storage
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
      _persistImages();
    }
  }

  void _removeImage(int index) async {
    final File image = _selectedImages[index];
    setState(() {
      _selectedImages.removeAt(index);
    });
    await image.delete();
    _persistImages();
  }

  Future<void> _clearImages() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Are you sure you want to delete all images?',
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    );
    if (confirmed == true) {
      for (final image in _selectedImages) {
        await image.delete();
      }
      _selectedImages.clear();
      final directory = await getExternalStorageDirectory();
      final imagesDirectory = Directory('${directory?.path}/Pictures');
      if (await imagesDirectory.exists()) {
        await imagesDirectory.delete(recursive: true);
      }
      setState(() {});
    }
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Form Data'),
          content: const Text('Do you want to clear the images '
              'or the text in the form?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlinedButton(
                  child:
                      const Text('Images', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearImages();
                  },
                ),
                OutlinedButton(
                  child:
                      const Text('Form', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearInputStorage();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _getLostImageData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      showSnackbar(context, "recovered images successfully");
      _selectedImages.addAll(files as Iterable<File>);
    } else {
      showSnackbar(context, "couldn't restore images - ${response.exception}",
          success: false);
    }
  }

  void _checkPermissions() async {
    if (await Permission.storage.request().isDenied) {
      showSnackbar(
          context, "No storage permission - cannot write images to storage",
          success: false);
    }
    // if (await Permission.camera.request().isDenied) {
    //   _showSnackBar("No camera permission - cannot take pictures", success: false);
    // }
  }

  void resetRadarChartData() {
    _radarChartDataFull = {
      'Rohstoffe': {},
      'Ertragssteigerung': {},
      'Klimaschutz': {},
      'Wasserschutz': {},
      'Bodenschutz': {},
      'Nähr- & Schadstoffkreisläufe': {},
      'Bestäubung': {},
      'Schädlings- & Krankheitskontrolle': {},
      'Nahrungsquelle': {},
      'Korridor': {},
      'Fortpflanzungs- & Ruhestätte': {},
      'Erholung & Tourismus': {},
      'Kulturerbe': {},
    };

    _radarChartDataListsReduced = {};
  }

  Future<void> updateRadarChartData() async {
    resetRadarChartData();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // iterate over static fields, get values for each group based on _radarDataToGroup
    for (var inputField in inputFields) {
      for (String group in _radarChartDataFull.keys) {
        if (inputField["type"] == "dropdown" &&
            inputField.containsKey("valueMap") &&
            inputField["valueMap"].containsKey(group)) {
          if (inputField["selectedValue"] == "") {
            _radarChartDataFull[group][inputField["label"]] = 0;
          } else {
            int dropdownValueIndex =
                inputField["values"].indexOf(inputField["selectedValue"]);
            var dropdownScore =
                inputField["valueMap"][group][dropdownValueIndex];
            _radarChartDataFull[group][inputField["label"]] = dropdownScore;
          }
        }
      }
    }

    // iterate over dynamic fields, collect values via shared prefs
    for (var dynamicField in dynamicFields) {
      for (String group in _radarChartDataFull.keys) {
        if (dynamicField.containsKey("valueMap") &&
            dynamicField["valueMap"].containsKey(group)) {
          int maxDropdownCount = 6;
          if (dynamicField.containsKey("maxDropdownCount")) {
            maxDropdownCount = dynamicField["maxDropdownCount"];
          }

          // iterate over nested dropdowns
          // double scoreSum = 0;
          List<double> nestedScores = [];
          for (int i = 1; i <= maxDropdownCount; i++) {
            // get stored value from shared prefs, if existent
            String? selectedValue =
                prefs.getString(dynamicField["headerText"] + "_$i");
            int dropdownValueIndex =
                dynamicField["defValues"].indexOf(selectedValue ?? '');
            double? dropdownScore =
                dynamicField["valueMap"][group][dropdownValueIndex]?.toDouble();
            if (dropdownScore != null) {
              nestedScores.add(dropdownScore);
              // sum up values
              // scoreSum += dropdownScore;
            }
          }

          // write to map
          _radarChartDataFull[group][dynamicField["headerText"]] = nestedScores;
        }
      }
    }

    // write to _radarChartDataListsReduced, based on the name of the lists, calculate mean or sum
    for (var fullData in _radarChartDataFull.entries) {
      String group = fullData.key;
      if (!_radarChartDataListsReduced.containsKey(group)) {
        _radarChartDataListsReduced[group] = {};
      }
      for (var score in fullData.value.entries) {
        String scoreKey = score.key;
        var scoreValue = score.value;
        if (scoreValue is List) {
          // calculate sum of list values
          double scoreSum = 0;
          for (double singleScore in scoreValue) {
            scoreSum = scoreSum + singleScore;
          }

          // in case of nachbar_flaechen, calculate mean of list values
          if (scoreKey == "nachbar_flaechen") {
            scoreSum = scoreSum / scoreValue.length;
            if (scoreSum.isNaN) {
              scoreSum = 0;
            }
          }
          _radarChartDataListsReduced[group][scoreKey] = scoreSum;
        } else {
          // append without modification
          _radarChartDataListsReduced[group][scoreKey] = scoreValue;
        }
      }
    }

    // rohstoffe - min 1, max 5, sum of values
    double rohstoffeSum = getGroupSum("Rohstoffe");
    rohstoffeSum = max(min(rohstoffeSum, 5), 1);

    // ertragssteigerung - if nachbarflächen > 0 = 1, else rounded mean
    double ertragNachbarValue =
        getItem("Ertragssteigerung", "nachbar_flaechen");
    double ertragssteigerungSum = ertragNachbarValue > 0
        ? getFixedGroupAverage("Ertragssteigerung", 4)
        : 1;

    // klimaschutz
    double klimaschutzSum = getGroupAverage("Klimaschutz");

    // wasserschutz
    List<double> wasserschutzHangValues =
        getList("Wasserschutz", ["hang_position", "hang_neigung"]);
    double wasserschutzHangSum = wasserschutzHangValues.reduce(min);
    List<double> wasserschutzFlaecheValues =
        getList("Wasserschutz", ["hecken_dichte", "hecken_breite"]);
    double wasserschutzFlaecheSum = wasserschutzFlaecheValues.reduce(max);
    List<double> wasserschutzSumValues = getList("Wasserschutz",
        ["horizontale_schichtung", "saum_breite", "nutzbare_feldkapazitaet"]);
    wasserschutzSumValues.addAll([wasserschutzHangSum, wasserschutzFlaecheSum]);
    double wasserschutzSum = getFixedAverage(wasserschutzSumValues, 4);

    // bodenschutz
    List<double> bodenschutzHangValues =
        getList("Bodenschutz", ["hang_position", "hang_neigung"]);
    double bodenschutzHangSum = bodenschutzHangValues.reduce(min);
    List<double> bodenschutzLageValues = getList("Bodenschutz",
        ["himmelsrichtung", "hecken_dichte", "klimatische_wasserbilanz"]);
    bodenschutzLageValues.add(bodenschutzHangSum);
    double bodenschutzLageSum = bodenschutzLageValues.reduce(max);
    List<double> bodenschutzSumValues =
        getList("Bodenschutz", ["luecken", "hecken_hoehe", "hecken_breite"]);
    bodenschutzSumValues.add(bodenschutzLageSum);
    double bodenschutzSum = getAverage(bodenschutzSumValues);

    // nähr- & schadstoffkreisläufe
    List<double> naehrstoffHangValues = getList(
        "Nähr- & Schadstoffkreisläufe", ["hang_position", "hang_neigung"]);
    double naehrstoffHangSum = naehrstoffHangValues.reduce(min);
    List<double> naehrstoffSumValues = getList("Nähr- & Schadstoffkreisläufe", [
      "nutzbare_feldkapazitaet",
      "totholz",
      "hecken_breite",
      "sonder_form",
      "nachbar_flaechen"
    ]);
    naehrstoffSumValues.add(naehrstoffHangSum);
    double naehrstoffSum = getFixedAverage(naehrstoffSumValues, 5);

    // bestäubung
    List<double> bestaeubungStrukturValues = getList(
        "Bestäubung", ["totholz", "alterszusammensetzung", "sonder_form"]);
    bestaeubungStrukturValues
        .add(getProduct("Bestäubung", ["saum_art", "saum_breite"]));
    double bestaebungStrukturSum =
        getFixedAverage(bestaeubungStrukturValues, 4, round: false);
    List<double> bestaeubungLageValues = getList(
        "Bestäubung", ["nachbar_flaechen", "netzwerk", "hecken_dichte"]);
    double bestaeubungLageSum = getSum(bestaeubungLageValues) / 2;
    List<double> bestaeubungPflanzenValues = getList(
        "Bestäubung", ["anzahl_gehoelz_arten", "dominanzen", "neophyten"]);
    double bestaeubungPflanzenSum = getAverage(bestaeubungPflanzenValues);
    List<double> bestaeubungNutzungValues =
        getList("Bestäubung", ["nutzungs_spuren", "management"]);
    double bestaeubungNutzungSum = getSum(bestaeubungNutzungValues);
    double bestaeubungSum = getSum([
      bestaebungStrukturSum,
      bestaeubungLageSum,
      bestaeubungPflanzenSum,
      bestaeubungNutzungSum
    ]);
    bestaeubungSum = bestaeubungSum / 3;
    bestaeubungSum = bestaeubungSum.roundToDouble();

    // schädlungs- & krankheitskontrolle
    List<double> schaedlingStrukturValues = getList(
        "Schädlings- & Krankheitskontrolle", [
      "horizontale_schichtung",
      "strukturvielfalt",
      "sonder_form",
      "luecken"
    ]);
    schaedlingStrukturValues.add(getProduct(
        "Schädlings- & Krankheitskontrolle", ["saum_art", "saum_breite"]));
    double schaedlingStrukturSum = getSum(schaedlingStrukturValues) / 3;
    schaedlingStrukturSum = min(5, schaedlingStrukturSum);
    List<double> schaedlingLageValues =
        getList("Schädlings- & Krankheitskontrolle", ["himmelsrichtung"]);
    schaedlingLageValues.add(getItem(
        "Schädlings- & Krankheitskontrolle", "hecken_dichte",
        multiplicator: 2));
    double schaedlingLageSum = getSum(schaedlingLageValues) / 3;
    schaedlingLageSum = min(5, schaedlingLageSum);
    List<double> schaedlingPflanzenValues = getList(
        "Schädlings- & Krankheitskontrolle", ["baumanteil", "neophyten"]);
    schaedlingPflanzenValues.add(getItem(
        "Schädlings- & Krankheitskontrolle", "anzahl_gehoelz_arten",
        multiplicator: 2));
    double schaedlingPflanzenSum = getSum(schaedlingPflanzenValues) / 3;
    schaedlingPflanzenSum = min(5, schaedlingPflanzenSum);
    double schaedlingSum = getAverage([
      schaedlingStrukturSum,
      schaedlingStrukturSum,
      schaedlingLageSum,
      schaedlingPflanzenSum
    ]);

    // Nahrungsquelle
    double nahrungsquelleStrukturSum =
        getProduct("Nahrungsquelle", ["saum_art", "saum_breite"]);
    nahrungsquelleStrukturSum += getItem("Nahrungsquelle", "totholz");
    nahrungsquelleStrukturSum = nahrungsquelleStrukturSum / 2;
    double nahrungsquellePflanzenSum = getAverage(
        getList("Nahrungsquelle",
            ["neophyten", "dominanzen", "anzahl_gehoelz_arten"]),
        round: false);
    double nahrungsquelleSum = getAverage([
      nahrungsquelleStrukturSum,
      nahrungsquellePflanzenSum,
      nahrungsquellePflanzenSum
    ]);

    // Korridor
    double korridorStrukturSum = getAverage(
        getList("Korridor", ["luecken", "hecken_hoehe", "hecken_breite"]),
        round: false);
    double korridorLageSum = getSum(getList(
            "Korridor", ["hecken_dichte", "in_wildtierkorridor", "netzwerk"])) /
        2;
    double korridorSum =
        getAverage([korridorStrukturSum, korridorLageSum, korridorLageSum]);

    // Fortpflanzungs- und Ruhestätte
    List<double> fortpflanzungsStukturValues =
        getList("Fortpflanzungs- & Ruhestätte", [
      "sonder_form",
      "alterszusammensetzung",
      "totholz",
      "strukturvielfalt",
      "vertikale_schichtung",
      "horizontale_schichtung",
      "hecken_hoehe",
      "hecken_breite"
    ]);
    fortpflanzungsStukturValues.add(getProduct(
        "Fortpflanzungs- & Ruhestätte", ["saum_art", "saum_breite"]));
    double fortpflanzungsStrukturSum = getSum(fortpflanzungsStukturValues) / 6;
    double fortpflanzungsLageSum = getSum(getList(
        "Fortpflanzungs- & Ruhestätte", ["hecken_dichte", "nachbar_flaechen"]));
    double fortpflanzungsPflanzenSum = getAverage(
        getList("Fortpflanzungs- & Ruhestätte",
            ["anzahl_gehoelz_arten", "dominanzen"]),
        round: false);
    double fortpflanzungsSum = getAverage([
      fortpflanzungsStrukturSum,
      fortpflanzungsStrukturSum,
      fortpflanzungsLageSum,
      fortpflanzungsPflanzenSum
    ]);

    // Erholung
    double erholungLandschaftSum = getSum(getList("Erholung & Tourismus", [
      "schutzgebiet",
      "hecken_dichte",
      "alterszusammensetzung",
      "anzahl_gehoelz_arten"
    ]));
    erholungLandschaftSum +=
        getProduct("Erholung & Tourismus", ["saum_art", "saum_breite"]);
    erholungLandschaftSum = erholungLandschaftSum / 4;
    double erholungMenschlichSum = getSum(getList("Erholung & Tourismus",
        ["bevoelkerungs_dichte", "erschliessung", "zusatz_strukturen"]));
    erholungMenschlichSum = min(erholungMenschlichSum / 2, 5);
    double erholungErschliessungVal =
        getItem("Erholung & Tourismus", "erschliessung");
    double erholungSum = erholungErschliessungVal == 1
        ? 1
        : getAverage([erholungMenschlichSum, erholungLandschaftSum]);

    // Kulturerbe
    double kulturerbeSum = getSum(getList("Kulturerbe", [
      "naturdenkmal",
      "traditionelle_heckenregion",
      "franziszeischer_kataster",
      "netzwerk",
      "neophyten",
      "zusatz_strukturen",
      "sonder_form"
    ]));
    kulturerbeSum += getItem("Kulturerbe", "franziszeischer_kataster");
    kulturerbeSum = kulturerbeSum / 5;
    kulturerbeSum = min(kulturerbeSum, 5).roundToDouble();

    _radarChartData = {
      'Rohstoffe': rohstoffeSum,
      'Ertragssteigerung': ertragssteigerungSum,
      'Klimaschutz': klimaschutzSum,
      'Wasserschutz': wasserschutzSum,
      'Bodenschutz': bodenschutzSum,
      'Nähr- & Schadstoffkreisläufe': naehrstoffSum,
      'Bestäubung': bestaeubungSum,
      'Schädlings- & Krankheitskontrolle': schaedlingSum,
      'Nahrungsquelle': nahrungsquelleSum,
      'Korridor': korridorSum,
      'Fortpflanzungs- & Ruhestätte': fortpflanzungsSum,
      'Erholung & Tourismus': erholungSum,
      'Kulturerbe': kulturerbeSum,
    };

    print('k');

    // idk if i need this
    setState(() {});
  }

  /// maps a Map<String, double> to List<double>
  List<double> mapToListOfDoubles(var map) {
    List<double> values = [];
    for (var elem in map.values) {
      values.add(elem.toDouble());
    }
    return values;
  }

  /// returns sum for a list of doubles
  double getSum(List<double> values, {bool round = true}) {
    double sum = values.reduce((v, e) => (v + e));
    if (!round) {
      return sum;
    }
    return sum.roundToDouble();
  }

  /// returns sum for all values of a group
  double getGroupSum(String group) {
    return getSum(mapToListOfDoubles(_radarChartDataListsReduced[group]));
  }

  /// returns average for a list of doubles
  double getAverage(List<double> values, {bool round = true}) {
    double average = values.reduce((v, e) => (v + e)) / values.length;
    if (!round) {
      return average;
    }
    return average.roundToDouble();
  }

  /// returns average for all values of a group
  double getGroupAverage(String group, {bool round = true}) {
    return getAverage(mapToListOfDoubles(_radarChartDataListsReduced[group]),
        round: round);
  }

  /// returns sum divided by divisor for a list of doubles
  double getFixedAverage(List<double> values, int divisor,
      {bool round = true}) {
    double fixedAverage = values.reduce((v, e) => (v + e)) / divisor;
    if (!round) {
      return fixedAverage;
    }
    return fixedAverage.roundToDouble();
  }

  /// returns sum divided by divisor for all values of a group
  double getFixedGroupAverage(String group, int divisor, {bool round = true}) {
    return getFixedAverage(
        mapToListOfDoubles(_radarChartDataListsReduced[group]), divisor,
        round: round);
  }

  /// returns a list of doubles from group and parameters
  List<double> getList(String group, List<String> parameters) {
    List<double> values = [];
    for (var entry in _radarChartDataListsReduced[group].entries) {
      if (parameters.contains(entry.key)) {
        values.add(entry.value.toDouble());
      }
    }
    return values;
  }

  /// Returns a single item from the map, allows multiplications
  double getItem(String group, String parameter, {multiplicator: 1}) {
    for (var entry in _radarChartDataListsReduced[group].entries) {
      if (entry.key == parameter) {
        return entry.value.toDouble() * multiplicator;
      }
    }
    return 0.0;
  }

  double getProduct(String group, List<String> parameters) {
    List<double> productValues = getList(group, parameters);
    if (productValues.isEmpty) {
      return 0.0;
    }
    return productValues.fold(
        1.0, (previousValue, element) => previousValue * element);
  }

  Future<String> refreshCurrentLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString("locale");
    localeMap.initialize(inputFields, dynamicFields, sections);
    localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
    originalToLocale = localeMap.getOriginalToLocale(currentLocale);
    return locale ?? "EN";
  }

  void _onMenuItemSelected(String item) {
    setState(() {
      selectedMenuItem = localeToOriginal[item]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex != _selectedIndexCheck || _triggeredByMenu) {
      _selectedIndexCheck = _selectedIndex;
      _triggeredByMenu = false;
      return _buildReducedForm();
    }

    return FutureBuilder<String>(
      future: refreshCurrentLocale(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
            print('loading');
          default:
            currentLocale = snapshot.data.toString();
            localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
            originalToLocale = localeMap.getOriginalToLocale(currentLocale);
            return _buildReducedForm();
        }
      },
    );
  }

  Widget _buildReducedForm() {
    // Determine amount of columns based on screen width and orientation
    final mediaQueryData = MediaQuery.of(context);
    final columns = determineRequiredColumns(mediaQueryData);
    final dynamicColumns =
        determineRequiredColumnsDynamicDropdowns(mediaQueryData);

    Map<String, String> sectionToLocale = {};
    for (var sec in sections) {
      sectionToLocale[sec["label"]] = sec["label$currentLocale"];
    }

    return Scaffold(
      body: Material(
        child: Form(
          key: widget.formKey,
          child: Row(children: [
            Expanded(
              child: SingleChildScrollView(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: [
                      buildMenuPage("general", columns, dynamicColumns),
                      buildMenuPage("gis", columns, dynamicColumns),
                      buildMenuPage("gelaende", columns, dynamicColumns),
                      buildImagePage("images"),
                    ],
                  ),
                  // Text("something: $_selectedIndex $currentLocale"),
                ],
              ),),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 120),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    groupAlignment: -1.0,
                    onDestinationSelected: (int index) {
                      _triggeredByMenu = true;
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.selected,
                    destinations: [
                      NavigationRailDestination(
                          icon: Icon(Icons.favorite_border,
                              color: menuStatus["general"] == true
                                  ? Colors.green
                                  : Colors.orange),
                          selectedIcon: Icon(Icons.favorite,
                              color: menuStatus["general"] == true
                                  ? Colors.green
                                  : Colors.orange),
                          label: Text(sectionToLocale["general"]!)),
                      NavigationRailDestination(
                          icon: Icon(Icons.favorite_border,
                              color: menuStatus["gis"] == true
                                  ? Colors.green
                                  : Colors.orange),
                          selectedIcon: Icon(Icons.favorite,
                              color: menuStatus["gis"] == true
                                  ? Colors.green
                                  : Colors.orange),
                          label: Text(sectionToLocale["gis"]!)),
                      NavigationRailDestination(
                          icon: Icon(Icons.favorite_border,
                              color: menuStatus["gelaende"] == true
                                  ? Colors.green
                                  : Colors.orange),
                          selectedIcon: Icon(Icons.favorite,
                              color: menuStatus["gelaende"] == true
                                  ? Colors.green
                                  : Colors.orange),
                          label: Text(sectionToLocale["gelaende"]!)),
                      NavigationRailDestination(
                          icon: Icon(Icons.favorite_border,
                              color: _selectedImages.isNotEmpty
                                  ? Colors.green
                                  : Colors.orange),
                          selectedIcon: Icon(Icons.favorite,
                              color: _selectedImages.isNotEmpty
                                  ? Colors.green
                                  : Colors.orange),
                          label: Text(sectionToLocale["images"]!)),
                    ],
                    trailing: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 50),
                          IconButton(
                            icon: Icon(Icons.clear,
                                color: Theme.of(context).colorScheme.error),
                            onPressed: () => _showClearDialog(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_library),
                            onPressed: () => _addImage(ImageSource.gallery),
                            // onPressed: () => showSnackbar(context, "fredl", success: false),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () => _addImage(ImageSource.camera),
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.send_and_archive_sharp),
                                onPressed: () => _saveFormData(),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: _isSaving,
                                builder: (context, value, child) {
                                  return value
                                      ? Positioned.fill(
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                          ),
                                        )
                                      : SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildMenuPage(String section, var columns, var dynamicColumns) {
    return Column(children: [
      createHeader(originalToLocale[section]!),
      const Divider(),
      buildFormFieldGrid(inputFields, section, currentLocale,
          onWidgetChanged: onStaticWidgetChanged, columns: columns),
      buildDynamicFormFieldGrid(
        children: dynamicFields,
        section: section,
        dropdownKeys: _dropdownsKeys,
        onDropdownChanged: onDynamicDropdownsChanged,
        currentLocale: currentLocale,
        columns: dynamicColumns,
      ),
    ]);
  }

  Widget buildImagePage(String section) {
    return Column(children: [
      createHeader(originalToLocale[section]!),
      const Divider(),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _selectedImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Image.file(_selectedImages[index], fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: -5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.highlight_remove, color: Colors.red),
                  onPressed: () => _removeImage(index),
                ),
              ),
            ],
          );
        },
      ),
    ]);
  }

  Widget _buildForm() {
    // Determine amount of columns based on screen width and orientation
    final mediaQueryData = MediaQuery.of(context);
    final columns = determineRequiredColumns(mediaQueryData);
    final dynamicColumns =
        determineRequiredColumnsDynamicDropdowns(mediaQueryData);

    return Scaffold(
      body: Material(
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  createHeader(originalToLocale["general"]!),
                  buildFormFieldGrid(
                      inputFields, 'general', currentLocale,
                      onWidgetChanged: onStaticWidgetChanged, columns: columns),
                  buildDynamicFormFieldGrid(
                    children: dynamicFields,
                    section: 'general',
                    dropdownKeys: _dropdownsKeys,
                    onDropdownChanged: onDynamicDropdownsChanged,
                    currentLocale: currentLocale,
                    columns: dynamicColumns,
                  ),
                  const Divider(),
                  createHeader(originalToLocale["gis"]!),
                  buildFormFieldGrid(
                      inputFields, 'gis', currentLocale,
                      onWidgetChanged: onStaticWidgetChanged, columns: columns),
                  buildDynamicFormFieldGrid(
                      children: dynamicFields,
                      section: 'gis',
                      dropdownKeys: _dropdownsKeys,
                      onDropdownChanged: onDynamicDropdownsChanged,
                      currentLocale: currentLocale,
                      columns: dynamicColumns),
                  const SizedBox(height: 16),
                  const Divider(),
                  createHeader(originalToLocale["gelaende"]!),
                  buildFormFieldGrid(
                      inputFields, "gelaende", currentLocale,
                      onWidgetChanged: onStaticWidgetChanged, columns: columns),
                  buildDynamicFormFieldGrid(
                      children: dynamicFields,
                      section: 'gelaende',
                      dropdownKeys: _dropdownsKeys,
                      onDropdownChanged: onDynamicDropdownsChanged,
                      currentLocale: currentLocale,
                      columns: dynamicColumns),
                  const Divider(),
                  createHeader(originalToLocale["anmerkungen"]!),
                  buildFormFieldGrid(
                      inputFields, "anmerkungen", currentLocale,
                      onWidgetChanged: onStaticWidgetChanged, columns: columns),
                  buildDynamicFormFieldGrid(
                      children: dynamicFields,
                      section: 'anmerkungen',
                      dropdownKeys: _dropdownsKeys,
                      onDropdownChanged: onDynamicDropdownsChanged,
                      currentLocale: currentLocale,
                      columns: dynamicColumns),
                  const Divider(),
                  createHeader(originalToLocale["images"]!),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Image.file(_selectedImages[index], fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: -5,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.highlight_remove,
                                  color: Colors.red),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () {
                _showClearDialog();
              },
              child: Text(
                'Clear',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.error),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library, size: 32),
              onPressed: () => _addImage(ImageSource.gallery),
              // onPressed: () => showSnackbar(context, "fredl", success: false),
            ),
            IconButton(
              icon: const Icon(Icons.add_a_photo, size: 32),
              onPressed: () => _addImage(ImageSource.camera),
            ),
            Stack(
              children: [
                FilledButton(
                  onPressed: () {
                    _saveFormData();
                    // if (_formKey.currentState!.validate()) {
                    //   _formKey.currentState!.save();
                    //   _saveFormData();
                    // }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // if (_isSaving)
                //   Positioned.fill(
                //     child: Center(
                //       child: CircularProgressIndicator(
                //           color: Theme.of(context).colorScheme.inversePrimary),
                //     ),
                //   ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FutureBuilder(
                future: updateRadarChartData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return RadarChartDialog(
                      data: _radarChartData,
                      dataToGroup: _radarDataToGroup,
                      groupColors: _radarGroupColors,
                    );
                  } else {
                    return const CircularProgressIndicator(); // or any other loading indicator
                  }
                },
              );
            },
          );
        },
        child: const Icon(Icons.analytics_outlined),
      ),
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

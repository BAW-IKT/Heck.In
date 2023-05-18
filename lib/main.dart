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
import 'utils_geo.dart' as geo;
import 'utils_db.dart' as db;
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
  var loadingPercentage = 0;
  late final WebViewController _controller;
  bool _showNameForm = true;
  final NameForm _nameForm = const NameForm();
  String _currentUrlStem = '';
  String _geoLastChange = 'never updated';
  String _geoLastKnown = 'no location available';
  String _geoOrDatabaseWarning = 'not initialized';
  bool _darkMode = true;

  /// refreshes geo coordinates and updates variables for menu accordingly
  _updateLocationWrapper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? warning = await geo.updateLocation();
    setState(() {
      _geoOrDatabaseWarning = warning;
      _geoLastChange = prefs.getString("geoLastChange")?.split(".")[0] ?? 'n/a';
      String lat = prefs.getString("latitude") ?? "n/a";
      String lon = prefs.getString("longitude") ?? "n/a";
      _geoLastKnown = "lat: $lat\nlon: $lon";
    });
  }

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

    _updateLocationWrapper();
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

  /// scaffold of app with menu drawer and WebViewWidget as body
  /// NameForm is stacked on top and controlled with _showNameForm
  @override
  Widget build(BuildContext context) {
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
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 96, 205, 1),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          const Text(
                            'Hedge Profiler',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _updateLocationWrapper,
                            icon: const Icon(Icons.refresh),
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
                        const Text('Last known location',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
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
                  child: _nameForm,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// loads a page
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

/// form page
class _NameFormState extends State<NameForm> {
  final _formKey = GlobalKey<FormState>();
  List<File> _selectedImages = [];
  bool _isSaving = false;
  List<Map<String, dynamic>> inputFields = [];
  List<Map<String, dynamic>> dynamicFields = [];
  List<GlobalKey<DynamicDropdownsState>> _dropdownsKeys = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    inputFields = createFormFields();
    dynamicFields = createDynamicFormFields();
    _dropdownsKeys = List.generate(
        dynamicFields.length, (_) => GlobalKey<DynamicDropdownsState>());
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
    // in case dropdown gets removed, remove key/val from preferences
    if (dropdownValue == "" && sharedPreferences.get(dropdownKey) != null) {
      sharedPreferences.remove(dropdownKey);
    } else {
      // otherwise, add/update preferences with dropdown values
      sharedPreferences.setString(dropdownKey, dropdownValue);
    }
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
      prefs.clear();
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
    setState(() {

    });
    
    // re-map preferences (contains all input fields)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataMap = {};
    for (String key in prefs.getKeys()) {
      dataMap[key] = prefs.get(key);
    }

    // start loading indicator
    setState(() {
      _isSaving = true;
    });

    // write to the database, show snackbar with result, stop loading indicator
    db.writeDocument(dataMap, _selectedImages, (success, message) {
      setState(() {
        _isSaving = false;
      });
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

  @override
  Widget build(BuildContext context) {
    // Determine amount of columns based on screen width and orientation
    final mediaQueryData = MediaQuery.of(context);
    final columns = determineRequiredColumns(mediaQueryData);
    final dynamicColumns =
        determineRequiredColumnsDynamicDropdowns(mediaQueryData);

    return Scaffold(
      body: Material(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildFormFieldGrid(inputFields, 'General', setState,
                      columns: columns),
                  buildDynamicFormFieldGrid(
                    children: dynamicFields,
                    section: 'General',
                    dropdownKeys: _dropdownsKeys,
                    onDropdownChanged: onDynamicDropdownsChanged,
                    columns: dynamicColumns,
                  ),
                  const Divider(),
                  createHeader("GIS"),
                  buildFormFieldGrid(inputFields, 'GIS', setState,
                      columns: columns),
                  buildDynamicFormFieldGrid(
                      children: dynamicFields,
                      section: 'GIS',
                      dropdownKeys: _dropdownsKeys,
                      onDropdownChanged: onDynamicDropdownsChanged,
                      columns: dynamicColumns),
                  const SizedBox(height: 16),
                  const Divider(),
                  createHeader("Gelände"),
                  buildFormFieldGrid(inputFields, "Gelände", setState,
                      columns: columns),
                  buildDynamicFormFieldGrid(
                      children: dynamicFields,
                      section: 'Gelände',
                      dropdownKeys: _dropdownsKeys,
                      onDropdownChanged: onDynamicDropdownsChanged,
                      columns: dynamicColumns),
                  const Divider(),
                  createHeader("Anmerkungen"),
                  buildFormFieldGrid(inputFields, "Anmerkungen", setState,
                      columns: columns),
                  buildDynamicFormFieldGrid(
                      children: dynamicFields,
                      section: 'Anmerkungen',
                      dropdownKeys: _dropdownsKeys,
                      onDropdownChanged: onDynamicDropdownsChanged,
                      columns: dynamicColumns),
                  const Divider(),
                  createHeader("Images"),
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveFormData();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_isSaving)
                  Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
              ],
            ),
          ],
        ),
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

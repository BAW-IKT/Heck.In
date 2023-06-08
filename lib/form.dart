import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'colors.dart';
import 'dynamic_dropdowns.dart';
import 'form_data.dart';
import 'dart:io';
import 'form_utils.dart';
import 'utils_db.dart' as db;
import 'snackbar.dart';
import 'radar_chart.dart';
import 'form_calc.dart';

class NameForm extends StatefulWidget {
  final GlobalKey<NameFormState> formKey;

  const NameForm({Key? key, required this.formKey}) : super(key: key);

  @override
  State<NameForm> createState() => NameFormState();
}

/// form page
class NameFormState extends State<NameForm> {
  List<File> _selectedImages = [];

  final ValueNotifier<bool> _isSaving = ValueNotifier<bool>(false);
  List<Map<String, dynamic>> inputFields = [];
  Map<String, int> inputFieldLabelToIndex = {};
  List<Map<String, dynamic>> dynamicFields = [];
  List<Map<String, dynamic>> sections = getSections();
  List<GlobalKey<DynamicDropdownsState>> _dropdownsKeys = [];

  FormCalc calc = FormCalc();

  // _radarChartData = after weighting etc. to display in graph
  Map<String, double> _radarChartData = {};

  // ..ListsReduced = after reading raw scores and calculating means/sums
  Map<String, dynamic> _radarChartDataListsReduced = {};
  Map<String, dynamic> _radarChartDataFull = {};

  int _selectedIndex = 0;
  int _selectedIndexCheck = 0;
  bool _triggeredByMenu = false;
  final ValueNotifier<bool> _isNavigationRailVisible =
      ValueNotifier<bool>(true);
  Map<String, ValueNotifier<bool>> sectionNotifiers = {
    "general": ValueNotifier<bool>(false),
    "physical": ValueNotifier<bool>(false),
    "environmental": ValueNotifier<bool>(false),
    "biodiversity": ValueNotifier<bool>(false),
  };

  final Map<String, String> _radarDataToGroup = getRadarDataGroups();
  final Map<String, Color> _radarGroupColors = getRadarGroupColors();

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

    for (var i = 0; i < inputFields.length; i++) {
      inputFieldLabelToIndex[inputFields[i]["label"]] = i;
    }
    ;

    dynamicFields = createDynamicFormFields();

    localeMap.initialize(inputFields, dynamicFields, sections);
    localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
    originalToLocale = localeMap.getOriginalToLocale(currentLocale);

    _dropdownsKeys = List.generate(
        dynamicFields.length, (_) => GlobalKey<DynamicDropdownsState>());

    menuItems =
        sections.map((s) => s["label$currentLocale"].toString()).toList();

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
      if (field["type"] == "text" || field["type"] == "number") {
        field["controller"].text = prefs.getString(field["label"]) ?? "";
        field["selectedValue"] = prefs.getString(field["label"]) ?? "";
      } else if (field["type"] == "dropdown") {
        field["selectedValue"] = prefs.getString(field["label"]) ?? "";
      }
    }

    // update sectionNotifiers
    for (String section in sectionNotifiers.keys) {
      _setSectionNotifiers(section);
    }

    // setState(() {});
  }

  /// action triggered by DynamicDropdowns onChanged events (select + remove)
  void onDynamicDropdownsChanged(
      String dropdownKey, String dropdownValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // TODO: probably have to strip EN/DE here
    String cleanDropdownKey = dropdownKey.split("_")[0];
    String dropdownPostfix = dropdownKey.split("_")[1];
    String? originalDropdownKey = localeToOriginal[cleanDropdownKey];
    String concatKeyForStorage = "$originalDropdownKey" "_$dropdownPostfix";
    // in case dropdown gets removed, remove key/val from preferences
    if (dropdownValue == "" &&
        sharedPreferences.get(originalDropdownKey!) != null) {
      sharedPreferences.remove(originalDropdownKey);
    } else {
      // otherwise, add/update preferences with dropdown values

      sharedPreferences.setString(concatKeyForStorage, dropdownValue);
    }
  }

  /// action triggered by static widgets onChanged events
  void onStaticWidgetChanged(String widgetLabel, String widgetValue) async {
    // refresh inputFields for graph etc.
    int widgetIndex = inputFieldLabelToIndex[widgetLabel]!;
    inputFields[widgetIndex]["selectedValue"] = widgetValue;

    // write to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widgetLabel, widgetValue);

    // validate all widgets of that section are checked
    String widgetGroup = inputFields[widgetIndex]["section"];
    _setSectionNotifiers(widgetGroup);
    // bool allFilledOut = true;
    // for (var inputField in inputFields) {
    //   if (inputField["section"] == widgetGroup &&
    //       (!inputField.containsKey("selectedValue") ||
    //           inputField["selectedValue"] == null ||
    //           inputField["selectedValue"] == "")) {
    //     allFilledOut = false;
    //   }
    // }
    // if (allFilledOut) {
    //   sectionNotifiers[widgetGroup]?.value = true;
    // } else {
    //   sectionNotifiers[widgetGroup]?.value = false;
    // }

    print("$widgetLabel $widgetValue");
  }

  /// validates all widgets of a section are checked
  /// and sets sectionNotifier accordingly
  void _setSectionNotifiers(String section) {
    bool allFilledOut = true;
    for (var inputField in inputFields) {
      if (inputField["section"] == section &&
          (!inputField.containsKey("selectedValue") ||
              inputField["selectedValue"] == null ||
              inputField["selectedValue"] == "")) {
        allFilledOut = false;
      }
    }
    allFilledOut
        ? sectionNotifiers[section]?.value = true
        : sectionNotifiers[section]?.value = false;
  }

  /// action for Clear button
  void _clearInputStorage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Are you sure you want to clear the form data?',
          onConfirm: () {
            for (String section in sectionNotifiers.keys) {
              sectionNotifiers[section]?.value = false;
            }
            Navigator.of(context).pop(true);
          },
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
                  child: const Text('Images',
                      style: TextStyle(color: MyColors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearImages();
                  },
                ),
                OutlinedButton(
                  child:
                      const Text('Form', style: TextStyle(color: MyColors.red)),
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
                dynamicField["values"].indexOf(selectedValue ?? '');
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

    // perform calculations, update _radarChartData
    _radarChartData = calc.performCalculations(_radarChartDataListsReduced);
  }

  Future<String> refreshCurrentLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString("locale");
    localeMap.initialize(inputFields, dynamicFields, sections);
    localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
    originalToLocale = localeMap.getOriginalToLocale(currentLocale);
    return locale ?? "EN";
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
          default:
            currentLocale = snapshot.data.toString();
            localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
            originalToLocale = localeMap.getOriginalToLocale(currentLocale);
            return _buildReducedForm();
        }
      },
    );
  }

  Stack _buildAnimatedSubmitButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.send_and_archive_sharp,
            color: MyColors.green,
          ),
          onPressed: () => _saveFormData(),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isSaving,
          builder: (context, value, child) {
            return value
                ? Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  IconButton _buildRadarChartButton() {
    return IconButton(
      icon: const Icon(
        Icons.analytics_outlined,
        color: Color.fromRGBO(0, 96, 205, 1),
      ),
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
    );
  }

  NavigationRailDestination _buildNavigationRailDestination(String section,
      {Color colorDone = MyColors.green,
      Color colorIncomplete = MyColors.orange}) {
    ValueListenable<bool> listener =
        sectionNotifiers[section] as ValueListenable<bool>;
    int sectionIdx = 0;
    for (int i = 0; i < sections.length; i++) {
      if (sections[i]["label"] == section) {
        sectionIdx = i;
        break;
      }
    }

    return NavigationRailDestination(
      icon: ValueListenableBuilder<bool>(
        valueListenable: listener,
        builder: (context, value, child) {
          return Icon(
            sections[sectionIdx]["icon"],
            color: value ? colorDone : colorIncomplete,
          );
        },
      ),
      selectedIcon: ValueListenableBuilder<bool>(
        valueListenable: listener,
        builder: (context, value, child) {
          return Icon(
            sections[sectionIdx]["iconActive"],
            color: value ? colorDone : colorIncomplete,
          );
        },
      ),
      label: Text(sections[sectionIdx]["label$currentLocale"]),
    );
  }

  Widget _buildSideBar() {
    int imgIndex = 0;
    for (int i = 0; i < sections.length; i++) {
      if (sections[i]["label"] == "images") {
        imgIndex = i;
        break;
      }
    }

    return Row(children: [
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
              labelType: NavigationRailLabelType.none,
              destinations: [
                _buildNavigationRailDestination("general"),
                _buildNavigationRailDestination("physical"),
                _buildNavigationRailDestination("environmental"),
                _buildNavigationRailDestination("biodiversity"),
                NavigationRailDestination(
                    icon: Icon(sections[imgIndex]["icon"],
                        color: _selectedImages.isNotEmpty
                            ? MyColors.green
                            : MyColors.orange),
                    selectedIcon: Icon(sections[imgIndex]["iconActive"],
                        color: _selectedImages.isNotEmpty
                            ? MyColors.green
                            : MyColors.orange),
                    label: Text(sections[imgIndex]["label$currentLocale"])),
              ],
              trailing: Column(children: [
                const SizedBox(height: 50),
                IconButton(
                  icon: Icon(Icons.clear,
                      color: Theme.of(context).colorScheme.error),
                  onPressed: () => _showClearDialog(),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _addImage(ImageSource.gallery),
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () => _addImage(ImageSource.camera),
                ),
                const SizedBox(height: 50),
                _buildRadarChartButton(),
                _buildAnimatedSubmitButton(),
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildReducedForm() {
    // Determine amount of columns based on screen width and orientation
    final mediaQueryData = MediaQuery.of(context);
    final columns = determineRequiredColumns(mediaQueryData);
    final dynamicColumns =
        determineRequiredColumnsDynamicDropdowns(mediaQueryData);

    return Scaffold(
      body: Material(
        child: Form(
          key: widget.formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IndexedStack(
                        index: _selectedIndex,
                        children: [
                          buildMenuPage("general", columns, dynamicColumns),
                          buildMenuPage("physical", columns, dynamicColumns),
                          buildMenuPage(
                              "environmental", columns, dynamicColumns),
                          buildMenuPage(
                              "biodiversity", columns, dynamicColumns),
                          buildImagePage("images"),
                        ],
                      ),
                      // Text("something: $_selectedIndex $currentLocale"),
                    ],
                  ),
                ),
              ),
              // const VerticalDivider(thickness: 1, width: 1),
              ValueListenableBuilder<bool>(
                valueListenable: _isNavigationRailVisible,
                builder: (context, value, child) {
                  return value ? _buildSideBar() : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _isNavigationRailVisible.value = !_isNavigationRailVisible.value;
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: _isNavigationRailVisible,
          builder: (context, value, child) {
            return value
                ? const Icon(Icons.chevron_right)
                : const Icon(Icons.menu_open);
          },
        ),
      ),
    );
  }

  Widget buildMenuPage(String section, var columns, var dynamicColumns) {
    return Column(
      children: [
        createHeader(originalToLocale[section]!),
        const Divider(),
        // buildStaticSteppers(inputFields, section, currentLocale, onWidgetChanged: onStaticWidgetChanged),
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
      ],
    );
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
                      color: MyColors.grey.withOpacity(0.5),
                      spreadRadius: -5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.highlight_remove, color: MyColors.red),
                  onPressed: () => _removeImage(index),
                ),
              ),
            ],
          );
        },
      ),
    ]);
  }
}
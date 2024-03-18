import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedge_profiler_flutter/utils_export_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'colors.dart';
import 'form_data.dart';
import 'form_utils.dart';
import 'form_calc.dart';
import 'form_stepper.dart';
import 'dart:io';
import 'main.dart' show WebViewPageState;
import 'utils_db.dart' as db;
import 'snackbar.dart';
import 'radar_chart.dart';

class NameForm extends StatefulWidget {
  final GlobalKey<NameFormState> formKey;
  final WebViewPageState webViewPageState;
  final bool showForm;
  final bool darkMode;

  const NameForm({
    Key? key,
    required this.formKey,
    required this.webViewPageState,
    required this.showForm,
    required this.darkMode,
  }) : super(key: key);

  @override
  State<NameForm> createState() => NameFormState();
}

/// form page
class NameFormState extends State<NameForm> {
  List<File> _selectedImages = [];

  final ValueNotifier<bool> _isSaving = ValueNotifier<bool>(false);
  List<Map<String, dynamic>> inputFields = [];
  Map<String, int> inputFieldLabelToIndex = {};
  List<Map<String, dynamic>> sections = getSections();

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
      ValueNotifier<bool>(false);
  Map<FormSection, ValueNotifier<bool>> sectionNotifiers = {};

  final Map<String, String> _radarDataToGroup = getRadarDataGroups();
  final Map<String, Color> _radarGroupColors = getRadarGroupColors();

  late String currentLocale = '';
  LocaleMap localeMap = LocaleMap();
  Map<String, String> localeToOriginal = {};
  Map<String, String> originalToLocale = {};

  Map<String, InputType> labelToInputType = {};

  // top menu stuff
  // String selectedMenuItem = "";
  List<String> menuItems = [];

  RadarChartDialog? currentRadarChartDialog;
  Future<void>? _chartDataFuture;
  Future<Uint8List> Function()? capturePngFromRadarChartFunction;

  final ValueNotifier<bool> _showBottomBarNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    populateSectionNotifiers();
    initializeForm();
  }

  void populateSectionNotifiers() {
    for (FormSection section in FormSection.values) {
      sectionNotifiers.putIfAbsent(section, () => ValueNotifier<bool>(false));
    }
  }

  Future<void> initializeForm() async {
    await refreshCurrentLocale();
    inputFields = createFormFields();

    for (var i = 0; i < inputFields.length; i++) {
      inputFieldLabelToIndex[inputFields[i]["label"]] = i;
    }

    localeMap.initialize(inputFields, sections);
    localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
    originalToLocale = localeMap.getOriginalToLocale(currentLocale);

    menuItems =
        sections.map((s) => s["label$currentLocale"].toString()).toList();

    _populateLabelToInputTypeMap();
    _populateInputs();
    _getLostImageData();
    _loadPersistedImages();
  }

  void _populateLabelToInputTypeMap() {
    for (Map field in inputFields) {
      labelToInputType.putIfAbsent(field["label"], () => field["type"]);
    }
  }

  /// wrapper to populate input fields and to refresh section notifiers
  void _populateInputs() async {
    await _populateStaticInputFields();

    // update sectionNotifiers
    for (FormSection section in sectionNotifiers.keys) {
      _setSectionNotifiers(section);
    }
  }

  /// populate input fields on page init;
  Future<void> _populateStaticInputFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale =
        currentLocale == "" ? prefs.getString("locale") : currentLocale;

    for (Map field in inputFields) {
      InputType inputType = field["type"];
      if (inputType == InputType.text ||
          inputType == InputType.number ||
          inputType == InputType.dropdown) {
        String? storedValue = prefs.getString(field["label"]) ?? "";
        if (inputType == InputType.text || inputType == InputType.number) {
          field["controller"].text = storedValue;
          field["selectedValue"] = storedValue;
        } else {
          // dropdowns need the localized string as value
          int valueIndex = field["values"].indexOf(storedValue);
          String localValue = field["values$locale"][valueIndex];
          field["selectedValue"] = localValue;
        }
      } else {
        // lists dont have strings in StoredPreferences, but a list of strings
        List<String>? storedValues = prefs.getStringList(field["label"]) ?? [];
        field["selectedValues"] = storedValues;
      }
    }
  }

  /// action triggered by static widgets onChanged events
  void onWidgetChanged(String widgetLabel, String widgetValue,
      {removeValue = false}) async {
    InputType inputType = labelToInputType[widgetLabel]!;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // refresh inputFields for graph etc.
    int widgetIndex = inputFieldLabelToIndex[widgetLabel]!;
    // String? originalValue = localeToOriginal[widgetValue];

    if (inputType == InputType.dropdown) {
      if (widgetValue.isNotEmpty) {
        widgetValue = localeToOriginal[widgetValue]!;
      }
    }

    if (inputType == InputType.list) {
      if (removeValue) {
        inputFields[widgetIndex]["selectedValues"].remove(widgetValue);
      } else {
        if (!inputFields[widgetIndex].containsKey("selectedValues")) {
          inputFields[widgetIndex]["selectedValues"] = [];
        }
        inputFields[widgetIndex]["selectedValues"].add(widgetValue);
      }
      prefs.setStringList(
          widgetLabel, inputFields[widgetIndex]["selectedValues"]);
    } else {
      inputFields[widgetIndex]["selectedValue"] = widgetValue;
      prefs.setString(widgetLabel, widgetValue);
    }

    // validate all widgets of that section are checked
    FormSection widgetGroup = inputFields[widgetIndex]["section"];
    _setSectionNotifiers(widgetGroup);

    _decideToBuildBottomWidgetBar();
  }

  void _decideToBuildBottomWidgetBar() {
    bool sectionNotifiersExceptImagesAllTrue = sectionNotifiers.entries
        .where((entry) => entry.key != FormSection.images)
        .map((entry) => entry.value)
        .every((ValueNotifier<bool> notifier) => notifier.value == true);
    bool imagesExist = _selectedImages.isNotEmpty ? true : false;
    _showBottomBarNotifier.value =
        sectionNotifiersExceptImagesAllTrue && imagesExist;
  }

  /// validates all widgets of a section are checked
  /// and sets sectionNotifier accordingly
  void _setSectionNotifiers(FormSection section) {
    // TODO: refactor this and _checkIfAllFieldsAreFilled in form_stepper.dart into a single function, reduce complexity
    bool allFilledOut = true;
    for (var inputField in inputFields) {
      if (inputField["section"] == section) {
        if (inputField["type"] == InputType.list) {
          if (!inputField.containsKey("selectedValues") ||
              inputField["selectedValues"].length == 0) {
            allFilledOut = false;
          }
        } else {
          if (!inputField.containsKey("selectedValue") ||
              inputField["selectedValue"] == null ||
              inputField["selectedValue"] == "") {
            allFilledOut = false;
          }
        }
      }
    }

    allFilledOut
        ? sectionNotifiers[section]?.value = true
        : sectionNotifiers[section]?.value = false;
  }

  void _promptToClearImageAndFormData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: currentLocale == "EN"
              ? "Are you sure you want to clear the entire form data and delete the images?"
              : "Sind sie sicher, dass sie die gesamten Eingaben inklusive der aufgenommenen Bilder löschen möchten?",
          onConfirm: () {
            for (FormSection section in sectionNotifiers.keys) {
              sectionNotifiers[section]?.value = false;
            }
            Navigator.of(context).pop(true);
          },
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    );
    if (confirmed == true) {
      _clearFormData();
      _clearImages(goToFirstSectionAfterwards: true);
    }
  }

  /// action for Clear button
  void _promptToClearFormData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Are you sure you want to clear the form data?',
          onConfirm: () {
            for (FormSection section in sectionNotifiers.keys) {
              sectionNotifiers[section]?.value = false;
            }
            Navigator.of(context).pop(true);
          },
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    );
    if (confirmed == true) {
      _clearFormData();
    }
  }

  void _clearFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Object? lat = prefs.get("geo_latitude");
    Object? lon = prefs.get("geo_longitude");
    Object? geoLastChange = prefs.get("geo_last_change");
    prefs.clear();
    prefs.setString("geo_latitude", lat.toString());
    prefs.setString("geo_longitude", lon.toString());
    prefs.setString("geo_last_change", geoLastChange.toString());
    _populateInputs();
  }

  /// get form and image data and persist to database
  void _saveFormData() async {
    // re-map preferences (contains all input fields)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataMap = {};
    for (String key in prefs.getKeys()) {
      dataMap[key] = prefs.get(key);
    }

    bool dataConsentGiven =
        prefs.getString("data_consent") == "true" ? true : false;

    String successText = currentLocale == "EN"
        ? "Document saved successfully"
        : "Dokument erfolgreich gespeichert";

    // write to the database, show snackbar with result, stop loading indicator
    if (dataConsentGiven) {
      _isSaving.value = true;

      db.writeDocument(
          dataMap,
          _radarChartDataFull,
          _radarChartDataListsReduced,
          _selectedImages, (success, message, formDataWithImagesAndTimestamp) {
        if (success) {
          _generatePdfDataAndCreatePdf(formDataWithImagesAndTimestamp);
        } else {
          _generatePdfDataAndCreatePdf(dataMap);
        }

        _isSaving.value = false;

        showSnackbar(context, success ? successText : message,
            success: success);
      });
    } else {
      _generatePdfDataAndCreatePdf(dataMap);
      showSnackbar(context, successText, success: true);
    }
  }

  Future<void> _generatePdfDataAndCreatePdf(
      Map<String, dynamic> formDataWithImagesAndTimestamp) async {
    Map<String, dynamic> simpleFormData = filterAndSimplifySubmittedFormData(
        formDataWithImagesAndTimestamp, localeMap);
    PdfCreator pdf = PdfCreator(originalToLocale, currentLocale);
    pdf.addFormData(simpleFormData);
    Uint8List? graphData = await _openRadarChartCreatePngAndCloseAgain();
    pdf.addRadarChartDataDetailed(_radarChartDataListsReduced);
    pdf.addRadarChartDataOverview(_radarChartData);
    pdf.addRadarChartGraph(graphData);
    pdf.addImages(_selectedImages);
    pdf.saveToFileAndOpenPDF();
  }

  Future<void> _loadPersistedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    // final directory = await getExternalStorageDirectory();
    final imagesDirectory = Directory('${directory.path}/Pictures');
    if (await imagesDirectory.exists()) {
      final files = await imagesDirectory.list().toList();
      _selectedImages = files.map((file) => File(file.path)).toList();
      setState(() {});
    }
  }

  Future<void> _persistImages() async {
    final directory = await getApplicationDocumentsDirectory();
    // final directory = await getExternalStorageDirectory();
    final imagesDirectory = Directory('${directory.path}/Pictures');
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
    // set image quality to 33% to save storage
    final pickedFile = await picker.pickImage(source: source, imageQuality: 33);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
      _persistImages();
    }
    _decideToBuildBottomWidgetBar();
  }

  void _removeImage(int index) async {
    final File image = _selectedImages[index];

    // Show confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to remove this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _selectedImages.removeAt(index);
      });
      await image.delete();
      _persistImages();
      _decideToBuildBottomWidgetBar();
    }
  }

  Future<void> _promptToClearImages() async {
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
      _clearImages();
    }
  }

  void _clearImages({goToFirstSectionAfterwards = false}) async {
    for (final image in _selectedImages) {
      await image.delete();
    }
    _selectedImages.clear();
    // final directory = await getExternalStorageDirectory();
    final directory = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory('${directory.path}/Pictures');
    if (await imagesDirectory.exists()) {
      await imagesDirectory.delete(recursive: true);
    }
    setState(() {});
    _decideToBuildBottomWidgetBar();
    if (goToFirstSectionAfterwards) {
      _selectedIndex = 0;
    }
  }

  void _showClearDialogWithOptionsForFormAndImages() {
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
                    _promptToClearImages();
                  },
                ),
                OutlinedButton(
                  child:
                      const Text('Form', style: TextStyle(color: MyColors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _promptToClearFormData();
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

  Future<void> updateRadarChartData({bool exportReady = false}) async {
    resetRadarChartData();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    updateRadarDataFull(prefs);
    updateRadarDataReduced();

    // perform calculations, update _radarChartData
    _radarChartData = calc.performCalculations(_radarChartDataListsReduced);
    currentRadarChartDialog = await createRadarChartDialog(exportReady);
  }

  void updateRadarDataFull(SharedPreferences prefs) {
    for (var inputField in inputFields) {
      for (String group in _radarChartDataFull.keys) {
        if (isDropdownInputType(inputField) &&
            inputField["valueMap"].containsKey(group)) {
          processDropdownInputType(inputField, group, prefs);
        } else if (isListInputType(inputField) &&
            inputField["valueMap"].containsKey(group)) {
          processListInputType(inputField, group);
        }
      }
    }
  }

  void updateRadarDataReduced() {
    for (var fullData in _radarChartDataFull.entries) {
      String group = fullData.key;
      if (!_radarChartDataListsReduced.containsKey(group)) {
        _radarChartDataListsReduced[group] = {};
      }
      for (var score in fullData.value.entries) {
        processScoreEntry(group, score);
      }
    }
  }

  bool isDropdownInputType(Map inputField) {
    return inputField["type"] == InputType.dropdown &&
        inputField.containsKey("valueMap");
  }

  bool isListInputType(Map inputField) {
    return inputField["type"] == InputType.list &&
        inputField.containsKey("valueMap");
  }

  void processDropdownInputType(
      Map inputField, String group, SharedPreferences prefs) {
    String? selVal = prefs.getString(inputField["label"]);
    if (selVal == "" || selVal == null) {
      _radarChartDataFull[group][inputField["label"]] = 0;
    } else {
      int dropdownValueIndex = inputField["values"].indexOf(selVal);
      var dropdownScore = inputField["valueMap"][group][dropdownValueIndex];
      _radarChartDataFull[group][inputField["label"]] = dropdownScore;
    }
  }

  void processListInputType(Map inputField, String group) {
    List<double> nestedScores = [];
    int valueIdx = 0;
    for (String value in inputField["values"]) {
      if (inputField["selectedValues"].contains(value)) {
        double thisScore =
            inputField["valueMap"][group][valueIdx + 1].toDouble();
        nestedScores.add(thisScore);
      }
      valueIdx++;
    }
    _radarChartDataFull[group][inputField["label"]] = nestedScores;
  }

  void processScoreEntry(String group, MapEntry score) {
    String scoreKey = score.key;
    var scoreValue = score.value;
    if (scoreValue is List) {
      processListScoreEntry(group, scoreKey, scoreValue);
    } else {
      _radarChartDataListsReduced[group][scoreKey] = scoreValue;
    }
  }

  void processListScoreEntry(String group, String scoreKey, List scoreValue) {
    double scoreSum = scoreValue.fold(0, (prev, curr) => prev + curr);

    if (scoreKey == "nachbar_flaechen") {
      scoreSum /= scoreValue.length;
      if (scoreSum.isNaN) {
        scoreSum = 0;
      }
    }

    _radarChartDataListsReduced[group][scoreKey] = scoreSum;
  }

  Future<String> refreshCurrentLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString("locale");
    localeMap.initialize(inputFields, sections);
    localeToOriginal = localeMap.getLocaleToOriginal(currentLocale);
    originalToLocale = localeMap.getOriginalToLocale(currentLocale);
    _decideToBuildBottomWidgetBar();
    return locale ?? "EN";
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showForm) {
      return Container();
    }

    if (_selectedIndex != _selectedIndexCheck || _triggeredByMenu) {
      _selectedIndexCheck = _selectedIndex;
      _triggeredByMenu = false;
      return _buildFormPage();
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
            return _buildFormPage();
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

  void buildAndHandleToolTip(String originalFieldLabel) async {
    Map field = inputFields[inputFieldLabelToIndex[originalFieldLabel]!];
    bool createNavigateToButton = _isValidField(field, "action") ||
        _isValidField(field, "actionEN") ||
        _isValidField(field, "actionDE");
    String navigateToButtonText = createNavigateToButton
        ? _getDescriptiveButtonTextFromFieldAction(field)
        : "";
    VoidCallback navigateFunction =
        createNavigateToButton ? _getFunctionFromFieldAction(field) : () {};

    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ToolTipDialog(
          header: _getLocalizedFieldLabel(field),
          message: _getLocalizedFieldDescription(field),
          navigateToButtonText: navigateToButtonText,
          onNavigateTo: navigateFunction,
          closeButtonText: currentLocale == "EN" ? "Close" : "Schließen",
          onClose: () => Navigator.of(context).pop(false),
          createNavigateToButton: createNavigateToButton,
        );
      },
    );
  }

  VoidCallback _getFunctionFromFieldAction(Map field) {
    var fieldToUse = _getFieldBasedOnLocale(field);

    if (fieldToUse is MapDescriptor) {
      return () {
        widget.webViewPageState.loadMapFromDescriptor(fieldToUse);
        // Navigator.of(context).pop(true);
      };
    } else if (fieldToUse is ImageDescriptor) {
      String imagePath = getImageDescriptorPath(fieldToUse);
      return () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageView(imagePath: imagePath),
          ),
        );
      };
    } else {
      return () {};
    }
  }

  dynamic _getFieldBasedOnLocale(Map field) {
    if (_isValidField(field, "action")) {
      return field["action"];
    }
    if (currentLocale == "EN" && _isValidField(field, "actionEN")) {
      return field["actionEN"];
    }
    if (currentLocale == "DE" && _isValidField(field, "actionDE")) {
      return field["actionDE"];
    }
    return null;
  }

  bool _isValidField(Map field, String key) {
    return field.containsKey(key) && field[key] != null;
  }

  String _getDescriptiveButtonTextFromFieldAction(Map field) {
    dynamic fieldToUse = _getFieldBasedOnLocale(field);
    if (fieldToUse is MapDescriptor) {
      return getMapDescription(fieldToUse, currentLocale);
    } else if (fieldToUse is ImageDescriptor) {
      return getImageDescriptorDescription(fieldToUse, currentLocale);
    } else {
      return "";
    }
  }

  String _getLocalizedFieldLabel(Map field) {
    return currentLocale == "EN" ? field["labelEN"] : field["labelDE"];
  }

  String _getLocalizedFieldDescription(Map field) {
    return currentLocale == "EN"
        ? field["descriptionEN"]
        : field["descriptionDE"];
  }

  IconButton _buildRadarChartButton() {
    return IconButton(
      icon: const Icon(
        Icons.analytics_outlined,
        color: Color.fromRGBO(0, 96, 205, 1),
      ),
      onPressed: _openRadarChart,
    );
  }

  IconButton _buildSaveDebugButton() {
    return IconButton(
      icon: const Icon(
        Icons.analytics_outlined,
        color: MyColors.red,
      ),
      onPressed: () {
        _saveFormData();
      },
    );
  }

  void _openRadarChart() {
    _chartDataFuture = updateRadarChartData();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _chartDataFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return currentRadarChartDialog!;
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Future<Uint8List?> _openRadarChartCreatePngAndCloseAgain() async {
    final imageData = Completer<Uint8List>();
    _chartDataFuture = updateRadarChartData(exportReady: true);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _chartDataFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                imageData.complete(await capturePngFromRadarChartFunction!());
                Navigator.of(context).pop();
              });
              return currentRadarChartDialog!;
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );

    return await imageData.future;
  }

  Future<RadarChartDialog> createRadarChartDialog(bool exportReady) async {
    return RadarChartDialog(
      data: _radarChartData,
      dataToGroup: _radarDataToGroup,
      groupColors: _radarGroupColors,
      currentLocale: currentLocale,
      setCapturePngFromRadarChartCallback: (fn) {
        capturePngFromRadarChartFunction = fn;
      },
      exportReady: exportReady,
      darkMode: widget.darkMode,
    );
  }

  NavigationRailDestination _buildNavigationRailDestination(FormSection section,
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

    String railLabel =
        sections[sectionIdx]["label$currentLocale"].split(" ")[0];
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
      label: Text(railLabel),
    );
  }

  Widget _buildSideBar() {
    return Container(
      color: MyColors.sideBarBackground,
      child: Row(children: [
        const VerticalDivider(
            thickness: 1, width: 1, color: MyColors.dividerColor),
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 120),
            child: IntrinsicHeight(
              child: NavigationRail(
                backgroundColor: Colors.transparent,
                selectedIndex: _selectedIndex,
                groupAlignment: -1.0,
                onDestinationSelected: (int index) {
                  _triggeredByMenu = true;
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.selected,
                destinations: _buildNavigationRailDestinations(),
                // trailing: _buildTrailingNavigationRailDestinations(),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  List<NavigationRailDestination> _buildNavigationRailDestinations() {
    int imgIndex = 0;
    for (int i = 0; i < sections.length; i++) {
      if (sections[i]["label"] == FormSection.images) {
        imgIndex = i;
        break;
      }
    }

    List<NavigationRailDestination> navigationRailDestinations = [];
    for (FormSection section in FormSection.values) {
      if (section == FormSection.images) {
        navigationRailDestinations.add(NavigationRailDestination(
            icon: Icon(sections[imgIndex]["icon"],
                color: _selectedImages.isNotEmpty
                    ? MyColors.green
                    : MyColors.orange),
            selectedIcon: Icon(sections[imgIndex]["iconActive"],
                color: _selectedImages.isNotEmpty
                    ? MyColors.green
                    : MyColors.orange),
            label: Text(sections[imgIndex]["label$currentLocale"])));
      } else {
        navigationRailDestinations
            .add(_buildNavigationRailDestination(section));
      }
    }
    return navigationRailDestinations;
  }

  Widget _buildTrailingNavigationRailDestinations() {
    return Column(children: [
      const SizedBox(height: 50),
      IconButton(
        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
        onPressed: () => _showClearDialogWithOptionsForFormAndImages(),
        // onPressed: () => _clearImages(goToFirstSectionAfterwards: true),
      ),
      // _buildGoToMapDebugButton(),
      _buildRadarChartButton(),
      _buildSaveDebugButton(),
      _buildAnimatedSubmitButton(),
      const SizedBox(height: 50),
    ]);
  }

  Widget _buildFormPage() {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IndexedStack(
                        index: _selectedIndex,
                        children: _createWidgetsForFormSections(),
                      ),
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
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _showBottomBarNotifier,
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            // opacity: value ? 1.0 : 0.0,
            height: value ? 60.0 : 0.0,
            child: value ? _buildBottomNavBar() : const SizedBox.shrink(),
          );
        },
      ),
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
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
    );
  }

  List<SizedBox> _createWidgetsForFormSections() {
    int currentSectionIndex = 0;
    List<SizedBox> formSectionWidgets = [];
    for (FormSection section in FormSection.values) {
      Widget sectionWidget;
      if (section == FormSection.images) {
        sectionWidget = _buildImagePage(section);
      } else {
        sectionWidget = _buildMenuPage(section);
      }
      formSectionWidgets.add(SizedBox(
        // Only show the selected widget. All other widgets are collapsed to a height of 1.
        height: _selectedIndex == currentSectionIndex ? null : 1,
        child: sectionWidget,
      ));
      currentSectionIndex++;
    }
    return formSectionWidgets;
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: MyColors.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined, color: MyColors.green),
            label: currentLocale == "EN" ? "View result" : "Ergebnis ansehen",
          ),
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<bool>(
              valueListenable: _isSaving,
              builder: (context, value, child) {
                return value
                    // Show the progress indicator when saving
                    ? const CircularProgressIndicator()
                    // Show the send and archive icon when not saving
                    : const Icon(Icons.send_and_archive, color: MyColors.green);
              },
            ),
            label: currentLocale == "EN" ? "Save result" : "Ergebnis speichern",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.delete, color: MyColors.red),
            label: currentLocale == "EN" ? "Reset Form" : "Formular löschen",
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              _openRadarChart();
              break;
            case 1:
              _saveFormData();
              break;
            case 2:
              _promptToClearImageAndFormData();
              break;
          }
        },
      ),
    );
  }

  Widget _buildMenuPage(FormSection section) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createHeaderWithSideMenuButton(section),
        const Divider(color: MyColors.dividerColor),
        StepperWidget(
          inputFields: inputFields,
          sectionToBuild: section,
          currentLocale: currentLocale,
          onWidgetChanged: onWidgetChanged,
          buildAndHandleToolTip: buildAndHandleToolTip,
          onSectionChange: () {
            setState(() {
              _selectedIndex += 1;
              // waiting for end of this frame to blur focus
              // FocusScope.of(context).unfocus();
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   FocusScope.of(context).unfocus();
              // });
            });
          },
        ),
      ],
    );
  }

  Widget _buildImagePage(FormSection section) {
    return Column(
      children: [
        _createHeaderWithSideMenuButton(section),
        const Divider(
          color: MyColors.dividerColor,
        ),
        paddedWidget(_buildSingleTextInputForAnmerkungInImageSection()),
        const Divider(
          color: MyColors.dividerColor,
        ),
        paddedWidget(_buildImageGridAndButtonBarForImageSection()),
        _selectedImages.isEmpty
            ? paddedWidget(_createInfoTextForImagePage(),
                horizontalPadding: 40, verticalPadding: 80)
            : Container(),
      ],
    );
  }

  Widget _createHeaderWithSideMenuButton(FormSection section) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: MyColors.dividerColor, // Choose the color of the border
            width: 1, // Choose the width of the border
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Center(
                child: createHeader(originalToLocale[section.toString()]!)),
          ),
          _createSideMenuIconButton()
        ],
      ),
    );
  }

  Widget _createInfoTextForImagePage() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(
        Icons.info,
        color: MyColors.red,
      ),
      Text(
        currentLocale == "EN"
            ? "Please attach at least one image before the results can be retrieved."
            : "Bitte fügen Sie mindestens ein Bild an, bevor die Ergebnisse abgerufen werden können.",
      )
    ]);
  }

  Widget _createSideMenuIconButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isNavigationRailVisible,
      builder: (context, value, child) {
        return IconButton(
          icon: value
              ? const Icon(Icons.chevron_right)
              : const Icon(Icons.menu_open),
          onPressed: () {
            _isNavigationRailVisible.value = !_isNavigationRailVisible.value;
          },
        );
      },
    );
  }

  TextFormField _buildSingleTextInputForAnmerkungInImageSection() {
    String anmerkungenLabel = "anmerkungen_kommentare";
    int anmerkungenIdx = inputFieldLabelToIndex[anmerkungenLabel]!;
    var anmerkungenField = inputFields[anmerkungenIdx];
    return TextFormField(
      controller: anmerkungenField["controller"],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: anmerkungenField["borderColor"],
          ),
        ),
        labelText: anmerkungenField["label$currentLocale"],
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        onWidgetChanged(anmerkungenLabel, value);
      },
    );
  }

  Row _buildImageGridAndButtonBarForImageSection() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImageGrid(),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDecoratedImageIconButton(
                  Icons.photo_library, () => _addImage(ImageSource.gallery)),
              Text(currentLocale == "EN" ? "Gallery" : "Gallerie"),
              const SizedBox(height: 20),
              _buildDecoratedImageIconButton(
                  Icons.add_a_photo, () => _addImage(ImageSource.camera)),
              Text(currentLocale == "EN" ? "Add Foto" : "Neues Foto"),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildDecoratedImageIconButton(
      IconData iconData, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: MyColors.green,
          width: 2.0,
        ),
      ),
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedImages.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Image.file(_selectedImages[index], fit: BoxFit.fitWidth),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.white.withOpacity(0.5),
                      spreadRadius: -5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.highlight_remove,
                      color: MyColors.redDark),
                  onPressed: () => _removeImage(index),
                ),
              ),
            ),
            Positioned(
              top: 48,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.white.withOpacity(0.5),
                      spreadRadius: -5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.zoom_in, color: MyColors.greenDark),
                  onPressed: () => _showFullscreenImage(index),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFullscreenImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.topRight,
            // Position the close button at the top right corner
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.file(
                  _selectedImages[index],
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

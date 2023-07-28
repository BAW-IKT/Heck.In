import 'package:flutter/material.dart';
import 'package:hedge_profiler_flutter/colors.dart';
import 'dynamic_dropdowns.dart';

void doNothing() {}

Column buildDynamicFormFieldGrid({
  required List<Map<String, dynamic>> children,
  required String section,
  required List<GlobalKey<DynamicDropdownsState>> dropdownKeys,
  required void Function(String, String) onDropdownChanged,
  required String currentLocale,
  int columns = 3,
  int minDropdownCount = 0,
  int maxDropdownCount = 6,
}) {
  List<Widget> rows = [];
  List<Widget> rowChildren = [];
  int currentColumnCount = 0;

  for (var child in children) {
    if (child['section'] == section) {
      int index = children.indexOf(child);
      rowChildren.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: DynamicDropdowns(
              key: dropdownKeys[index],
              values: child['values$currentLocale'],
              headerText: child['headerText$currentLocale'],
              originalHeader: child["headerText"],
              borderColor: child['borderColor'],
              onChanged: onDropdownChanged,
              originalValues: child["values"],
              minDropdownCount: child['minDropdownCount'] ?? minDropdownCount,
              maxDropdownCount: child['maxDropdownCount'] ?? maxDropdownCount,
              setStateParent: doNothing,
            ),
          ),
        ),
      );

      currentColumnCount++;
      if (currentColumnCount == columns) {
        rows.add(Row(children: rowChildren));
        rowChildren = [];
        currentColumnCount = 0;
      }
    }
  }

  if (rowChildren.isNotEmpty) {
    rows.add(Row(children: rowChildren));
  }

  return Column(children: rows);
}

Column buildFormFieldGrid(List<Map<String, dynamic>> inputFields,
    String sectionToBuild, String currentLocale,
    {columns = 3, required void Function(String, String) onWidgetChanged}) {
  List<Widget> rows = [];
  List<Widget> rowChildren = [];

  for (var field in inputFields) {
    if (field['section'] != sectionToBuild) {
      continue;
    }
    Color? borderColor = field['borderColor'];
    if (field['type'] == 'text') {
      rowChildren.add(_createTextInput(field, currentLocale, onWidgetChanged,
          borderColor: borderColor));
    } else if (field['type'] == 'dropdown') {
      rowChildren.add(_createDropdownInput(
          field, currentLocale, onWidgetChanged,
          borderColor: borderColor));
    } else if (field['type'] == 'number') {
      rowChildren.add(_createNumberInput(field, currentLocale, onWidgetChanged,
          borderColor: borderColor));
    }

    if (rowChildren.length == columns) {
      rows.add(Row(children: rowChildren));
      rowChildren = [];
    }
  }

  if (rowChildren.isNotEmpty) {
    rows.add(Row(children: rowChildren));
  }

  return Column(children: rows);
}

Widget buildSteppers(
    List<Map<String, dynamic>> inputFields,
    List<Map<String, dynamic>> dynamicFields,
    List<GlobalKey<DynamicDropdownsState>> dropdownKeys,
    GlobalKey<StepperWidgetState> stepperKey,
    String sectionToBuild,
    String currentLocale,
    Function(String, String) onStaticWidgetChanged,
    Function(String, String) onDynamicWidgetChanged) {
  return Center(
    child: StepperWidget(
      inputFields: inputFields,
      dynamicFields: dynamicFields,
      dropdownKeys: dropdownKeys,
      sectionToBuild: sectionToBuild,
      currentLocale: currentLocale,
      onStaticWidgetChanged: onStaticWidgetChanged,
      onDynamicWidgetChanged: onDynamicWidgetChanged,
    ),
  );
}

int determineRequiredColumnsDynamicDropdowns(var mediaQueryData) {
  final screenWidth = mediaQueryData.size.width;
  int columns = 1;
  if (screenWidth > 960) {
    columns = 3;
  } else if (screenWidth > 720) {
    columns = 2;
  }
  return columns;
}

int determineRequiredColumns(var mediaQueryData) {
  final screenWidth = mediaQueryData.size.width;
  int columns = 1;
  if (screenWidth > 960) {
    columns = 5;
  } else if (screenWidth > 840) {
    columns = 4;
  } else if (screenWidth > 720) {
    columns = 3;
  } else if (screenWidth > 600) {
    columns = 2;
  }
  return columns;
}

Widget _createTextInput(
    var field, String currentLocale, Function(String, String) onChanged,
    {Color? borderColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: TextFormField(
      controller: field['controller'],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: borderColor != null
              ? BorderSide(color: borderColor)
              : const BorderSide(),
        ),
        labelText: field['label$currentLocale'],
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        onChanged(field["label"], value);
      },
    ),
  );
}

Padding _paddedWidget(Widget widget) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: widget);
}

Widget _createNumberInput(
    var field, String currentLocale, Function(String, String) onChanged,
    {Color? borderColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: TextFormField(
      controller: field['controller'],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: borderColor != null
              ? BorderSide(color: borderColor)
              : const BorderSide(),
        ),
        labelText: field['label$currentLocale'],
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        onChanged(field["label"], value);
      },
    ),
  );
}

Widget _createDropdownInput(
    var field, String currentLocale, Function(String, String) onChanged,
    {Color? borderColor}) {
  var dropdownItems =
      field['values$currentLocale'].map<DropdownMenuItem<String>>((value) {
    double dynamicTextSize = 12;
    if (value.toString().length > 16) {
      dynamicTextSize = 10;
    }
    if (value.toString().length > 24) {
      dynamicTextSize = 7;
    }
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(
          fontSize: dynamicTextSize,
        ),
      ),
    );
  }).toList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: DropdownButtonFormField(
      value: field['selectedValue'],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: borderColor != null
              ? BorderSide(color: borderColor)
              : const BorderSide(),
        ),
        labelText: field['label$currentLocale'],
        labelStyle: TextStyle(
          fontSize: field['label$currentLocale'].length > 24 ? 14 : 16,
        ),
      ),
      items: dropdownItems,
      onChanged: (value) {
        onChanged(field["label"], value.toString());
      },
    ),
  );
}

Center createHeader(String headerText, {double fontSize = 24}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        headerText,
        style: TextStyle(fontSize: fontSize),
      ),
    ),
  );
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

class ToolTipDialog extends StatelessWidget {
  final String header;
  final String message;
  final String navigateToMapButtonText;
  final VoidCallback onNavigateToMap;
  final String closeButtonText;
  final VoidCallback onClose;
  final bool createGoToMapButton;

  const ToolTipDialog(
      {Key? key,
      required this.header,
      required this.message,
      required this.navigateToMapButtonText,
      required this.onNavigateToMap,
      required this.closeButtonText,
      required this.onClose,
      required this.createGoToMapButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actionsList = [];

    if (createGoToMapButton) {
      actionsList.add(
        TextButton(
            onPressed: onNavigateToMap, child: Text(navigateToMapButtonText)),
      );
    }

    actionsList.add(TextButton(
      onPressed: onClose,
      child: Text(closeButtonText),
    ));

    return AlertDialog(
      title: Text(header),
      content: Text(message),
      actions: actionsList,
    );
  }
}

class LocaleMap {
  List<Map<String, dynamic>> formFields = [];
  List<Map<String, dynamic>> dynamicFormFields = [];
  List<Map<String, dynamic>> sections = [];

  void initialize(
      List<Map<String, dynamic>> formFields,
      List<Map<String, dynamic>> dynamicFormFields,
      List<Map<String, dynamic>> sections) {
    this.formFields = formFields;
    this.dynamicFormFields = dynamicFormFields;
    this.sections = sections;
  }

  Map<String, String> getLocaleToOriginal(String locale) {
    Map<String, String> map = {};

    if (locale.isEmpty) {
      return map;
    }

    for (Map<String, dynamic> field in formFields) {
      map[field["label$locale"]] = field["label"];
      if (field.containsKey("values")) {
        for (int i = 0; i < field["values"].length; i++) {
          if (field["values"][i] == "") {
            continue;
          }
          map[field["values$locale"][i]] = field["values"][i];
        }
      }
    }
    for (Map<String, dynamic> dynField in dynamicFormFields) {
      map[dynField["headerText$locale"]] = dynField["headerText"];
      for (int i = 0; i < dynField["values"].length; i++) {
        if (dynField["values"][i] == "") {
          continue;
        }
        map[dynField["values$locale"][i]] = dynField["values"][i];
      }
    }

    for (Map<String, dynamic> sec in sections) {
      map[sec["label$locale"]] = sec["label"];
    }

    return map;
  }

  Map<String, String> getOriginalToLocale(String locale) {
    Map<String, String> map = {};

    if (locale.isEmpty) {
      return map;
    }

    for (Map<String, dynamic> field in formFields) {
      map[field["label"]] = field["label$locale"];
      if (field.containsKey("values")) {
        for (int i = 0; i < field["values"].length; i++) {
          if (field["values"][i] == "") {
            continue;
          }
          map[field["values"][i]] = field["values$locale"][i];
        }
      }
    }
    for (Map<String, dynamic> dynField in dynamicFormFields) {
      map[dynField["headerText"]] = dynField["headerText$locale"];
      for (int i = 0; i < dynField["values"].length; i++) {
        if (dynField["values"][i] == "") {
          continue;
        }
        map[dynField["values"][i]] = dynField["values$locale"][i];
      }
    }
    for (Map<String, dynamic> sec in sections) {
      map[sec["label"]] = sec["label$locale"];
    }

    return map;
  }
}

class StepperWidget extends StatefulWidget {
  final List<Map<String, dynamic>> inputFields;
  final List<Map<String, dynamic>> dynamicFields;
  final List<GlobalKey<DynamicDropdownsState>> dropdownKeys;
  final String sectionToBuild;
  final String currentLocale;
  final Function(String, String) onStaticWidgetChanged;
  final Function(String, String) onDynamicWidgetChanged;

  const StepperWidget({
    Key? key,
    required this.inputFields,
    required this.dynamicFields,
    required this.dropdownKeys,
    required this.sectionToBuild,
    required this.currentLocale,
    required this.onStaticWidgetChanged,
    required this.onDynamicWidgetChanged,
  }) : super(key: key);

  @override
  State<StepperWidget> createState() => StepperWidgetState();
}

class StepperWidgetState extends State<StepperWidget> {
  int _index = 0;
  Map<String, dynamic> dropdownSelectedIndex = {};
  List<GlobalKey> _scrollKeys = []; // Add this line
  final ScrollController _scrollController = ScrollController();

  void setStepperWidgetState() {
    setState(() {});
    print("done setting parents state");
  }

  @override
  void initState() {
    super.initState();
    // Initialize _scrollKeys with a GlobalKey for each step
    _scrollKeys = List.generate(
        widget.inputFields.length + widget.dynamicFields.length,
        (_) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [];
    Map<String, dynamic> subSections = {};
    Map<String, List<String>> subSectionToOriginales = {};

    // Build steps from inputFields
    for (var field in widget.inputFields) {
      if (field["section"] != widget.sectionToBuild) {
        continue;
      }

      // generate input widget
      Widget? inputWidget;
      Color? borderColor = field['borderColor'];
      if (field["type"] == "text") {
        inputWidget =
            _createTextInputForStepper(field, borderColor: borderColor);
      } else if (field["type"] == "dropdown") {
        // dropdownSelectedIndex[field["label"]] = field["selectedValue"];
        inputWidget =
            _createDropdownInputForStepper(field, borderColor: borderColor);
      } else if (field["type"] == "number") {
        inputWidget =
            _createNumberInputForStepper(field, borderColor: borderColor);
      }

      // add to column with descriptive text
      Column column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _paddedWidget(Text(field["description${widget.currentLocale}"])),
          const SizedBox(height: 10),
          inputWidget!,
          const SizedBox(height: 16),
        ],
      );

      // add widget to defined subSection map if defined (if not, create own group based on label)
      if (!field.containsKey("subSection${widget.currentLocale}")) {
        String fieldLabel = field["label${widget.currentLocale}"];
        subSections[fieldLabel] = [column];
        subSectionToOriginales[fieldLabel] = [field["label"]];
      } else {
        String subSection = field["subSection${widget.currentLocale}"];
        if (!subSections.containsKey(subSection)) {
          subSections[subSection] = [column];
        } else {
          subSections[subSection].add(column);
        }
        if (!subSectionToOriginales.containsKey(subSection)) {
          subSectionToOriginales[subSection] = [field["label"]];
        } else {
          subSectionToOriginales[subSection]?.add(field["label"]);
        }
      }
    }

    // Build steps from dynamicFields
    for (var field in widget.dynamicFields) {
      if (field["section"] != widget.sectionToBuild) {
        continue;
      }
      int index = widget.dynamicFields.indexOf(field);

      // build column with descriptive text
      Column column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _paddedWidget(Text(field["description${widget.currentLocale}"])),
          const SizedBox(height: 10),
          DynamicDropdowns(
            key: widget.dropdownKeys[index],
            values: field["values${widget.currentLocale}"],
            headerText: field["headerText${widget.currentLocale}"],
            originalHeader: field["headerText"],
            borderColor: field["borderColor"],
            onChanged: widget.onDynamicWidgetChanged,
            originalValues: field["values"],
            minDropdownCount: field["minDropdownCount"] ?? 0,
            maxDropdownCount: field["maxDropdownCount"] ?? 6,
            setStateParent: setStepperWidgetState,
          ),
          const SizedBox(height: 16),
        ],
      );

      // add widget to defined subSection map if defined (if not, create own group based on label)
      if (!field.containsKey("subSection${widget.currentLocale}")) {
        String fieldLabel = field["headerText${widget.currentLocale}"];
        subSections[fieldLabel] = [column];
        subSectionToOriginales[fieldLabel] = [field["headerText"]];
      } else {
        String subSection = field["subSection${widget.currentLocale}"];
        if (!subSections.containsKey(subSection)) {
          subSections[subSection] = [column];
        } else {
          subSections[subSection].add(column);
        }
        if (!subSectionToOriginales.containsKey(subSection)) {
          subSectionToOriginales[subSection] = [field["headerText"]];
        } else {
          subSectionToOriginales[subSection]?.add(field["headerText"]);
        }
      }
    }

    // build steps
    List<bool> stepCompletionStatus = List.filled(subSections.length, false);
    int index = 0;
    for (String subSection in subSections.keys) {
      // List<String> originalWidgetNames = subSections[subSection];
      bool isStepComplete =
          checkAllFieldsFilled(subSectionToOriginales[subSection]);
      stepCompletionStatus[index] = isStepComplete;
      Step step = Step(
        title: Text(subSection),
        // state: _index > steps.length ? StepState.complete : StepState.indexed,
        state: isStepComplete ? StepState.complete : StepState.indexed,
        isActive: _index == index,
        content: SingleChildScrollView(
          key: _scrollKeys[index],
          controller: _scrollController,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...subSections[subSection]],
            ),
          ),
        ),
      );
      steps.add(step);
      index++;
    }

    return Stepper(
      currentStep: _index,
      physics: const ClampingScrollPhysics(),
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < steps.length - 1) {
          setState(() {
            _index += 1;
          });

          // Scroll to the top of the content of the current step
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final RenderBox? renderBox = _scrollKeys[_index]
                .currentContext
                ?.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final offset = renderBox.localToGlobal(Offset.zero);
              _scrollController.animateTo(offset.dy,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });

        // Scroll to the top of the content of the current step
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? renderBox = _scrollKeys[index]
              .currentContext
              ?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final offset = renderBox.localToGlobal(Offset.zero);
            _scrollController.animateTo(offset.dy,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          }
        });
      },
      steps: steps,
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        // bool isLastStep = _index == steps.length - 1;
        bool isStepComplete = stepCompletionStatus[_index];

        return Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_index > 0)
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    child:
                        Text(widget.currentLocale == "EN" ? "Back" : "Zurück"),
                  ),
                const SizedBox(width: 4),
                if (_index < steps.length - 1)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(
                      widget.currentLocale == "EN" ? "Next" : "Weiter",
                      style: TextStyle(
                          color: isStepComplete
                              ? MyColors.green
                              : MyColors.orange),
                    ),
                  ),
              ],
            ),
            Positioned(
              left: 5,
              top: 0,
              bottom: 0,
              child: Icon(
                isStepComplete ? Icons.check_circle : Icons.pending,
                color: isStepComplete ? MyColors.green : MyColors.orange,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }

  bool checkAllFieldsFilled(List<String>? originalLabels) {
    for (String originalLabel in originalLabels!) {
      for (var staticField in widget.inputFields) {
        if (staticField["label"] == originalLabel &&
            (!staticField.containsKey("selectedValue") ||
                staticField["selectedValue"] == null ||
                staticField["selectedValue"] == "")) {
          return false;
        }
      }

      for (var dynamicField in widget.dynamicFields) {
        if (dynamicField["headerText"] == originalLabel &&
            (!dynamicField.containsKey("selectedValues") ||
                dynamicField["selectedValues"].length == 0 ||
                dynamicField["selectedValues"]
                    .values
                    .any((value) => value == ""))) {
          return false;
        }
      }
    }
    // print("all done!");
    return true;
  }

  Widget _createDropdownInputForStepper(var field, {Color? borderColor}) {
    String locale = widget.currentLocale;
    var dropdownItems =
        field['values$locale'].map<DropdownMenuItem<String>>((value) {
      double dynamicTextSize = 12;
      if (value.toString().length > 16) {
        dynamicTextSize = 10;
      }
      if (value.toString().length > 24) {
        dynamicTextSize = 7;
      }
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(
            fontSize: dynamicTextSize,
          ),
        ),
      );
    }).toList();

    String dropdownValue;
    if (!field["values${widget.currentLocale}"]
        .contains(field["selectedValue"])) {
      String otherLanguage = locale == "EN" ? "DE" : "EN";
      int dropdownValueIndex =
          field["values$otherLanguage"].indexOf(field["selectedValue"]);
      dropdownValue =
          field["values${widget.currentLocale}"][dropdownValueIndex];
    } else {
      dropdownValue = field["selectedValue"];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: DropdownButtonFormField(
        value: dropdownValue,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor)
                : const BorderSide(),
          ),
          labelText: field['label$locale'],
          labelStyle: TextStyle(
            fontSize: field['label$locale'].length > 24 ? 14 : 16,
          ),
        ),
        items: dropdownItems,
        onChanged: (value) {
          widget.onStaticWidgetChanged(field["label"], value.toString());
          setState(() {
            dropdownSelectedIndex[field["label"]] = value;
          });
        },
      ),
    );
  }

  Widget _createNumberInputForStepper(var field, {Color? borderColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: TextFormField(
        controller: field['controller'],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor)
                : const BorderSide(),
          ),
          labelText: field['label${widget.currentLocale}'],
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          widget.onStaticWidgetChanged(field["label"], value);
          setState(() {});
        },
      ),
    );
  }

  Widget _createTextInputForStepper(var field, {Color? borderColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: TextFormField(
        controller: field['controller'],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor)
                : const BorderSide(),
          ),
          labelText: field['label${widget.currentLocale}'],
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          widget.onStaticWidgetChanged(field["label"], value);
          setState(() {});
        },
      ),
    );
  }
}

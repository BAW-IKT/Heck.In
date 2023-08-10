import 'package:flutter/material.dart';
import 'package:hedge_profiler_flutter/colors.dart';
import 'package:hedge_profiler_flutter/input_dropdown.dart';
import 'form_data.dart';
import 'form_utils.dart';

Widget buildSteppers(
    List<Map<String, dynamic>> inputFields,
    GlobalKey<StepperWidgetState> stepperKey,
    FormSection sectionToBuild,
    String currentLocale,
    Function(String, String, {bool removeValue}) onWidgetChanged,
    Function(String) buildAndHandleToolTip) {
  return StepperWidget(
    inputFields: inputFields,
    sectionToBuild: sectionToBuild,
    currentLocale: currentLocale,
    onWidgetChanged: onWidgetChanged,
    buildAndHandleToolTip: buildAndHandleToolTip,
  );
}

class StepperWidget extends StatefulWidget {
  final List<Map<String, dynamic>> inputFields;
  final FormSection sectionToBuild;
  final String currentLocale;
  final Function(String, String, {bool removeValue}) onWidgetChanged;
  final Function(String) buildAndHandleToolTip;

  const StepperWidget({
    Key? key,
    required this.inputFields,
    required this.sectionToBuild,
    required this.currentLocale,
    required this.onWidgetChanged,
    required this.buildAndHandleToolTip,
  }) : super(key: key);

  @override
  State<StepperWidget> createState() => StepperWidgetState();
}

class StepperWidgetState extends State<StepperWidget> {
  int _index = 0;
  List<GlobalKey> _scrollKeys = [];
  final ScrollController _scrollController = ScrollController();

  List<Step> steps = [];
  Map<String, dynamic> subSections = {};
  Map<String, List<String>> subSectionToOriginales = {};

  void setStepperWidgetState() {
    setState(() {});
    print("done setting parents state");
  }

  @override
  void initState() {
    super.initState();
    // Initialize _scrollKeys with a GlobalKey for each step
    _scrollKeys = List.generate(widget.inputFields.length, (_) => GlobalKey());
  }

  void resetStepsAndSections() {
    steps = [];
    subSections = {};
    subSectionToOriginales = {};
  }

  @override
  Widget build(BuildContext context) {
    resetStepsAndSections();

    // Build steps from inputFields
    for (Map<String, dynamic> field in widget.inputFields) {
      if (field["section"] != widget.sectionToBuild) {
        continue;
      }

      // create widget
      Column thisInput = widgetWithBottomPadding(_createInput(field));

      // add widget to defined subSection map if defined (if not, create own group based on label)
      _mapWidgetToSubSections(field, thisInput);
    }

    // build steps
    List<bool> stepCompletionStatus = _buildStepsAndGetCompletionStatusList();

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

  Widget _createInput(Map<String, dynamic> field) {
    Color? borderColor = field["borderColor"];
    InputType inputType = field["type"];
    Widget widget;
    switch (inputType) {
      case InputType.text:
        widget = _createTextInput(field, borderColor: borderColor);
        break;
      case InputType.number:
        widget = _createNumberInput(field, borderColor: borderColor);
        break;
      case InputType.dropdown:
        widget = _createDropdownInput(field, borderColor: borderColor);
        break;
      case InputType.list:
        widget = _createListInput(field, borderColor: borderColor);
        break;
    }
    return widgetWithBottomPadding(widget);
  }

  void _mapWidgetToSubSections(Map field, Widget thisInput) {
    if (!field.containsKey("subSection${widget.currentLocale}")) {
      String fieldLabel = field["label${widget.currentLocale}"];
      subSections[fieldLabel] = [thisInput];
      subSectionToOriginales[fieldLabel] = [field["label"]];
    } else {
      String subSection = field["subSection${widget.currentLocale}"];
      if (!subSections.containsKey(subSection)) {
        subSections[subSection] = [thisInput];
      } else {
        subSections[subSection].add(thisInput);
      }
      if (!subSectionToOriginales.containsKey(subSection)) {
        subSectionToOriginales[subSection] = [field["label"]];
      } else {
        subSectionToOriginales[subSection]?.add(field["label"]);
      }
    }
  }

  List<bool> _buildStepsAndGetCompletionStatusList() {
    List<bool> stepCompletionStatus = List.filled(subSections.length, false);
    int index = 0;
    for (String subSection in subSections.keys) {
      bool stepComplete = _checkIfAllFieldsAreFilled(
          subSectionToOriginales[subSection]);
      stepCompletionStatus[index] = stepComplete;
      Step step = Step(
        title: Text(subSection),
        state: stepComplete ? StepState.complete : StepState.indexed,
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
    return stepCompletionStatus;
  }

  bool _checkIfAllFieldsAreFilled(List<String>? originalLabels) {
    for (String originalLabel in originalLabels!) {
      for (var inputField in widget.inputFields) {
        if (inputField["label"] == originalLabel) {
          if (inputField["type"] == InputType.list) {
            if (!inputField.containsKey("selectedValues") ||
                inputField["selectedValues"].length == 0) {
              return false;
            }
          } else {
            if (!inputField.containsKey("selectedValue") ||
                inputField["selectedValue"] == null ||
                inputField["selectedValue"] == "") {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  Widget _createDropdownInput(Map<String, dynamic> field, {Color? borderColor}) {
    DropdownInput dropdownInput = DropdownInput(
        key: UniqueKey(),
        field: field,
        onValueChange: (label, value) {
          widget.onWidgetChanged(label, value);
          setState(() {

          });
        },
        currentLocale: widget.currentLocale,
        borderColor: borderColor);

    validateSelectedValueOfDropdownFieldMatchesCurrentLocale(widget.currentLocale, field);
    return _addPaddingAndToolTipToInputField(dropdownInput, field);
  }

  Widget _createNumberInput(Map field, {Color? borderColor}) {
    TextFormField numberFormField = TextFormField(
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
        widget.onWidgetChanged(field["label"], value);
        setState(() {});
      },
    );
    return _addPaddingAndToolTipToInputField(numberFormField, field);
  }

  Widget _createTextInput(Map field, {Color? borderColor}) {
    TextFormField textFormField = TextFormField(
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
        widget.onWidgetChanged(field["label"], value);
        setState(() {});
      },
    );
    return _addPaddingAndToolTipToInputField(textFormField, field);
  }

  Widget _createListInput(Map field, {Color? borderColor}) {
    int listTileCount = field['values'].length;

    bool fieldHasUniqueHeader = field['label${widget.currentLocale}'] !=
        field["subSection${widget.currentLocale}"];
    bool fieldHasToolTip = _fieldHasToolTip(field);
    bool appendHeaderRow = fieldHasToolTip || fieldHasUniqueHeader;

    if (appendHeaderRow) {
      listTileCount++;
    }

    Widget headerRow = _getHeaderRow(
        field, fieldHasUniqueHeader, fieldHasToolTip, borderColor);

    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listTileCount,
      itemBuilder: (context, builderIndex) {
        if (builderIndex == 0 && appendHeaderRow) {
          return headerRow;
        } else {
          int valueIndex = appendHeaderRow ? builderIndex - 1 : builderIndex;
          String checkboxLabel = field['values${widget.currentLocale}'][valueIndex];
          String machineReadableValue = field["values"][valueIndex];
          return CheckboxListTile(
            title: Text(checkboxLabel),
            contentPadding: EdgeInsets.zero,
            value: field["selectedValues"].contains(machineReadableValue),
            onChanged: (bool? value) {
              widget.onWidgetChanged(field['label'], machineReadableValue, removeValue: value != true);
              setState(() {});
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: borderColor,
          );
        }
      },
    );
  }

  Widget _getHeaderRow(Map field, bool fieldHasUniqueHeader,
      bool fieldHasToolTip, Color? borderColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (fieldHasUniqueHeader)
          Text(
            field['label${widget.currentLocale}'],
            style: TextStyle(color: borderColor),
          ),
        if (fieldHasToolTip)
          _getToolTipIconButton(field),
      ],
    );
  }

  Padding _addPaddingAndToolTipToInputField(Widget inputField, Map field) {
    Widget inputFieldWithToolTip = Row(children: [
      Expanded(child: inputField),
      if (_fieldHasToolTip(field)) _getToolTipIconButton(field)
    ]);
    return paddedWidget(inputFieldWithToolTip,
        horizontalPadding: 0.0, verticalPadding: 4.0);
  }

  Widget _getToolTipIconButton(Map field) {
    return IconButton(
      icon: const Icon(Icons.info),
      onPressed: () {
        widget.buildAndHandleToolTip(field["label"]);
      },
    );
  }

  bool _fieldHasToolTip(Map field) {
    return field["descriptionEN"] != null && field["descriptionDE"] != null;
  }
}
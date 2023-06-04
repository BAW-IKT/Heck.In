import 'package:flutter/material.dart';
import 'dynamic_dropdowns.dart';

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
              values: child['values'],
              headerText: child['headerText$currentLocale'],
              borderColor: child['borderColor'],
              onChanged: onDropdownChanged,
              minDropdownCount: child['minDropdownCount'] ?? minDropdownCount,
              maxDropdownCount: child['maxDropdownCount'] ?? maxDropdownCount,
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
  int columns = 2;
  if (screenWidth > 960) {
    columns = 6;
  } else if (screenWidth > 840) {
    columns = 5;
  } else if (screenWidth > 720) {
    columns = 4;
  } else if (screenWidth > 600) {
    columns = 3;
  }
  return columns;
}

Expanded _createTextInput(
    var field, String currentLocale, Function(String, String) onChanged,
    {Color? borderColor}) {
  return Expanded(
    child: Padding(
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
    ),
  );
}

Expanded _createNumberInput(
    var field, String currentLocale, Function(String, String) onChanged,
    {Color? borderColor}) {
  return Expanded(
    child: Padding(
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
    ),
  );
}

Expanded _createDropdownInput(
    var field, String currentLocale, Function(String, String) onChanged,
    {Color? borderColor}) {
  var dropdownItems = field['values'].map<DropdownMenuItem<String>>((value) {
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
  return Expanded(
    child: Padding(
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
    ),
  );
}

Center createHeader(String headerText, {double fontSize = 24}) {
  return Center(
      child: Text(
    headerText,
    style: TextStyle(fontSize: fontSize),
  ));
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

    for (Map<String, dynamic> field in formFields) {
      map[field["label$locale"]] = field["label"];
    }
    for (Map<String, dynamic> dynField in dynamicFormFields) {
      map[dynField["headerText$locale"]] = dynField["headerText"];
    }

    for (Map<String, dynamic> sec in sections) {
      map[sec["label$locale"]] = sec["label"];
    }

    return map;
  }

  Map<String, String> getOriginalToLocale(String locale) {
    Map<String, String> map = {};

    for (Map<String, dynamic> field in formFields) {
      map[field["label"]] = field["label$locale"];
    }
    for (Map<String, dynamic> dynField in dynamicFormFields) {
      map[dynField["headerText"]] = dynField["headerText$locale"];
    }
    for (Map<String, dynamic> sec in sections) {
      map[sec["label"]] = sec["label$locale"];
    }

    return map;
  }
}


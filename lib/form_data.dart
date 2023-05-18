import 'package:flutter/material.dart';

String? generateValidator(String? value, String label, bool required) {
  if (required && (value == null || value.isEmpty)) {
    return '$label eingeben!';
  }
  return null;
}

/// This function defines the data for static inputs (text, number or dropdown)
/// labels must be unique across all static & dynamic widgets!
/// example usage to create widgets:
///    buildFormFieldGrid(inputFields, 'General', setState, columns: columns)
List<Map<String, dynamic>> createFormFields() {
  return [
    {
      'type': 'text',
      'label': 'Heckenname',
      'section': 'General',
      'borderColor': Colors.deepOrange,
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, 'Namen der Hecke', true),
    },
    {
      'type': 'text',
      'label': 'Ort',
      'section': 'General',
      'borderColor': Colors.deepOrange,
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, "Ort", true),
    },
    {
      'type': 'text',
      'label': 'Gutachter',
      'section': 'General',
      'borderColor': Colors.deepOrange,
      'controller': TextEditingController(),
      'validator': (value) =>
          generateValidator(value, "Namen des Gutachters", true),
    },
    {
      'type': 'number',
      'label': 'Länge [m]',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'controller': TextEditingController(),
      'validator': (value) =>
          generateValidator(value, "Länge der Hecke", false),
    },
    {
      'type': 'dropdown',
      'label': 'Ausrichtung Himmelsrichtung',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'a: S-N', 'b: SO-NW', 'c: W-O', 'd: SW-NO'],
      'validator': (value) =>
          generateValidator(value, "Ausrichtung Himmelsrichtung", false),
    },
    {
      'type': 'dropdown',
      'label': 'Schutzgebiet',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'a: Schutzgebiet', 'b: Kein Schutzgebiet'],
      'validator': (value) => generateValidator(value, "Schutzgebiet", false),
    },
    {
      'type': 'dropdown',
      'label': 'Naturdenkmal',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Naturdenkmal", false),
    },
    {
      'type': 'dropdown',
      'label': 'Heckendichte',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Heckendichte", false),
    },
    {
      'type': 'dropdown',
      'label': 'klimatische Wasserbilanz',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) =>
          generateValidator(value, "klimatische Wasserbilanz", false),
    },
    {
      'type': 'dropdown',
      'label': 'Bevölkerungsdichte',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) =>
          generateValidator(value, "Bevölkerungsdichte", false),
    },
    {
      'type': 'dropdown',
      'label': 'in Wildtierkorridor',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) =>
          generateValidator(value, "in Wildtierkorridor", false),
    },
    {
      'type': 'dropdown',
      'label': 'traditionelle Heckenregion',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) =>
          generateValidator(value, "traditionelle Heckenregion", false),
    },
    {
      'type': 'dropdown',
      'label': 'Franziszeischer Kataster',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) =>
          generateValidator(value, "Franziszeischer Kataster", false),
    },
    {
      'type': 'dropdown',
      'label': 'nutzbare Feldkapazität',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) =>
          generateValidator(value, "nutzbare Feldkapazität", false),
    },
    {
      'type': 'dropdown',
      'label': 'Humusbilanz',
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Humusbilanz", false),
    },
  ];
}

/// this section defines the data for dynamic dropdown fields
/// labels must be unique across all static & dynamic widgets!
/// example usage to create widgets:
///    buildDynamicFormFieldGrid(
///      children: dynamicFields,
///      section: 'General',
///      dropdownKeys: _dropdownsKeys,
///      onDropdownChanged: onDynamicDropdownsChanged,
///      columns: dynamicColumns,
///    ),
List<Map<String, dynamic>> createDynamicFormFields() {
  return [
    {
      'headerText': 'Fredl',
      'borderColor': Colors.deepOrangeAccent,
      'defValues': const ['', 'franz', 'value', 'value2'],
      'section': 'General',
    },
    {
      'headerText': 'Frudl',
      'borderColor': Colors.deepOrangeAccent,
      'defValues': const ['', 'first', 'second', 'third'],
      'section': 'General'
    },
    {
      'headerText': 'Forkl',
      'borderColor': Colors.indigoAccent,
      'defValues': const ['', 'first', 'second', 'third'],
      'section': 'GIS',
      'minDropdownCount': 1,
      'maxDropdownCount': 3,
    },
    {
      'headerText': 'Pforkl',
      'borderColor': Colors.indigoAccent,
      'defValues': const ['', 'first', 'second', 'third'],
      'section': 'GIS'
    },
  ];
}
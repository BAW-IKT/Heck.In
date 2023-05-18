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
    // general fields
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
    // GIS fields
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
    // gelände fields
    {'type': 'text', 'label': 'Position zum Hang', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Position zum Hang', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Hangneigung', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Hangneigung', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Netzwerk', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Netzwerk', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Erschließung', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Erschließung', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'horizontale Schichtung', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'horizontale Schichtung', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'vertikale Schichtung', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'vertikale Schichtung', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Strukturvielfalt', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Strukturvielfalt', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Lücken', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Lücken', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Totholz', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Totholz', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Alterszusammensetzung', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Alterszusammensetzung', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Saumart', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Saumart', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Saumbreite', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Saumbreite', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Höhe', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Höhe', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Breite', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Breite', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Baumanteil', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Baumanteil', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Anzahl Gehölzarten', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Anzahl Gehölzarten', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Dominanzen', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Dominanzen', false), 'controller': TextEditingController(), },
    {'type': 'text', 'label': 'Neophyten', 'section': 'Gelände', 'borderColor': Colors.green, 'values': ['', 'value1', 'value2'], 'validator': (value) => generateValidator(value, 'Neophyten', false), 'controller': TextEditingController(), },
    // anmerkungen
    {
      'type': 'text',
      'label': 'Anmerkungen',
      'section': 'Anmerkungen',
      'borderColor': Colors.amber,
      'controller' :TextEditingController(),
      'validator': (value) => generateValidator(value, 'Anmerkungen', false),
    },
  ];
}

/// this section defines the data for dynamic dropdown fields
/// labels must be unique across all static & dynamic widgets!
/// optional fields for definition of widgets:
///    - minDropdownCount [int]: lower threshold of dropdowns created with -
///    - maxDropdownCount [int]: upper threshold of dropdowns created with +
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
    // Gelände fields
    {'headerText': 'Nachbarflächen', 'borderColor': Colors.greenAccent, 'defValues': const['', 'first', 'second'], 'section': 'Gelände',},
    {'headerText': 'Nutzungsspuren', 'borderColor': Colors.greenAccent, 'defValues': const['', 'first', 'second'], 'section': 'Gelände', 'maxDropdownCount': 4,},
    {'headerText': 'Zusatzstrukturen', 'borderColor': Colors.greenAccent, 'defValues': const['', 'first', 'second'], 'section': 'Gelände', 'maxDropdownCount': 4,},
    {'headerText': 'Management', 'borderColor': Colors.greenAccent, 'defValues': const['', 'first', 'second'], 'section': 'Gelände', 'maxDropdownCount': 5,},
    {'headerText': 'Sonderform', 'borderColor': Colors.greenAccent, 'defValues': const['', 'first', 'second'], 'section': 'Gelände', 'maxDropdownCount': 4,},
  ];
}
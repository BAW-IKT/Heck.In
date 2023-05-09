import 'package:flutter/material.dart';

String? generateValidator(String? value, String label) {
  if (value == null || value.isEmpty) {
    return '$label eingeben!';
  }
  return null;
}

List<Map<String, dynamic>> createFormFields() {
  return [
    {
      'type': 'text',
      'label': 'Heckenname',
      'section': 'General',
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, 'Namen der Hecke'),
    },
    {
      'type': 'text',
      'label': 'Ort',
      'section': 'General',
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, "Ort"),
    },
    {
      'type': 'text',
      'label': 'Gutachter',
      'section': 'General',
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, "Namen des Gutachters"),
    },
    {
      'type': 'number',
      'label': 'Länge [m]',
      'section': 'GIS',
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, "Länge der Hecke"),
    },
    {
      'type': 'dropdown',
      'label': 'Ausrichtung Himmelsrichtung',
      'section': 'GIS',
      'values': ['', 'a: S-N', 'b: SO-NW', 'c: W-O', 'd: SW-NO'],
      'validator': (value) => generateValidator(value, "Ausrichtung Himmelsrichtung"),
    },
    {
      'type': 'dropdown',
      'label': 'Schutzgebiet',
      'section': 'GIS',
      'values': ['', 'a: Schutzgebiet', 'b: Kein Schutzgebiet'],
      'validator': (value) => generateValidator(value, "Schutzgebiet"),
    },
    {
      'type': 'dropdown',
      'label': 'Naturdenkmal',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Naturdenkmal"),
    },
    {
      'type': 'dropdown',
      'label': 'Heckendichte',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Heckendichte"),
    },
    {
      'type': 'dropdown',
      'label': 'klimatische Wasserbilanz',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "klimatische Wasserbilanz"),
    },
    {
      'type': 'dropdown',
      'label': 'Bevölkerungsdichte',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Bevölkerungsdichte"),
    },
    {
      'type': 'dropdown',
      'label': 'in Wildtierkorridor',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "in Wildtierkorridor"),
    },
    {
      'type': 'dropdown',
      'label': 'traditionelle Heckenregion',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "traditionelle Heckenregion"),
    },
    {
      'type': 'dropdown',
      'label': 'Franziszeischer Kataster',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Franziszeischer Kataster"),
    },
    {
      'type': 'dropdown',
      'label': 'nutzbare Feldkapazität',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "nutzbare Feldkapazität"),
    },
    {
      'type': 'dropdown',
      'label': 'Humusbilanz',
      'section': 'GIS',
      'values': ['', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'],
      'validator': (value) => generateValidator(value, "Humusbilanz"),
    },

  ];
}

import 'package:flutter/material.dart';

String? generateValidator(String? value, String label, bool required) {
  if (required && (value == null || value.isEmpty)) {
    return 'Enter $label!';
  }
  return null;
}

/// This function defines the data for static inputs (text, number or dropdown)
/// labels must be unique across all static & dynamic widgets!
/// example usage to create widgets:
///    buildFormFieldGrid(inputFields, 'General', setState, columns: columns)
/// 'valueScores' must match amount of 'values' elements
/// 'valueFor' must be one of the following to be correctly recognized:
///    'Rohstoffe'
///    'Ertragssteigerung'
///    'Klimaschutz'
///    'Wasserschutz'
///    'Bodenschutz'
///    'Nähr- & Schadstoffkreisläufe'
///    'Bestäubung'
///    'Schädlings- & Krankheitskontrolle'
///    'Nahrungsquelle'
///    'Korridor'
///    'Fortpflanzungs- & Ruhestätte'
///    'Erholung & Tourismus'
///    'Kulturerbe
List<Map<String, dynamic>> createFormFields() {
  return [
    // general fields
    {
      'type': 'text',
      'label': 'hecken_name',
      "labelEN": "Hedge name",
      "labelDE": "Hecken Name",
      'section': 'General',
      'borderColor': Colors.deepOrange,
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, 'Namen der Hecke', true),
    },
    {
      'type': 'text',
      'label': 'hecken_ort',
      "labelEN": "Place",
      "labelDE": "Ort",
      'section': 'General',
      'borderColor': Colors.deepOrange,
      'controller': TextEditingController(),
      'validator': (value) => generateValidator(value, "Ort der Hecke", true),
    },
    {
      'type': 'text',
      'label': 'gutachter',
      "labelEN": "Reviewer",
      "labelDE": "Gutachter",
      'section': 'General',
      'borderColor': Colors.deepOrange,
      'controller': TextEditingController(),
      'validator': (value) =>
          generateValidator(value, "Namen des Gutachters", true),
    },
    // GIS fields
    {
      'type': 'number',
      'label': 'hecken_laenge',
      "labelEN": "Length [m]",
      "labelDE": "Länge [m]",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'controller': TextEditingController(),
      'validator': (value) =>
          generateValidator(value, "Länge der Hecke [m]", false),
    },
    {
      'type': 'dropdown',
      'label': 'himmelsrichtung',
      "labelEN": "Compass direction",
      "labelDE": "Ausrichtung Himmelsrichtung",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'S-N', 'SO-NW', 'W-O', 'SW-NO'],
      'valueMap': {
        "Schädlings- & Krankheitskontrolle": [null, 5, 3, 1, 3],
        "Ertragssteigerung": [null, 5, 3, 1, 3],
        "Bodenschutz": [null, 5, 3, 1, 3]
      },
      'validator': (value) =>
          generateValidator(value, "Ausrichtung Himmelsrichtung", false),
    },
    {
      'type': 'dropdown',
      'label': 'schutzgebiet',
      "labelEN": "Protected area",
      "labelDE": "Schutzgebiet",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Schutzgebiet', 'Kein Schutzgebiet'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 0],
      },
      'validator': (value) => generateValidator(value, "Schutzgebiet", false),
    },
    {
      'type': 'dropdown',
      'label': 'naturdenkmal',
      "labelEN": "Natural monument",
      "labelDE": "Naturdenkmal",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': [
        '',
        'Naturdenkmal in/nahe der Hecke',
        'Kein Naturdenkmal in/nahe der Hecke'
      ],
      'valueMap': {
        "Kulturerbe": [null, 1, 0]
      },
      'validator': (value) => generateValidator(value, "Naturdenkmal", false),
    },
    {
      'type': 'dropdown',
      'label': 'hecken_dichte',
      "labelEN": "Hedge density",
      "labelDE": "Heckendichte",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': [
        '',
        '<250m/25 ha',
        '250-800m/25 ha',
        '800-1500m/25 ha',
        '1500-2200m/25 ha',
        '>2200m/25 ha'
      ],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
        'Korridor': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
        'Erholung & Tourismus': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, "Heckendichte", false),
    },
    {
      'type': 'dropdown',
      'label': 'klimatische_wasserbilanz',
      "labelEN": "climatic water balance",
      "labelDE": "klimatische Wasserbilanz",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': [
        '',
        'violett',
        'blau ',
        'weißblau-hellblau ',
        'hellgelb-weiß ',
        'rot, orange'
      ],
      'valueMap': {
        'Klimaschutz': [null, 5, 4, 3, 2, 1],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) =>
          generateValidator(value, "klimatische Wasserbilanz", false),
    },
    {
      'type': 'dropdown',
      'label': 'bevoelkerungs_dichte',
      "labelEN": "population density",
      "labelDE": "Bevölkerungsdichte",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', '0-15', '16-30', '31-75', '76-200', '>200'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) =>
          generateValidator(value, "Bevölkerungsdichte", false),
    },
    {
      'type': 'dropdown',
      'label': 'in_wildtierkorridor',
      "labelEN": "in wildlife corridor",
      "labelDE": "in Wildtierkorridor",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'ja', 'nein'],
      'valueMap': {
        "Korridor": [null, 1, 0],
      },
      'validator': (value) =>
          generateValidator(value, "in Wildtierkorridor", false),
    },
    {
      'type': 'dropdown',
      'label': 'traditionelle_heckenregion',
      "labelEN": "traditional hedge region",
      "labelDE": "traditionelle Heckenregion",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Heckenregion', 'Keine Heckenregion'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
      'validator': (value) =>
          generateValidator(value, "traditionelle Heckenregion", false),
    },
    {
      'type': 'dropdown',
      'label': 'franziszeischer_kataster',
      "labelEN": "French cadastre",
      "labelDE": "Franziszeischer Kataster",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': ['', 'Im Kataster erkennbar', 'Nicht im Kataster erkennbar'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
      'validator': (value) =>
          generateValidator(value, "Franziszeischer Kataster", false),
    },
    {
      'type': 'dropdown',
      'label': 'nutzbare_feldkapazitaet',
      "labelEN": "usable field capacity",
      "labelDE": "nutzbare Feldkapazität",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': [
        '',
        'sehr gering (<60mm)',
        'gering (60-140mm)',
        'mittel (140-220mm)',
        'hoch (220-300mm)'
      ],
      'valueMap': {
        'Wasserschutz': [null, 5, 4, 2, 1],
        'Nähr- & Schadstoffkreisläufe': [null, 5, 4, 2, 1],
      },
      'validator': (value) =>
          generateValidator(value, "nutzbare Feldkapazität", false),
    },
    {
      'type': 'dropdown',
      'label': 'humusbilanz',
      "labelEN": "Humus balance",
      "labelDE": "Humusbilanz",
      'section': 'GIS',
      'borderColor': Colors.indigo,
      'values': [
        '',
        'Standortgruppe 1, 2',
        'Standortgruppe 3, 4',
        'Standortgruppe 5, 6'
      ],
      'valueMap': {
        "Klimaschutz": [null, 1, 3, 5],
      },
      'validator': (value) => generateValidator(value, "Humusbilanz", false),
    },
    // gelände fields
    {
      'type': 'dropdown',
      'label': 'hang_position',
      "labelEN": "position to the slope",
      "labelDE": "Position zum Hang",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        'in Hangrichtung',
        'Oberhang',
        'diagonal zur Falllinie',
        'Unterhang / Hangfuß',
        'im Hang, quer',
        '(keine Hangneigung)'
      ],
      'valueMap': {
        'Wasserschutz': [null, 1, 1, 3, 4, 5, 1],
        'Bodenschutz': [null, 1, 1, 3, 4, 5, 1],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 1, 3, 4, 5, 1],
      },
      'validator': (value) =>
          generateValidator(value, 'Position zum Hang', false),
    },
    {
      'type': 'dropdown',
      'label': 'hang_neigung',
      "labelEN": "Slope gradient",
      "labelDE": "Hangneigung",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        'annähernd eben',
        'Neigung merkbar',
        'deutlich steigend',
        'durchschn. Bergstraße',
        'steilste Abschnitte v. Bergstraßen'
      ],
      'valueMap': {
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Hangneigung', false),
    },
    {
      'type': 'dropdown',
      'label': 'netzwerk',
      "labelEN": "Network",
      "labelDE": "Netzwerk",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        'keine Verbindungen zu (semi‑) natürlichen LR',
        '1 Verbindung ',
        '>1 Verbindung ',
        'Teil von Rainnetzwerk'
      ],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 5, 3],
        'Korridor': [null, 1, 2, 5, 3],
        'Kulturerbe': [null, 1, 3, 5, 5],
      },
      'validator': (value) => generateValidator(value, 'Netzwerk', false),
    },
    {
      'type': 'dropdown',
      'label': 'erschliessung',
      "labelEN": "Access",
      "labelDE": "Erschließung",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', 'Weg an/in Hecke', 'Sichtbeziehung zu Hecke', 'Kein Weg'],
      'valueMap': {
        'Erholung & Tourismus': [null, 5, 3, 1],
      },
      'validator': (value) => generateValidator(value, 'Erschließung', false),
    },
    {
      'type': 'dropdown',
      'label': 'horizontale_schichtung',
      "labelEN": "horizontal layering",
      "labelDE": "horizontale Schichtung",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        'nur Baumschicht',
        'nur Strauchschicht',
        'Baum- und Strauchschicht'
      ],
      'valueMap': {
        'Ertragssteigerung': [null, 0, 0, 1, 1],
        'Wasserschutz': [null, 0, 0, 1, 1],
        'Schädlings- & Krankheitskontrolle': [null, 0, 0, 1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 0, 0, 1, 1],
      },
      'validator': (value) =>
          generateValidator(value, 'horizontale Schichtung', false),
    },
    {
      'type': 'dropdown',
      'label': 'vertikale_schichtung',
      "labelEN": "vertical layering",
      "labelDE": "vertikale Schichtung",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', 'nur Kernzone', 'nur Mantelzone', 'Kern- und Mantelzone'],
      'valueMap': {
        'Fortpflanzungs- & Ruhestätte': [null, 0, 0, 1],
      },
      'validator': (value) =>
          generateValidator(value, 'vertikale Schichtung', false),
    },
    {
      'type': 'dropdown',
      'label': 'strukturvielfalt',
      "labelEN": "structural diversity",
      "labelDE": "Strukturvielfalt",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        '+/- gleich hoch, gleich breit',
        '1 Dimension variabel',
        '2 Dimensionen variabel'
      ],
      'valueMap': {
        'Schädlings- & Krankheitskontrolle': [null, 1, 3, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 3, 5],
      },
      'validator': (value) =>
          generateValidator(value, 'Strukturvielfalt', false),
    },
    {
      'type': 'dropdown',
      'label': 'luecken',
      "labelEN": "Gaps",
      "labelDE": "Lücken",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        'min. 1 Lücke >5m',
        '>10% Lücken',
        '5-10% Lücken',
        '<5% Lücken',
        'keine Lücken'
      ],
      'valueMap': {
        'Ertragssteigerung': [null, 1, 1, 3, 4, 5],
        'Bodenschutz': [null, 1, 1, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 1, 3, 4, 5],
        'Korridor': [null, 1, 1, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Lücken', false),
    },
    {
      'type': 'dropdown',
      'label': 'totholz',
      "labelEN": "deadwood",
      "labelDE": "Totholz",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        'kein Totholz',
        'kein Merkmal',
        '1 Merkmal',
        '2 Merkmale',
        '3 Merkmale:'
      ],
      'valueMap': {
        'Rohstoffe': [null, 0, 0, 0, -1, -1],
        'Nähr- & Schadstoffkreisläufe': [null, 5, 4, 3, 2, 1],
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Totholz', false),
    },
    {
      'type': 'dropdown',
      'label': 'alterszusammensetzung',
      "labelEN": "Age composition",
      "labelDE": "Alterszusammensetzung",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        '<6 Jahre',
        '6-20 Jahre',
        '20-50 Jahre',
        '>50 Jahre',
        'gemischtes Alter'
      ],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 4, 5, 4],
        'Bestäubung': [null, 1, 2, 4, 5, 4],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 4, 3, 5],
        'Erholung & Tourismus': [null, 1, 2, 4, 5, 4],
      },
      'validator': (value) =>
          generateValidator(value, 'Alterszusammensetzung', false),
    },
    {
      'type': 'dropdown',
      'label': 'saum_art',
      "labelEN": "hem type",
      "labelDE": "Saumart",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', 'Saum', 'Mähstreifen', 'Grünland', 'nichts davon'],
      'valueMap': {
        'Klimaschutz': [null, 1, 0.8, 0.6, 1],
        'Bestäubung': [null, 1, 0.8, 0.6, 1],
        'Schädlings- & Krankheitskontrolle': [null, 1, 0.8, 0.6, 1],
        'Nahrungsquelle': [null, 1, 0.8, 0.6, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 0.8, 0.6, 1],
        'Erholung & Tourismus': [null, 1, 0.8, 0.6, 1],
      },
      'validator': (value) => generateValidator(value, 'Saumart', false),
    },
    {
      'type': 'dropdown',
      'label': 'saum_breite',
      "labelEN": "Hem width",
      "labelDE": "Saumbreite",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', 'kein Saum', '< 2 m', '2-3 m', '3-4 m', '> 4 m'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
        'Erholung & Tourismus': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Saumbreite', false),
    },
    {
      'type': 'dropdown',
      'label': 'hecken_hoehe',
      "labelEN": "Height",
      "labelDE": "Höhe",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', '<2 m', '2-5 m', '5-10 m', '10-15 m', '>15 m'],
      'valueMap': {
        'Ertragssteigerung': [null, 1, 2, 3, 4, 5],
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Korridor': [null, 1, 3, 5, 5, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Höhe', false),
    },
    {
      'type': 'dropdown',
      'label': 'hecken_breite',
      "labelEN": "Width",
      "labelDE": "Breite",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', '<2 m', '2-4 m', '4-6 m', '6-8 m', '8-12 m'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 2, 3, 4, 5],
        'Korridor': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Breite', false),
    },
    {
      'type': 'dropdown',
      'label': 'baumanteil',
      "labelEN": "Tree proportion",
      "labelDE": "Baumanteil",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', '0', '1-2/ 100m', '3-9/ 100m', '10-20/ 100m', '>20/ 100m'],
      'valueMap': {
        'Rohstoffe': [null, 1, 1, 1, 2, 3],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) => generateValidator(value, 'Baumanteil', false),
    },
    {
      'type': 'dropdown',
      'label': 'anzahl_gehoelz_arten',
      "labelEN": "Number of wood species",
      "labelDE": "Anzahl Gehölzarten",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': [
        '',
        '1-3 Arten in 30m',
        '4-5 Arten in 30m',
        '6-7 Arten in 30m',
        '8-9 Arten in 30m',
        '10+ Arten in 30m'
      ],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
        'Erholung & Tourismus': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
      },
      'validator': (value) =>
          generateValidator(value, 'Anzahl Gehölzarten', false),
    },
    {
      'type': 'dropdown',
      'label': 'dominanzen',
      "labelEN": "Dominances",
      "labelDE": "Dominanzen",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', '(quasi) keine', 'leichte Dominanz', 'starke Dominanz'],
      'valueMap': {
        'Bestäubung': [null, 1, 3, 5],
        'Nahrungsquelle': [null, 1, 3, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 3, 5],
      },
      'validator': (value) => generateValidator(value, 'Dominanzen', false),
    },
    {
      'type': 'dropdown',
      'label': 'neophyten',
      "labelEN": "Neophytes",
      "labelDE": "Neophyten",
      'section': 'Gelände',
      'borderColor': Colors.green,
      'values': ['', '>50%', '25-50%', '10-25%', '5-10%', '0-5%'],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Kulturerbe': [null, 5, 4, 3, 2, 1]
      },
      'validator': (value) => generateValidator(value, 'Neophyten', false),
    },
    // anmerkungen
    {
      'type': 'text',
      'label': 'anmerkungen_kommentare',
      "labelEN": "Notes",
      "labelDE": "Anmerkungen",
      'section': 'Anmerkungen',
      'borderColor': Colors.amber,
      'controller': TextEditingController(),
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
    {
      'headerText': 'nachbar_flaechen',
      "headerTextEN": "Neighboring areas",
      "headerTextDE": "Nachbarflächen",
      'borderColor': Colors.greenAccent,
      'defValues': const [
        '',
        'Siedlung/Straße',
        'Grünland ext.',
        'Grünland int.',
        'Acker',
        'unbefestigter Weg',
        'Brache'
      ],
      'valueMap': {
        'Ertragssteigerung': [null, 0, 1, 1, 1, 0, 0],
        'Nähr- & Schadstoffkreisläufe': [null, 4, 1, 2, 5, 1, 1],
        'Bestäubung': [null, -1, 1, 0, 0, -1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, -2, 2, 1, -1, -1, 2],
      },
      'section': 'Gelände',
    },
    {
      'headerText': 'nutzungs_spuren',
      "headerTextEN": "Traces of use",
      "headerTextDE": "Nutzungsspuren",
      'borderColor': Colors.greenAccent,
      'defValues': const [
        '',
        'Siedlung/Straße',
        'Grünland ext.',
        'Grünland int.',
        'Acker',
        'unbefestigter Weg',
        'Brache'
      ],
      'valueMap': {
        'Rohstoffe': [null, 0, 1, 1, 1, 1],
        'Bestäubung': [null, 0, 1, 0, 0, 0],
      },
      'section': 'Gelände',
      'maxDropdownCount': 4,
    },
    {
      'headerText': 'zusatz_strukturen',
      "headerTextEN": "Additional structures",
      "headerTextDE": "Zusatzstrukturen",
      'borderColor': Colors.greenAccent,
      'defValues': const [
        '',
        'Jagd, z.B. Hochstand',
        'Erholung, z.B. Bank',
        'Bildung, z.B. Schautafel',
        'Kulturdenkmal',
        'nichts'
      ],
      'valueMap': {
        'Rohstoffe': [null, 1, 0, 0, 0, 0],
        'Erholung & Tourismus': [null, 0.5, 1, 1, 0.5, 0],
        'Kulturerbe': [null, 0, 0, 0, 1, 0],
      },
      'section': 'Gelände',
      'maxDropdownCount': 4,
    },
    {
      'headerText': 'management',
      "headerTextEN": "Management",
      "headerTextDE": "Management",
      'borderColor': Colors.greenAccent,
      'defValues': const [
        '',
        'nichts sichtbar',
        'Baum/Strauch nachgepflanzt',
        'Seitenschnitt sichtbar',
        'auf Stock gesetzt',
        'Einzelbaum/-strauch Rückschnitte',
        'Einzelstamm Entnahme'
      ],
      'valueMap': {
        'Rohstoffe': [null, 0, 0, -1, 2, 0, 1],
        'Bestäubung': [null, 1, 0, -1, 1, 1, 0],
      },
      'section': 'Gelände',
      'maxDropdownCount': 5,
    },
    {
      'headerText': 'sonder_form',
      "headerTextEN": "Special form",
      "headerTextDE": "Sonderform",
      'borderColor': Colors.greenAccent,
      'defValues': const [
        '',
        'keine Sonderform',
        'Lesesteinhecke',
        'Hecke auf Hochrain',
        'Böschungshecke',
        'Grabenhecke'
      ],
      'valueMap': {
        'Nähr- & Schadstoffkreisläufe': [null, 0, 1, 1, 0, 0],
        'Bestäubung': [null, 0, 1, 1, 1, 1],
        'Schädlings- & Krankheitskontrolle': [null, 0, 2, 2, 1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 0, 1, 1, 1, 1],
        'Kulturerbe': [null, 0, 1, 1, 1, 1],
      },
      'section': 'Gelände',
      'maxDropdownCount': 4,
    },
  ];
}

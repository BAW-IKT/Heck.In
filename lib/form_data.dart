import 'package:flutter/material.dart';
import 'colors.dart';

List<Map<String, dynamic>> getSections() {
  return [
    {
      "label": "general",
      "labelEN": "General",
      "labelDE": "Allgemeines",
      "icon": Icons.location_history,
      "iconActive": Icons.location_history_outlined,
    },
    {
      "label": "physical",
      "labelEN": "Physical Characteristics",
      "labelDE": "Physikalische Merkmale",
      "icon": Icons.straighten,
      "iconActive": Icons.straighten_outlined,
    },
    {
      "label": "environmental",
      "labelEN": "Environmental Factors",
      "labelDE": "Umweltfaktoren",
      "icon": Icons.directions_walk,
      "iconActive": Icons.directions_walk_outlined,
    },
    {
      "label": "biodiversity",
      "labelEN": "Biodiversity and Composition",
      "labelDE": "Biodiversität und Zusammensetzung",
      "icon": Icons.compost,
      "iconActive": Icons.compost_outlined,
    },
    {
      "label": "images",
      "labelEN": "Images",
      "labelDE": "Bilder",
      "icon": Icons.image,
      "iconActive": Icons.image_outlined
    },
  ];
}

Map<String, Color> getRadarGroupColors() {
  return {
    'Bereitstellend': MyColors.red,
    'Regulierend': MyColors.blue,
    'Habitat': MyColors.green,
    'Kulturell': MyColors.orange,
  };
}

Map<String, String> getRadarDataGroups() {
  return {
    'Rohstoffe': 'Bereitstellend',
    'Ertragssteigerung': 'Bereitstellend',
    'Klimaschutz': 'Regulierend',
    'Wasserschutz': 'Regulierend',
    'Bodenschutz': 'Regulierend',
    'Nähr- & Schadstoffkreisläufe': 'Regulierend',
    'Bestäubung': 'Regulierend',
    'Schädlings- & Krankheitskontrolle': 'Regulierend',
    'Nahrungsquelle': 'Habitat',
    'Korridor': 'Habitat',
    'Fortpflanzungs- & Ruhestätte': 'Habitat',
    'Erholung & Tourismus': 'Kulturell',
    'Kulturerbe': 'Kulturell'
  };
}

List<String> getSectionsFromLocale(String locale) {
  return getSections()
      .map((section) => section["label$locale"].toString())
      .toList();
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
      'section': 'general',
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': 'text',
      'label': 'hecken_ort',
      "labelEN": "Place",
      "labelDE": "Ort",
      'section': 'general',
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': 'text',
      'label': 'gutachter',
      "labelEN": "Reviewer",
      "labelDE": "Gutachter",
      'section': 'general',
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': 'text',
      'label': 'anmerkungen_kommentare',
      "labelEN": "Notes",
      "labelDE": "Anmerkungen",
      'section': 'general',
      'borderColor': MyColors.yellow,
      'controller': TextEditingController(),
    },
    // gis fields
    {
      'type': 'number',
      'label': 'hecken_laenge',
      "labelEN": "Length [m]",
      "labelDE": "Länge [m]",
      'section': 'physical',
      'borderColor': MyColors.blue,
      'controller': TextEditingController(),
    },
    {
      'type': 'dropdown',
      'label': 'himmelsrichtung',
      "labelEN": "Compass direction",
      "labelDE": "Ausrichtung Himmelsrichtung",
      'section': 'physical',
      'borderColor': MyColors.blue,
      'values': ['', 's_n', 'so_nw', 'w_o', 'sw_no'],
      'valuesEN': ['', 'S-N', 'SE-NW', 'W-O', 'SW-NE'],
      'valuesDE': ['', 'S-N', 'SO-NW', 'W-O', 'SW-NO'],
      'valueMap': {
        "Schädlings- & Krankheitskontrolle": [null, 5, 3, 1, 3],
        "Ertragssteigerung": [null, 5, 3, 1, 3],
        "Bodenschutz": [null, 5, 3, 1, 3]
      },
    },
    {
      'type': 'dropdown',
      'label': 'schutzgebiet',
      "labelEN": "Protected area",
      "labelDE": "Schutzgebiet",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'schutzgebiet', 'kein_schutzgebiet'],
      'valuesEN': ['', 'protected area', 'no protected area'],
      'valuesDE': ['', 'Schutzgebiet', 'Kein Schutzgebiet'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 0],
      },
    },
    {
      'type': 'dropdown',
      'label': 'naturdenkmal',
      "labelEN": "Natural monument",
      "labelDE": "Naturdenkmal",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'naturdenkmal_in_nahe_hecke', 'kein_naturdenkmal_in_nahe_hecke' ],
      'valuesEN': ['', 'Natural monument in/near the hedge', 'No natural monument in/near the hedge' ],
      'valuesDE': ['', 'Naturdenkmal in/nahe der Hecke', 'Kein Naturdenkmal in/nahe der Hecke' ],
      'valueMap': {
        "Kulturerbe": [null, 1, 0]
      },
    },
    {
      'type': 'dropdown',
      'label': 'hecken_dichte',
      "labelEN": "Hedge density",
      "labelDE": "Heckendichte",
      'section': 'physical',
      'borderColor': MyColors.blue,
      'values': ['', 'lt_250m_or_25ha', '250_to_800m_or_25ha', '800_to_1500m_or_25ha', '1500_to_2200m_or_25ha', 'gt_2200m_or_25ha'],
      'valuesEN': ['', '<250m/25 ha', '250-800m/25 ha', '800-1500m/25 ha', '1500-2200m/25 ha', '>2200m/25 ha'],
      'valuesDE': ['', '<250m/25 ha', '250-800m/25 ha', '800-1500m/25 ha', '1500-2200m/25 ha', '>2200m/25 ha'],
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
    },
    {
      'type': 'dropdown',
      'label': 'klimatische_wasserbilanz',
      "labelEN": "climatic water balance",
      "labelDE": "klimatische Wasserbilanz",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'violett', 'blau ', 'weissblau_hellblau ', 'hellgelb_weiss', 'rot, orange'],
      'valuesEN': ['', 'purple', 'blue ', 'white-blue-light blue ', 'light yellow-white ', 'red, orange'],
      'valuesDE': ['', 'violett', 'blau ', 'weißblau-hellblau ', 'hellgelb-weiß ', 'rot, orange'],
      'valueMap': {
        'Klimaschutz': [null, 5, 4, 3, 2, 1],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'bevoelkerungs_dichte',
      "labelEN": "population density",
      "labelDE": "Bevölkerungsdichte",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', '0_to_15', '16_to_30', '31_to_75', '76_to_200', 'gt_200'],
      'valuesEN': ['', '0-15', '16-30', '31-75', '76-200', '>200'],
      'valuesDE': ['', '0-15', '16-30', '31-75', '76-200', '>200'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'in_wildtierkorridor',
      "labelEN": "in wildlife corridor",
      "labelDE": "in Wildtierkorridor",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'ja', 'nein'],
      'valuesEN': ['', 'yes', 'no'],
      'valuesDE': ['', 'ja', 'nein'],
      'valueMap': {
        "Korridor": [null, 1, 0],
      },
    },
    {
      'type': 'dropdown',
      'label': 'traditionelle_heckenregion',
      "labelEN": "traditional hedge region",
      "labelDE": "traditionelle Heckenregion",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'heckenregion', 'keine_heckenregion'],
      'valuesEN': ['', 'hedge region', 'no hedge region'],
      'valuesDE': ['', 'Heckenregion', 'Keine Heckenregion'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'franziszeischer_kataster',
      "labelEN": "French cadastre",
      "labelDE": "Franziszeischer Kataster",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'im_kataster_erkennbar', 'nicht_im_kataster_erkennbar'],
      'valuesEN': ['', 'Identifiable in cadastre', 'Not identifiable in cadastre'],
      'valuesDE': ['', 'Im Kataster erkennbar', 'Nicht im Kataster erkennbar'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'nutzbare_feldkapazitaet',
      "labelEN": "usable field capacity",
      "labelDE": "nutzbare Feldkapazität",
      'section': 'physical',
      'borderColor': MyColors.blue,
      'values': ['', 'lt_60mm', '60_to_140mm', '140_to-220mm', '220_to_300mm'],
      'valuesEN': ['', 'Very low (<60mm)', 'Low (60-140mm)', 'Medium (140-220mm)', 'High (220-300mm)'],
      'valuesDE': ['', 'sehr gering (<60mm)', 'gering (60-140mm)', 'mittel (140-220mm)', 'hoch (220-300mm)'],
      'valueMap': {
        'Wasserschutz': [null, 5, 4, 2, 1],
        'Nähr- & Schadstoffkreisläufe': [null, 5, 4, 2, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'humusbilanz',
      "labelEN": "Humus balance",
      "labelDE": "Humusbilanz",
      'section': 'environmental',
      'borderColor': MyColors.blue,
      'values': ['', 'standortgruppe_1_2', 'standortgruppe_3_4', 'standortgruppe_5_6'],
      'valuesEN': ['', 'site group 1, 2', 'site group 3, 4', 'site group 5, 6'],
      'valuesDE': ['', 'Standortgruppe 1, 2', 'Standortgruppe 3, 4', 'Standortgruppe 5, 6'],
      'valueMap': {
        "Klimaschutz": [null, 1, 3, 5],
      },
    },
    // gelände fields
    {
      'type': 'dropdown',
      'label': 'hang_position',
      "labelEN": "position to the slope",
      "labelDE": "Position zum Hang",
      'section': 'physical',
      'borderColor': MyColors.green,
      'values': ['', 'in_hangrichtung', 'oberhang', 'diagonal_zur_falllinie', 'unterhang_hangfuss', 'im_hang_quer', 'keine_hangneigung'],
      'valuesEN': ['', 'upslope', 'upslope', 'diagonal to fall line', 'downslope / toe of slope', 'downslope, across', '(no slope)'],
      'valuesDE': ['', 'in Hangrichtung', 'Oberhang', 'diagonal zur Falllinie', 'Unterhang / Hangfuß', 'im Hang, quer', '(keine Hangneigung)'],
      'valueMap': {
        'Wasserschutz': [null, 1, 1, 3, 4, 5, 1],
        'Bodenschutz': [null, 1, 1, 3, 4, 5, 1],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 1, 3, 4, 5, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'hang_neigung',
      "labelEN": "Slope gradient",
      "labelDE": "Hangneigung",
      'section': 'physical',
      'borderColor': MyColors.green,
      'values': ['', 'annaehernd_eben', 'neigung_merkbar', 'deutlich_steigend', 'durchschn_bergstrasse', 'steilste_abschnitte_v_bergstraßen'],
      'valuesEN': ['', 'approximately level', 'slope noticeable', 'clearly rising', 'average mountain road', 'steepest sections of mountain roads'],
      'valuesDE': ['', 'annähernd eben', 'Neigung merkbar', 'deutlich steigend', 'durchschn. Bergstraße', 'steilste Abschnitte v. Bergstraßen'],
      'valueMap': {
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'netzwerk',
      "labelEN": "Network",
      "labelDE": "Netzwerk",
      'section': 'environmental',
      'borderColor': MyColors.green,
      'values': ['', 'keine_verbindungen_natuerlichen_lr', '1_verbindung', 'gt_1_verbindung', 'teil_regennetzwerk'],
      'valuesEN': ['', 'no connections to (semi-) natural LR', '1 connection', '>1 connection', 'part of rain network'],
      'valuesDE': ['', 'keine Verbindungen zu (semi‑) natürlichen LR', '1 Verbindung', '>1 Verbindung', 'Teil von Regennetzwerk'],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 5, 3],
        'Korridor': [null, 1, 2, 5, 3],
        'Kulturerbe': [null, 1, 3, 5, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'erschliessung',
      "labelEN": "Access",
      "labelDE": "Erschließung",
      'section': 'environmental',
      'borderColor': MyColors.green,
      'values': ['', 'weg_an_in_hecke', 'sichtbeziehung_zu_hecke', 'kein_weg'],
      'valuesEN': ['', 'path at/in hedge', 'line of sight to hedge', 'no path'],
      'valuesDE': ['', 'Weg an/in Hecke', 'Sichtbeziehung zu Hecke', 'Kein Weg'],
      'valueMap': {
        'Erholung & Tourismus': [null, 5, 3, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'horizontale_schichtung',
      "labelEN": "horizontal layering",
      "labelDE": "horizontale Schichtung",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'nur_baumschicht', 'nur_strauchschicht', 'baum_und_strauchschicht'],
      'valuesEN': ['', 'tree layer only', 'shrub layer only', 'tree and shrub layer'],
      'valuesDE': ['', 'nur Baumschicht', 'nur Strauchschicht', 'Baum- und Strauchschicht'],
      'valueMap': {
        'Ertragssteigerung': [null, 0, 0, 1, 1],
        'Wasserschutz': [null, 0, 0, 1, 1],
        'Schädlings- & Krankheitskontrolle': [null, 0, 0, 1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 0, 0, 1, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'vertikale_schichtung',
      "labelEN": "vertical layering",
      "labelDE": "vertikale Schichtung",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'nur_kernzone', 'nur_mantelzone', 'kern_und_mantelzone'],
      'valuesEN': ['', 'core zone only', 'mantle zone only', 'core and mantle zone'],
      'valuesDE': ['', 'nur Kernzone', 'nur Mantelzone', 'Kern- und Mantelzone'],
      'valueMap': {
        'Fortpflanzungs- & Ruhestätte': [null, 0, 0, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'strukturvielfalt',
      "labelEN": "structural diversity",
      "labelDE": "Strukturvielfalt",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'gleich_hoch_gleich_breit', '1_dimension_variabel', '2_dimensionen_variabel'],
      'valuesEN': ['', '+/- same height, same width', '1 dimension variable', '2 dimensions variable'],
      'valuesDE': ['', '+/- gleich hoch, gleich breit', '1 Dimension variabel', '2 Dimensionen variabel'],
      'valueMap': {
        'Schädlings- & Krankheitskontrolle': [null, 1, 3, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 3, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'luecken',
      "labelEN": "Gaps",
      "labelDE": "Lücken",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'min_1_luecke_gt_5m', 'gt_10pct_luecken', '5_to_10pct_luecken', 'lt_5pct_luecken', 'keine_luecken'],
      'valuesEN': ['', 'min. 1 gap >5m', '>10% gaps', '5-10% gaps', '<5% gaps', 'no gaps'],
      'valuesDE': ['', 'min. 1 Lücke >5m', '>10% Lücken', '5-10% Lücken', '<5% Lücken', 'keine Lücken'],
      'valueMap': {
        'Ertragssteigerung': [null, 1, 1, 3, 4, 5],
        'Bodenschutz': [null, 1, 1, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 1, 3, 4, 5],
        'Korridor': [null, 1, 1, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'totholz',
      "labelEN": "deadwood",
      "labelDE": "Totholz",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'kein_totholz', 'kein_merkmal', '1_merkmal', '2_merkmale', '3_merkmale'],
      'valuesEN': ['', 'no deadwood', 'no feature', '1 feature', '2 features', '3 features'],
      'valuesDE': ['', 'kein Totholz', 'kein Merkmal', '1 Merkmal', '2 Merkmale', '3 Merkmale'],
      'valueMap': {
        'Rohstoffe': [null, 0, 0, 0, -1, -1],
        'Nähr- & Schadstoffkreisläufe': [null, 5, 4, 3, 2, 1],
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'alterszusammensetzung',
      "labelEN": "Age composition",
      "labelDE": "Alterszusammensetzung",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'lt_6_jahre', '6_to_20_jahre', '20_to_50_jahre', 'gt_50_jahre', 'gemischtes_alter'],
      'valuesEN': ['', '<6 years', '6-20 years', '20-50 years', '>50 years', 'mixed age'],
      'valuesDE': ['', '<6 Jahre', '6-20 Jahre', '20-50 Jahre', '>50 Jahre', 'gemischtes Alter'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 4, 5, 4],
        'Bestäubung': [null, 1, 2, 4, 5, 4],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 4, 3, 5],
        'Erholung & Tourismus': [null, 1, 2, 4, 5, 4],
      },
    },
    {
      'type': 'dropdown',
      'label': 'saum_art',
      "labelEN": "hem type",
      "labelDE": "Saumart",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'saum', 'maehstreifen', 'gruenland', 'nichts_davon'],
      'valuesEN': ['', 'fringe', 'mowed strip', 'grassland', 'none of the above'],
      'valuesDE': ['', 'Saum', 'Mähstreifen', 'Grünland', 'nichts davon'],
      'valueMap': {
        'Klimaschutz': [null, 1, 0.8, 0.6, 1],
        'Bestäubung': [null, 1, 0.8, 0.6, 1],
        'Schädlings- & Krankheitskontrolle': [null, 1, 0.8, 0.6, 1],
        'Nahrungsquelle': [null, 1, 0.8, 0.6, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 0.8, 0.6, 1],
        'Erholung & Tourismus': [null, 1, 0.8, 0.6, 1],
      },
    },
    {
      'type': 'dropdown',
      'label': 'saum_breite',
      "labelEN": "Hem width",
      "labelDE": "Saumbreite",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'kein_saum', 'lt_2m', '2_to_3m', '3_to_4m', 'gt_4m'],
      'valuesEN': ['', 'no fringe', '< 2 m', '2-3 m', '3-4 m', '> 4 m'],
      'valuesDE': ['', 'kein Saum', '< 2 m', '2-3 m', '3-4 m', '> 4 m'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
        'Erholung & Tourismus': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'hecken_hoehe',
      "labelEN": "Height",
      "labelDE": "Höhe",
      'section': 'physical',
      'borderColor': MyColors.green,
      'values': ['', 'lt_2m', '2_to_5m', '5_to_10m', '10_to_15m', 'gt_15m'],
      'valuesEN': ['', '<2 m', '2-5 m', '5-10 m', '10-15 m', '>15 m'],
      'valuesDE': ['', '<2 m', '2-5 m', '5-10 m', '10-15 m', '>15 m'],
      'valueMap': {
        'Ertragssteigerung': [null, 1, 2, 3, 4, 5],
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Korridor': [null, 1, 3, 5, 5, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'hecken_breite',
      "labelEN": "Width",
      "labelDE": "Breite",
      'section': 'physical',
      'borderColor': MyColors.green,
      'values': ['', 'lt_2m', '2_to_4m', '4_to_6m', '6_to_8m', '8_to_12m'],
      'valuesEN': ['', '<2 m', '2-4 m', '4-6 m', '6-8 m', '8-12 m'],
      'valuesDE': ['', '<2 m', '2-4 m', '4-6 m', '6-8 m', '8-12 m'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 2, 3, 4, 5],
        'Korridor': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'baumanteil',
      "labelEN": "Tree proportion",
      "labelDE": "Baumanteil",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', '0', '1_to_2_per_00m', '3_to_9_per_00m', '10_to_20_per_100m', 'gt_20_per_100m'],
      'valuesEN': ['', '0', '1-2/ 100m', '3-9/ 100m', '10-20/ 100m', '>20/ 100m'],
      'valuesDE': ['', '0', '1-2/ 100m', '3-9/ 100m', '10-20/ 100m', '>20/ 100m'],
      'valueMap': {
        'Rohstoffe': [null, 1, 1, 1, 2, 3],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'anzahl_gehoelz_arten',
      "labelEN": "Number of wood species",
      "labelDE": "Anzahl Gehölzarten",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', '1_to_3_arten_in_30m', '4_to_5_arten_in_30m', '6_to_7_arten_in_30m', '8_to_9_arten_in_30m', 'gt_10_arten_in_30m'],
      'valuesEN': ['', '1-3 species in 30m', '4-5 species in 30m', '6-7 species in 30m', '8-9 species in 30m', '10+ species in 30m'],
      'valuesDE': ['', '1-3 Arten in 30m', '4-5 Arten in 30m', '6-7 Arten in 30m', '8-9 Arten in 30m', '10+ Arten in 30m'],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
        'Erholung & Tourismus': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'dominanzen',
      "labelEN": "Dominances",
      "labelDE": "Dominanzen",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'quasi_keine', 'leichte_dominanz', 'starke_dominanz'],
      'valuesEN': ['', '(quasi) none', 'slight dominance', 'strong dominance'],
      'valuesDE': ['', '(quasi) keine', 'leichte Dominanz', 'starke Dominanz'],
      'valueMap': {
        'Bestäubung': [null, 1, 3, 5],
        'Nahrungsquelle': [null, 1, 3, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 3, 5],
      },
    },
    {
      'type': 'dropdown',
      'label': 'neophyten',
      "labelEN": "Neophytes",
      "labelDE": "Neophyten",
      'section': 'biodiversity',
      'borderColor': MyColors.green,
      'values': ['', 'gt_50pct', '25_to_50pct', '10_to_25pct', '5_to_10pct', '0_to_5pct'],
      'valuesEN': ['', '>50%', '25-50%', '10-25%', '5-10%', '0-5%'],
      'valuesDE': ['', '>50%', '25-50%', '10-25%', '5-10%', '0-5%'],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Kulturerbe': [null, 5, 4, 3, 2, 1]
      },
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
///      section: 'general',
///      dropdownKeys: _dropdownsKeys,
///      onDropdownChanged: onDynamicDropdownsChanged,
///      columns: dynamicColumns,
///    ),
List<Map<String, dynamic>> createDynamicFormFields() {
  return [
    // gelaende fields
    {
      'headerText': 'nachbar_flaechen',
      "headerTextEN": "Neighboring areas",
      "headerTextDE": "Nachbarflächen",
      'borderColor': MyColors.coral,
      'values': const [
        '',
        'Siedlung/Straße',
        'Grünland ext.',
        'Grünland int.',
        'Acker',
        'unbefestigter Weg',
        'Brache'
      ],
      'valuesEN': const [
        '',
        'settlement/road',
        'grassland ext',
        'grassland int',
        'arable land',
        'unpaved road',
        'fallow land'
      ],
      'valuesDE': const [
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
      'section': 'general',
    },
    {
      'headerText': 'nutzungs_spuren',
      "headerTextEN": "Traces of use",
      "headerTextDE": "Nutzungsspuren",
      'borderColor': MyColors.coral,
      'values': const [
        '',
        'keine ersichtlich',
        'Bienenstöcke',
        'Obst',
        'gelagerte Holzstapel',
        'andere Nutzung',
        'Brache'
      ],
      'valuesEN': const [
        '',
        'none apparent',
        'bee hives',
        'fruit',
        'stored wood piles',
        'other use',
        'fallow'
      ],
      'valuesDE': const [
        '',
        'keine ersichtlich',
        'Bienenstöcke',
        'Obst',
        'gelagerte Holzstapel',
        'andere Nutzung',
        'Brache'
      ],
      'valueMap': {
        'Rohstoffe': [null, 0, 1, 1, 1, 1],
        'Bestäubung': [null, 0, 1, 0, 0, 0],
      },
      'section': 'physical',
      'maxDropdownCount': 4,
    },
    {
      'headerText': 'zusatz_strukturen',
      "headerTextEN": "Additional structures",
      "headerTextDE": "Zusatzstrukturen",
      'borderColor': MyColors.coral,
      'values': const [
        '',
        'Jagd, z.B. Hochstand',
        'Erholung, z.B. Bank',
        'Bildung, z.B. Schautafel',
        'Kulturdenkmal',
        'nichts'
      ],
      'valuesEN': const [
        '',
        'hunting, e.g. high stand',
        'recreation, e.g. bench',
        'education, e.g. display board',
        'cultural monument',
        'nothing'
      ],
      'valuesDE': const [
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
      'section': 'physical',
      'maxDropdownCount': 4,
    },
    {
      'headerText': 'management',
      "headerTextEN": "Management",
      "headerTextDE": "Management",
      'borderColor': MyColors.coral,
      'values': const [
        '',
        'nichts sichtbar',
        'Baum/Strauch nachgepflanzt',
        'Seitenschnitt sichtbar',
        'auf Stock gesetzt',
        'Einzelbaum/-strauch Rückschnitte',
        'Einzelstamm Entnahme'
      ],
      'valuesEN': const [
        '',
        'nothing visible',
        'tree/shrub replanted',
        'side cut visible',
        'stocked',
        'single tree/shrub pruning',
        'single trunk removal'
      ],
      'valuesDE': const [
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
      'section': 'environmental',
      'maxDropdownCount': 5,
    },
    {
      'headerText': 'sonder_form',
      "headerTextEN": "Special form",
      "headerTextDE": "Sonderform",
      'borderColor': MyColors.coral,
      'values': const [
        '',
        'keine Sonderform',
        'Lesesteinhecke',
        'Hecke auf Hochrain',
        'Böschungshecke',
        'Grabenhecke'
      ],
      'valuesEN': const [
        '',
        'no special shape',
        'reading stone hedge',
        'hedge on high ground',
        'slope hedge',
        'ditch hedge'
      ],
      'valuesDE': const [
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
      'section': 'physical',
      'maxDropdownCount': 4,
    },
  ];
}

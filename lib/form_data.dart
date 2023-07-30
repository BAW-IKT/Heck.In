import 'package:flutter/material.dart';
import 'package:hedge_profiler_flutter/form_utils.dart';
import 'colors.dart';

List<Map<String, dynamic>> getSections() {
  return [
    {
      "label": "general",
      "labelEN": "General",
      "labelDE": "Allgemeines",
      "icon": Icons.location_history,
      "iconActive": Icons.location_history,
    },
    {
      "label": "physical",
      "labelEN": "Physical Characteristics",
      "labelDE": "Physikalische Merkmale",
      "icon": Icons.straighten,
      "iconActive": Icons.straighten_rounded,
    },
    {
      "label": "environmental",
      "labelEN": "Environmental Factors",
      "labelDE": "Umweltfaktoren",
      "icon": Icons.directions_walk,
      "iconActive": Icons.directions_run,
    },
    {
      "label": "biodiversity",
      "labelEN": "Biodiversity and Composition",
      "labelDE": "Biodiversität und Zusammensetzung",
      "icon": Icons.compost,
      "iconActive": Icons.compost_rounded,
    },
    {
      "label": "images",
      "labelEN": "Images",
      "labelDE": "Bilder",
      "icon": Icons.image_rounded,
      "iconActive": Icons.image_rounded,
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

String getMapDescription(MapDescriptor descriptor, String currentLocale) {
  String readableDescription = "";
  switch (descriptor) {
    case MapDescriptor.NULL:
      break;
    case MapDescriptor.arcanum:
      readableDescription = currentLocale == "EN" ? "Arkanum Map" : "Arkanum Karte";
      break;
    case MapDescriptor.bodenkarte:
      readableDescription = currentLocale == "EN" ? "Bodenkarte Map" : "Bodenkarte";
      break;
    case MapDescriptor.bodenkarteNutzbareFeldkapazitaet:
      readableDescription = currentLocale == "EN" ? "Bodenkarte Map" : "Bodenkarte";
      break;
    case MapDescriptor.bodenkarteHumusBilanz:
      readableDescription = currentLocale == "EN" ? "Bodenkarte Map" : "Bodenkarte";
      break;
    case MapDescriptor.geonodeLebensraumVernetzung:
      readableDescription = currentLocale == "EN" ? "Habitat Connectivity Map" : "Lebensraum Vernetzungs Karte";
      break;
    case MapDescriptor.ecosystem:
      readableDescription = currentLocale == "EN" ? "Ecosystem Map" : "Ökosystem Karte";
      break;
    case MapDescriptor.geoland:
      readableDescription = currentLocale == "EN" ? "Geoland Map" : "Geoland Karte";
      break;
    case MapDescriptor.noeNaturschutz:
      readableDescription = currentLocale == "EN" ? "NÖ Nature Conversation Map" : "NÖ Naturschutz Karte";
      break;
    case MapDescriptor.eeaProtectedAreas:
      readableDescription = currentLocale == "EN" ? "EEA Protected Areas Map" : "EEA Schutzgebiete Karte";
      break;
  }
  return readableDescription;
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

Map<String, String> getEnglishRadarPlotTranslations() {
  return {
    'Bereitstellend': 'Provisioning',
    'Bestäubung': 'Pollination',
    'Bodenschutz': 'Soil protection',
    'Erholung & Tourismus': 'Recreation & Tourism',
    'Ertragssteigerung': 'Yield increase',
    'Fortpflanzungs- & Ruhestätte': 'Breeding & resting place',
    'Habitat': 'Habitat',
    'Klimaschutz': 'Climate protection',
    'Korridor': 'Corridor',
    'Kulturell': 'Cultural',
    'Kulturerbe': 'Cultural heritage',
    'Nahrungsquelle': 'Food source',
    'Nähr- & Schadstoffkreisläufe': 'Nutrient & pollutant cycles',
    'Regulierend': 'Regulating',
    'Rohstoffe': 'Raw materials',
    'Schädlings- & Krankheitskontrolle': 'Pest & disease control',
    'Wasserschutz': 'Water protection',
  };
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
      // 'descriptionEN': 'Enter the name of the hedge',
      // 'descriptionDE': 'Geben Sie den Namen der Hecke ein',
      'section': 'general',
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': 'text',
      'label': 'hecken_ort',
      "labelEN": "Place",
      "labelDE": "Ort",
      // 'descriptionEN': 'Enter the location',
      // 'descriptionDE': 'Geben Sie den Ort ein',
      'section': 'general',
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': 'text',
      'label': 'gutachter',
      "labelEN": "Reviewer",
      "labelDE": "Gutachter:in",
      'descriptionEN': 'Enter the name of the reviewer',
      'descriptionDE': 'Geben Sie den Namen des Gutachters ein',
      'descriptionAction': MapDescriptor.arcanum,
      'section': 'general',
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': 'text',
      'label': 'anmerkungen_kommentare',
      "labelEN": "Notes",
      "labelDE": "Anmerkungen",
      'descriptionEN': 'Enter any additional notes or comments',
      'descriptionDE': 'Geben Sie zusätzliche Anmerkungen oder Kommentare ein',
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
      'descriptionEN': 'Enter the length of the hedge in meters',
      'descriptionDE': 'Geben Sie die Länge der Hecke in Metern ein',
      'section': 'physical',
      "subSectionDE": "Abmessungen",
      "subSectionEN": "Dimensions",
      'borderColor': MyColors.blue,
      'controller': TextEditingController(),
    },
    {
      'type': 'dropdown',
      'label': 'himmelsrichtung',
      "labelEN": "Compass direction",
      "labelDE": "Ausrichtung Himmelsrichtung",
      "descriptionEN": "Select the compass direction",
      "descriptionDE": "Wählen Sie die Ausrichtung nach Himmelsrichtung aus",
      'section': 'physical',
      "subSectionDE": "Ausrichtung",
      "subSectionEN": "Orientation",
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
      "descriptionEN": "Select the protected area status",
      "descriptionDE": "Wählen Sie den Schutzgebietsstatus aus",
      'section': 'environmental',
      "subSectionEN": "Conservation",
      "subSectionDE": "Schutzgebiet",
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
      'descriptionEN': "Select if there is a natural monument in or near the hedge",
      'descriptionDE': "Wählen Sie aus, ob es sich bei der Hecke um ein Naturdenkmal handelt oder nicht",
      'section': 'environmental',
      "subSectionEN": "Conservation",
      "subSectionDE": "Schutzgebiet",
      'borderColor': MyColors.blue,
      'values': ['', 'naturdenkmal_in_nahe_hecke', 'kein_naturdenkmal_in_nahe_hecke'],
      'valuesEN': ['', 'Natural monument in/near the hedge', 'No natural monument in/near the hedge'],
      'valuesDE': ['', 'Naturdenkmal in/nahe der Hecke', 'Kein Naturdenkmal in/nahe der Hecke'],
      'valueMap': {
        "Kulturerbe": [null, 1, 0]
      },
    },
    {
      'type': 'dropdown',
      'label': 'hecken_dichte',
      "labelEN": "Hedge density",
      "labelDE": "Heckendichte",
      'descriptionEN': "Select the density range of the hedge",
      'descriptionDE': "Wählen Sie den Dichtebereich der Hecke aus",
      'section': 'physical',
      "subSectionDE": "Dichte und Kapazität",
      "subSectionEN": "Density and Capacity",
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
      'descriptionEN': "Select the climatic water balance color",
      'descriptionDE': "Wählen Sie die Farbe der klimatischen Wasserbilanz aus",
      'section': 'environmental',
      "subSectionEN": "Climate and Water",
      "subSectionDE": "Klima und Wasser",
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
      'descriptionEN': "Select the population density range",
      'descriptionDE': "Wählen Sie den Bereich der Bevölkerungsdichte aus",
      'section': 'environmental',
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
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
      'descriptionEN': "Select if the location is in a wildlife corridor",
      'descriptionDE': "Wählen Sie aus, ob sich der Standort in einem Wildtierkorridor befindet",
      'section': 'environmental',
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
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
      'descriptionEN': "Select if it is a traditional hedge region or not",
      'descriptionDE': "Wählen Sie aus, ob es sich um eine traditionelle Heckenregion handelt oder nicht",
      'section': 'environmental',
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
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
      'descriptionEN': "Select if it is identifiable in the French cadastre or not",
      'descriptionDE': "Wählen Sie aus, ob es im französischen Kataster erkennbar ist oder nicht",
      'section': 'environmental',
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
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
      "descriptionEN": "Enter the usable field capacity",
      "descriptionDE": "Geben Sie die nutzbare Feldkapazität ein",
      'section': 'physical',
      "subSectionDE": "Dichte und Kapazität",
      "subSectionEN": "Density and Capacity",
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
      "descriptionEN": "Select the humus balance",
      "descriptionDE": "Wählen Sie die Humusbilanz aus",
      'section': 'environmental',
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
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
      "descriptionEN": "Select the position to the slope",
      "descriptionDE": "Wählen Sie die Position zum Hang aus",
      'section': 'physical',
      "subSectionDE": "Position und Eigenschaften",
      "subSectionEN": "Position and Characteristics",
      'borderColor': MyColors.green,
      'values': ['', 'in_hangrichtung', 'oberhang', 'diagonal_zur_falllinie', 'unterhang_hangfuss', 'im_hang_quer', 'keine_hangneigung'],
      'valuesEN': ['', 'in direction of the slope', 'upslope', 'diagonal to fall line', 'downslope / toe of slope', 'downslope, across', '(no slope)'],
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
      "descriptionEN": "Select the slope gradient",
      "descriptionDE": "Wählen Sie die Hangneigung aus",
      'section': 'physical',
      "subSectionDE": "Position und Eigenschaften",
      "subSectionEN": "Position and Characteristics",
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
      "descriptionEN": "Select the network",
      "descriptionDE": "Wählen Sie das Netzwerk aus",
      'section': 'environmental',
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
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
      "descriptionEN": "Select the access",
      "descriptionDE": "Wählen Sie die Erschließung aus",
      'section': 'environmental',
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
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
      "descriptionEN": "Select the horizontal layering",
      "descriptionDE": "Wählen Sie die horizontale Schichtung aus",
      'section': 'biodiversity',
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
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
      'descriptionEN': 'Enter the vertical layering',
      'descriptionDE': 'Geben Sie die vertikale Schichtung ein',
      'section': 'biodiversity',
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
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
      'descriptionEN': 'Enter the structural diversity',
      'descriptionDE': 'Geben Sie die Strukturvielfalt ein',
      'section': 'biodiversity',
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
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
      'descriptionEN': 'Enter the gaps',
      'descriptionDE': 'Geben Sie die Lücken ein',
      'section': 'biodiversity',
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
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
      'descriptionEN': 'Enter the deadwood',
      'descriptionDE': 'Geben Sie das Totholz ein',
      'section': 'biodiversity',
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
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
      'descriptionEN': 'Enter the age composition',
      'descriptionDE': 'Geben Sie die Alterszusammensetzung ein',
      'section': 'biodiversity',
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
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
      'descriptionEN': 'Enter the hem type',
      'descriptionDE': 'Geben Sie die Saumart ein',
      'section': 'biodiversity',
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
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
      'descriptionEN': 'Enter the hem width',
      'descriptionDE': 'Geben Sie die Saumbreite ein',
      'section': 'biodiversity',
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
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
      "descriptionEN": "Enter the height of the hedge",
      "descriptionDE": "Geben Sie die Höhe der Hecke ein",
      'section': 'physical',
      "subSectionDE": "Abmessungen",
      "subSectionEN": "Dimensions",
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
      "descriptionEN": "Enter the width of the hedge",
      "descriptionDE": "Geben Sie die Breite der Hecke ein",
      'section': 'physical',
      "subSectionDE": "Abmessungen",
      "subSectionEN": "Dimensions",
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
      "descriptionEN": "Select the proportion of trees",
      "descriptionDE": "Wählen Sie den Baumanteil aus",
      'section': 'biodiversity',
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
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
      "descriptionEN": "Select the number of wood species within 30m",
      "descriptionDE": "Wählen Sie die Anzahl der Gehölzarten innerhalb von 30m aus",
      'section': 'biodiversity',
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
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
      "descriptionEN": "Select the dominance level",
      "descriptionDE": "Wählen Sie das Dominanzniveau aus",
      'section': 'biodiversity',
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
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
      "descriptionEN": "Select the percentage of neophytes",
      "descriptionDE": "Wählen Sie den Prozentsatz der Neophyten aus",
      'section': 'biodiversity',
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
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

List<String> getSectionsFromLocale(String locale) {
  return getSections()
      .map((section) => section["label$locale"].toString())
      .toList();
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
      'descriptionEN': 'Select the type of neighboring areas',
      'descriptionDE': 'Wählen Sie die Art der Nachbarflächen aus',
      'borderColor': MyColors.coral,
      'values': const ['', 'siedlung_strasse', 'gruenland_ext', 'gruenland_int', 'acker', 'unbefestigter_weg', 'brache'],
      'valuesEN': const ['', 'settlement/road', 'grassland ext', 'grassland int', 'arable land', 'unpaved road', 'fallow land'],
      'valuesDE': const ['', 'Siedlung/Straße', 'Grünland ext.', 'Grünland int.', 'Acker', 'unbefestigter Weg', 'Brache'],
      'section': 'general',
      'valueMap': {
        'Ertragssteigerung': [null, 0, 1, 1, 1, 0, 0],
        'Nähr- & Schadstoffkreisläufe': [null, 4, 1, 2, 5, 1, 1],
        'Bestäubung': [null, -1, 1, 0, 0, -1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, -2, 2, 1, -1, -1, 2],
      },
    },
    {
      'headerText': 'nutzungs_spuren',
      "headerTextEN": "Traces of use",
      "headerTextDE": "Nutzungsspuren",
      'descriptionEN': 'Indicate any visible traces of use',
      'descriptionDE': 'Geben Sie sichtbare Nutzungsspuren an',
      'borderColor': MyColors.coral,
      'values': const ['', 'keine_ersichtlich', 'bienen_stoecke', 'obst', 'gelagerte_holzstapel', 'andere_nutzung', 'brache'],
      'valuesEN': const ['', 'none apparent', 'bee hives', 'fruit', 'stored wood piles', 'other use', 'fallow'],
      'valuesDE': const ['', 'keine ersichtlich', 'Bienenstöcke', 'Obst', 'gelagerte Holzstapel', 'andere Nutzung', 'Brache'],
      'section': 'physical',
      "subSectionEN": "Position and Characteristics",
      "subSectionDE": "Position und Eigenschaften",
      'valueMap': {
        'Rohstoffe': [null, 0, 1, 1, 1, 1],
        'Bestäubung': [null, 0, 1, 0, 0, 0],
      },
      'maxDropdownCount': 4,
    },
    {
      'headerText': 'zusatz_strukturen',
      "headerTextEN": "Additional structures",
      "headerTextDE": "Zusatzstrukturen",
      'descriptionEN': 'Choose any additional structures present',
      'descriptionDE': 'Wählen Sie zusätzliche Strukturen aus',
      'borderColor': MyColors.coral,
      'values': const ['', 'jagd_zb_hochstand', 'erholung_zb_bank', 'bildung_zb_schautafel', 'kulturdenkmal', 'nichts'],
      'valuesEN': const ['', 'hunting, e.g. high stand', 'recreation, e.g. bench', 'education, e.g. display board', 'cultural monument', 'nothing'],
      'valuesDE': const ['', 'Jagd, z.B. Hochstand', 'Erholung, z.B. Bank', 'Bildung, z.B. Schautafel', 'Kulturdenkmal', 'nichts'],
      'section': 'physical',
      "subSectionEN": "Position and Characteristics",
      "subSectionDE": "Position und Eigenschaften",
      'valueMap': {
        'Rohstoffe': [null, 1, 0, 0, 0, 0],
        'Erholung & Tourismus': [null, 0.5, 1, 1, 0.5, 0],
        'Kulturerbe': [null, 0, 0, 0, 1, 0],
      },
      'maxDropdownCount': 4,
    },
    {
      'headerText': 'management',
      "headerTextEN": "Management",
      "headerTextDE": "Management",
      'descriptionEN': 'Select the type of land management activities',
      'descriptionDE': 'Wählen Sie die Art der Bewirtschaftung aus',
      'borderColor': MyColors.coral,
      'values': const ['', 'nichts_sichtbar', 'baum_strauch_nachgepflanzt', 'seitenschnitt_sichtbar', 'auf_stock_gesetzt', 'einzelbaum_strauch_rueckschnitte', 'einzelstamm_entnahme'],
      'valuesEN': const ['', 'nothing visible', 'tree/shrub replanted', 'side cut visible', 'stocked', 'single tree/shrub pruning', 'single trunk removal'],
      'valuesDE': const ['', 'nichts sichtbar', 'Baum/Strauch nachgepflanzt', 'Seitenschnitt sichtbar', 'auf Stock gesetzt', 'Einzelbaum/-strauch Rückschnitte', 'Einzelstamm Entnahme'],
      'section': 'environmental',
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
      'valueMap': {
        'Rohstoffe': [null, 0, 0, -1, 2, 0, 1],
        'Bestäubung': [null, 1, 0, -1, 1, 1, 0],
      },
      'maxDropdownCount': 5,
    },
    {
      'headerText': 'sonder_form',
      "headerTextEN": "Special form",
      "headerTextDE": "Sonderform",
      'descriptionEN': 'Specify if there are any special forms of vegetation',
      'descriptionDE': 'Geben Sie an, ob es besondere Vegetationsformen gibt',
      'borderColor': MyColors.coral,
      'values': const ['', 'keine_sonderform', 'lesesteinhecke', 'hecke_auf_hochrain', 'boeschungs_hecke', 'grabenhecke'],
      'valuesEN': const ['', 'no special shape', 'reading stone hedge', 'hedge on high ground', 'slope hedge', 'ditch hedge'],
      'valuesDE': const ['', 'keine Sonderform', 'Lesesteinhecke', 'Hecke auf Hochrain', 'Böschungshecke', 'Grabenhecke'],
      'section': 'physical',
      "subSectionEN": "Position and Characteristics",
      "subSectionDE": "Position und Eigenschaften",
      'valueMap': {
        'Nähr- & Schadstoffkreisläufe': [null, 0, 1, 1, 0, 0],
        'Bestäubung': [null, 0, 1, 1, 1, 1],
        'Schädlings- & Krankheitskontrolle': [null, 0, 2, 2, 1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 0, 1, 1, 1, 1],
        'Kulturerbe': [null, 0, 1, 1, 1, 1],
      },
      'maxDropdownCount': 4,
    },
  ];
}

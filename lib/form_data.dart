import 'package:flutter/material.dart';
import 'colors.dart';

List<Map<String, dynamic>> getSections() {
  return [
    {
      "label": FormSection.general,
      "labelEN": "General",
      "labelDE": "Allgemeines",
      "icon": Icons.location_history_sharp,
      "iconActive": Icons.location_history_sharp,
    },
    {
      "label": FormSection.location,
      "labelEN": "Location",
      "labelDE": "Lage",
      "icon": Icons.location_on,
      "iconActive": Icons.location_on,
    },
    {
      "label": FormSection.usage,
      "labelEN": "Usage",
      "labelDE": "Nutzung",
      "icon": Icons.manage_accounts,
      "iconActive": Icons.manage_accounts,
    },
    {
      "label": FormSection.structure,
      "labelEN": "Structure",
      "labelDE": "Struktur",
      "icon": Icons.straighten,
      "iconActive": Icons.straighten,
    },
    {
      "label": FormSection.plants,
      "labelEN": "Plants",
      "labelDE": "Pflanzen",
      "icon": Icons.nature_sharp,
      "iconActive": Icons.nature_sharp,
    },
    {
      "label": FormSection.map_location,
      "labelEN": "Location",
      "labelDE": "Lage",
      "icon": Icons.map,
      "iconActive": Icons.map,
    },
    {
      "label": FormSection.map_soil,
      "labelEN": "Soil",
      "labelDE": "Boden",
      "icon": Icons.vrpano_outlined,
      "iconActive": Icons.vrpano_outlined,
    },
    {
      "label": FormSection.images,
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
      readableDescription = currentLocale == "EN"
          ? "Franziscean Cadastre"
          : "Franziszeischer Kataster";
      break;
    case MapDescriptor.bodenkarte:
      readableDescription = currentLocale == "EN"
          ? "Bodenkarte"
          : "Bodenkarte";
      break;
    case MapDescriptor.bodenkarteNutzbareFeldkapazitaet:
      readableDescription = currentLocale == "EN"
          ? "Field Capacity"
          : "Feldkapazität";
      break;
    case MapDescriptor.bodenkarteHumusBilanz:
      readableDescription = currentLocale == "EN"
          ? "Humus Balance"
          : "Humusbilanz";
      break;
    case MapDescriptor.geonodeLebensraumVernetzung:
      readableDescription = currentLocale == "EN"
          ? "Wildlife Corridor"
          : "Wildtierkorridor";
      break;
    case MapDescriptor.ecosystem:
      readableDescription = currentLocale == "EN"
          ? "Population Density"
          : "Bevölkerungsdichte";
      break;
    case MapDescriptor.geoland:
      readableDescription = currentLocale == "EN"
          ? "Measuring"
          : "Messen & Zeichnen";
      break;
    case MapDescriptor.noeNaturschutz:
      readableDescription = currentLocale == "EN"
          ? "Natural Monument"
          : "Naturdenkmal";
      break;
    case MapDescriptor.eeaProtectedAreas:
      readableDescription = currentLocale == "EN"
          ? "EEA Protected Areas"
          : "EEA Schutzgebiete";
      break;
  }
  return readableDescription;
}

String getMapDescriptionForMenu(MapDescriptor descriptor, String currentLocale) {
  String description = getMapDescription(descriptor, currentLocale);
  return description;
  // if (currentLocale == "EN") {
  //   return "View $description";
  // } else {
  //   return "$description Öffnen";
  // }
}

String getImageDescriptorPath(ImageDescriptor descriptor) {
  switch (descriptor) {
    case ImageDescriptor.kwb_noe4:
      return "data/kwb_noe4.png";
    case ImageDescriptor.kwb_noe_regionen:
      return "data/kwb_noe_Regionen.png";
    case ImageDescriptor.tabelle_altersklassen:
      return "data/Tabelle_Altersklassen.jpg";
    case ImageDescriptor.tabelle_altersklassen_engl:
      return "data/Tabelle_Altersklassen_engl.jpg";
  }
}

String getImageDescriptorDescription(ImageDescriptor descriptor,
    String currentLocale) {
  switch (descriptor) {
    case ImageDescriptor.kwb_noe4:
      return currentLocale == "EN" ? "Water balance map" : "Wasserbilanz Karte";
    case ImageDescriptor.kwb_noe_regionen:
      return currentLocale == "EN" ? "Hedge region map" : "Heckenregion Karte";
    case ImageDescriptor.tabelle_altersklassen:
      return "Altersklassen";
    case ImageDescriptor.tabelle_altersklassen_engl:
      return "Age Groups";
  }
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
      'type': InputType.text,
      'label': 'hecken_name',
      "labelEN": "Hedge name/number",
      "labelDE": "Hecken Name /-nummer",
      // 'descriptionEN': 'Enter the name of the hedge',
      // 'descriptionDE': 'Geben Sie den Namen der Hecke ein',
      "action": null,
      'section': FormSection.general,
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': InputType.text,
      'label': 'hecken_ort',
      "labelEN": "Place",
      "labelDE": "Ort",
      // 'descriptionEN': 'Enter the location',
      // 'descriptionDE': 'Geben Sie den Ort ein',
      "action": null,
      'section': FormSection.general,
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': InputType.text,
      'label': 'gutachter',
      "labelEN": "Reviewer",
      "labelDE": "Gutachter:in",
      // 'descriptionEN': 'Enter the name of the reviewer',
      // 'descriptionDE': 'Geben Sie den Namen des Gutachters ein',
      "action": null,
      'section': FormSection.general,
      'borderColor': MyColors.orange,
      'controller': TextEditingController(),
    },
    {
      'type': InputType.text,
      'label': 'anmerkungen_kommentare',
      "labelEN": "Notes",
      "labelDE": "Anmerkungen",
      // 'descriptionEN': 'Enter any additional notes or comments',
      // 'descriptionDE': 'Geben Sie zusätzliche Anmerkungen oder Kommentare ein',
      "action": null,
      'section': FormSection.images,
      'borderColor': MyColors.yellow,
      'controller': TextEditingController(),
    },
    // gis fields
    {
      'type': InputType.number,
      'label': 'hecken_laenge',
      "labelEN": "Length [m]",
      "labelDE": "Länge [m]",
      "descriptionEN": """The length of the hedge is not an independent indicator, it only serves to calculate the proportion of trees. This information can be found using the link below. The length in meters can be easily determined using the tool Measure Distance ("Strecke messen") and subsequently entered in the corresponding field.""",
      "descriptionDE": """Die Länge der Hecke ist kein eigenständiger Indikator, sondern dient lediglich der Berechnung des Baumanteils. Diese Information kann beispielsweise über den Niederösterreich Atlas ermittelt werden, der unter dem Link https://atlas.noe.gv.at/webgisatlas zu finden ist. Dort kann die Länge in Metern einfach mit dem Werkzeug „Strecke messen“ ermittelt und in das entsprechende Feld eingetragen werden.""",
      "action": MapDescriptor.geoland,
      'section': FormSection.map_location,
      "subSectionEN": "Dimensions",
      "subSectionDE": "Abmessungen",
      'borderColor': MyColors.blue,
      'controller': TextEditingController(),
    },
    {
      'type': InputType.dropdown,
      'label': 'himmelsrichtung',
      "labelEN": "Compass direction",
      "labelDE": "Ausrichtung Himmelsrichtung",
      "descriptionEN": """The windbreak effect of a hedge is greatest when the wind hits the hedge at a right angle. The main wind direction in large parts of Austria is in the W - NW sector,  with highest wind speed measured from these directions. So called Vb ("five B") weather patterns or Mediterranean lows are another significant phenome-non that bring strong winds from S - SE. These patterns apply mainly to the area at the north-eastern end of the Alpine arc, i.e. Austria. For other regions it may be necessary to modify the assessment slightly. The orientation of the hedge relative to the compass direction can interpreted from satellite imagery in any mapping program.""",
      "descriptionDE": """Trifft der Wind im rechten Winkel auf die Hecke, ist ihre bremsende Wirkung am höchsten. Die Hauptwindrichtung in weiten Teilen Österreichs liegt im Sektor W – NW, und auch die höchsten Geschwindigkeiten werden aus diesen Richtungen gemessen. Sogenannte Vb („fünf B“) Wetterlagen oder Mittelmeertiefs sind eine weitere bedeutende Erscheinung, die starke Windentwicklung aus S – SO mit sich bringen. Diese Muster gelten vor allem für den Raum am nordöstlichen Ende des Alpenbogens, also Niederösterreich – für andere Regionen kann es notwendig sein, die Einschätzung leicht abzuändern. Die Ausrichtung der Hecke zur Himmelsrichtung wird in einem beliebigen Kartenprogramm auf dem Satellitenbild abgelesen.""",
      "action": MapDescriptor.geoland,
      "section": FormSection.map_location,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.blue,
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
      'type': InputType.dropdown,
      'label': 'schutzgebiet',
      "labelEN": "Protected area",
      "labelDE": "Schutzgebiet",
      "descriptionEN": """Protected areas are recorded using the map below. All protected areas are included. """,
      "descriptionDE": """Die Erfassung der Schutzgebiete erfolgt über die untenstehenden Karte. Alle Schutzgebiete werden berücksichtigt.""",
      "action": MapDescriptor.eeaProtectedAreas,
      "section": FormSection.map_location,
      "subSectionEN": "Conservation Area",
      "subSectionDE": "Schutzgebiet",
      "borderColor": MyColors.blue,
      'values': ['', 'schutzgebiet', 'kein_schutzgebiet'],
      'valuesEN': ['', 'Within protected area', 'Not within protected area'],
      'valuesDE': ['', 'in Schutzgebiet', 'nicht in Schutzgebiet'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 0],
      },
    },
    // {
    //   'type': InputType.dropdown,
    //   'label': 'naturdenkmal',
    //   "labelEN": "Natural monument",
    //   "labelDE": "Naturdenkmal",
    //   "descriptionEN": """Natural Monuments are recorded using the Lower Austrian Atlas found below. Natural monuments ("Naturdenkmäler") can be ticked here. ‘A’ is selected if either the hedge itself is a natural monument, if there is a single tree in the hedge that is a natural monument or if there is a natural monument in the immediate vicinity (visible!).""",
    //   "descriptionDE": """Die Erfassung der Naturdenkmäler erfolgt über den Niederösterreich Atlas (Link unten). Hier lässt sich "Naturdenkmäler" ankreuzen. Es wird „A“ gewählt, wenn entweder Hecke selbst Naturdenkmal ist, in der Hecke ein Einzelgehölz steht, das ein Naturdenkmal ist oder sich in unmittelbarer Nähe (sichtbar!) ein Naturdenkmal befindet.""",
    //   "action": MapDescriptor.noeNaturschutz,
    //   "section": FormSection.map_location,
    //   "subSectionEN": "Conservation Area",
    //   "subSectionDE": "Schutzgebiet",
    //   "borderColor": MyColors.blue,
    //   'values': ['', 'naturdenkmal_in_nahe_hecke', 'kein_naturdenkmal_in_nahe_hecke'],
    //   'valuesEN': ['', 'Natural monument', 'No natural monument'],
    //   'valuesDE': ['', 'Naturdenkmal', 'Kein Naturdenkmal'],
    //   'valueMap': {
    //     "Kulturerbe": [null, 1, 0]
    //   },
    // },
    {
      'type': InputType.dropdown,
      'label': 'hecken_dichte',
      "labelEN": "Hedge density",
      "labelDE": "Heckendichte",
      "descriptionEN": """Hedge density in a given landscape section is determined using the website of the Lower Austrian Atlas (link below). For this analysis, a circle, with the hedge to be assessed at its center,  with a radius of 280 m (an area of about 25 ha) is created using the drawing tool (Tools ("Werkzeuge") - Draw ("Zeichnen")). Next, the total length of all hedges present within the circle is calculated. The calculation can be performed using either the Dimensioning ("Bemaßung") or Measure distance ("Strecke messen") tools. """,
      "descriptionDE": """Der Heckendichte in einem bestimmten Landschaftsausschnitt wird über die Website des Niederösterreich Atlas (Link unten) ermittelt. Hierfür wird um die zu bewertende Hecke mit dem Zeichenwerkzeug (Werkzeuge - zeichnen) ein Kreis gezogen, der den Radius 280 m besitzt (für einen Flächeninhalt von etwa 25 ha). Innerhalb dieses Kreises wird nun die Gesamtlänge aller Hecken ermittelt. Dies ist mit dem Tool „Bemaßung“ oder „Strecke messen“ möglich. """,
      "action": MapDescriptor.geoland,
      "section": FormSection.map_location,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.blue,
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
      'type': InputType.dropdown,
      'label': 'klimatische_wasserbilanz',
      "labelEN": "Climatic water balance",
      "labelDE": "klimatische Wasserbilanz",
      "descriptionEN": """The main difference in climatic conditions within Austria lies in the water balance. It varies greatly from area to area and influenced by many factors, such as precipitation, evaporation, soil properties and topography. The climatic water balance is the most telling indicator for climate conditions, showing the difference be-tween annual precipitation and potential evaporation. The map of the climatic water balance for Lower Austria can be found below.""",
      "descriptionDE": """Der wesentliche Unterschied in den klimatischen Gegebenheiten innerhalb Österreichs liegt im Wasserhaushalt, der stark je nach Gebiet variiert und von vielen Faktoren, wie z.B. Niederschlagsmenge, Verdunstung, Bodenbeschaffenheit und Topografie abhängt. Die klimatische Wasserbilanz ist hierfür der aussagekräftigste Indikator, sie gibt die Differenz zwischen Jahresniederschlag und potenzieller Verdunstung wieder. Die Karte der klimatischen Wasserbilanz für Österreich kann unten aufgerufen werden.""",
      "action": ImageDescriptor.kwb_noe4,
      "section": FormSection.map_location,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.blue,
      'values': ['', 'violett', 'blau ', 'weissblau_hellblau ', 'hellgelb_weiss', 'rot, orange'],
      'valuesEN': ['', 'under -400 mm', '-400 to -200 mm ', '-22 to +100 mm', '+100 to +300 mm', 'over +300 mm'],
      'valuesDE': ['', 'unter -400 mm', '-400 bis -200 mm ', '-200 bis +100 mm', '+100 bis +300 mm', 'über +300 mm'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 5, 4, 3, 2, 1],
        'Ertragssteigerung': [null, 5, 4, 3, 2, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'bevoelkerungs_dichte',
      "labelEN": "Population density",
      "labelDE": "Bevölkerungsdichte",
      "descriptionEN": """Population density (inhabitants/km²) can be found on the map linked below. First, click on the square map symbol on the left edge, set the base layer to “colorful (bright)” and set the opacity to the highest level using the slider. Next, select “Cultural” (left) in the line above the map image. In this menu, the option Nature-based recreation appears, click on it and select Demand. Left above the legend, the blue slider can be used to adjust the opacity. Orientation can be set in the map labels menu. A loca-tion/coordinate search is not possible. A record of demand is classified by the superimposed color laid over location of the hedge which corresponds to the key in the legend. If the hedge is located exactly on the border between two areas with different population densities, the higher value is to be selected.""",
      "descriptionDE": """Die Erfassung der Bevölkerungsdichte (Einwohner:innen/km²) erfolgt über den untenstehenden Link. Zunächst wird mittels des quadratischen Kartensymbols am linken Rand als Basis Layer colorful (bright) ausgewählt und die Opazität mithilfe des Reglers ganz hoch stellen. Im nächsten Schritt in der Zeile oberhalb des Kartenbildes die Sparte Cultural (links) auswählen. Darunter erscheint die Auswahlmöglichkeit Nature-based recreation. Anklicken und im aufgehenden Fenster die Option Demand wählen. Links über der Legende kann mithilfe des blauen Reglers die Opazität verändert werden. Die Orientierung erfolgt über die Kartenbeschriftung, Orts-/ Koordinatensuche ist nicht möglich. Erfassung der Nachfrage anhand der eingeblendeten Farbe am Standort der Hecke und Einordnung entsprechend der Legende. Sofern sich die Hecke genau an der Grenze zwischen zwei Gebieten mit unterschiedlich hoher Bevölkerungsdichte befindet, ist der höhere Wert zu wählen.""",
      "action": MapDescriptor.ecosystem,
      "section": FormSection.map_location,
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
      "borderColor": MyColors.blue,
      'values': ['', '0_to_15', '16_to_30', '31_to_75', '76_to_200', 'gt_200'],
      'valuesEN': ['', '0-15', '16-30', '31-75', '76-200', '>200'],
      'valuesDE': ['', '0-15', '16-30', '31-75', '76-200', '>200'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'in_wildtierkorridor',
      "labelEN": "In wildlife corridor",
      "labelDE": "in Wildtierkorridor",
      "descriptionEN": """The implementation of a green space network in Austria varies at the provincial level. While in some federal provinces, such as Styria, ‘green corridors’ are secured by ordinance, there are no such legal safeguards in other provinces. Since 2018, there has been a proposal for an Austria-wide supra-regional habitat network. The corridors are available as line features. For indicator assessment in the Heck.in system, a buffer area is created around the corridor sections. If the hedge is located within the buffer, it is assumed that the hedge is situated in a wildlife corridor. The data can be accessed via the link below. On the left, under Layers, the "LRVA Bewertung" [Habitat Connectivity Austria Assessment] can be activated by selecting the eye on its tab.""",
      "descriptionDE": """Die Umsetzung der Grünraumvernetzung ist in Österreich auf Länderebene unterschiedlich weit entwickelt. Während in manchen Bundesländern wie der Steiermark Grünkorridore per Verordnung abgesichert sind, gibt es solcherlei rechtliche Absicherung in anderen Bundesländern nicht (BMK 2020). Seit 2018 gibt es jedoch einen österreichweiten Vorschlag für überregionale Lebensraumvernetzung, der über die Web-Applikation der Lebensraumvernetzung Österreich (Link unten). Darin liegen die Korridore in Linienform vor. Für die Bewertung der Korridorabschnitte wurde jedoch mit einem Pufferbereich gerechnet, die für die Indikatoraufnahme herangezogen wird. Liegt die Hecke innerhalb des Puffers, wird davon ausgegangen, dass sich die Hecke in einem Wildtierkorridor befindet.  Links unter Ebenen ist die Bewertung LRVA durch das Auge zu aktivieren.""",
      "action": MapDescriptor.geonodeLebensraumVernetzung,
      "section": FormSection.map_location,
      "subSectionEN": "Conservation Area",
      "subSectionDE": "Schutzgebiet",
      "borderColor": MyColors.blue,
      'values': ['', 'ja', 'nein'],
      'valuesEN': ['', 'within wildlife corridor', 'not within wildlife corridor'],
      'valuesDE': ['', 'in Wildtierkorridor', 'nicht in Wildtierkorridor'],
      'valueMap': {
        "Korridor": [null, 1, 0],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'traditionelle_heckenregion',
      "labelEN": "Traditional hedgerow region",
      "labelDE": "traditionelle Heckenregion",
      "descriptionEN": """Some regions in Austria have a long hedgerow tradition. In other regions hedgerows are not common. The evaluation of ecosystem services realizes a map of the hedgerow regions in  Austria. Adaptations are necessary for other federal states. The map of the traditional hedgerow regions for Lower Austria can be found in below.""",
      "descriptionDE": """Österreich verzeichnet einige Regionen, die eine lange Heckentradition haben. In anderen Regionen ist dies nicht der Fall. Anhand der Kulturlandschaftsgliederung Österreichs (Wrbka et al. 2002) wurden traditionelle Heckenregionen herausgearbeitet. In Bewertung der Ökosystemleistung findet sich eine Karte der Heckenregionen in Österreich. """,
      "action": ImageDescriptor.kwb_noe_regionen,
      "section": FormSection.map_location,
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
      "borderColor": MyColors.blue,
      'values': ['', 'heckenregion', 'keine_heckenregion'],
      'valuesEN': ['', 'within hedge region', 'not within hedge region'],
      'valuesDE': ['', 'in Heckenregion', 'nicht in Heckenregion'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'franziszeischer_kataster',
      "labelEN": "Franziscean cadaster",
      "labelDE": "Franziszeischer Kataster",
      "descriptionEN": """The Franziscean cadastre is a historical map series that was created between 1810 and 1870 as a basis for calculating land tax. It still forms the basis for Austria's land registers today. The map sheets for the Vienna and Lower Austrian regions were created between 1817 and 1824. When comparing the old maps with cur-rent images, it becomes clear that the structure of the landscape and its structural elements still show strong parallels in many cases, even after 200 years. The survey is carried out by overlaying the satellite map (base map) with the Franziscean cadastre found below. By regulating the opacity of the cadastre, current aerial photographs can be well compared.""",
      "descriptionDE": """Der Franziszeische Kataster ist ein historisches Kartenwerk, das zwischen 1810 und 1870 als Grundlage für die Berechnung der Grundsteuer erstellt wurde und bis heute die Basis für die Grundbücher Österreichs bildet.  Beim Vergleich der Altkarten mit aktuellen Aufnahmen wird deutlich, dass die Gliederung der Landschaft und ihrer Strukturelemente in vielen Fällen auch nach 200 Jahren noch starke Parallelen aufweist. Die Erfassung erfolgt durch das Überlagern der Satellitenkarte (Basiskarte) mit dem Franziszeischen Kataster auf untenstehendem Link. Durch Regeln der Opazität des Katasters kann die aktuelle Luftbildaufnahme gut verglichen werden.""",
      "action": MapDescriptor.arcanum,
      "section": FormSection.map_location,
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
      "borderColor": MyColors.blue,
      'values': ['', 'im_kataster_erkennbar', 'nicht_im_kataster_erkennbar'],
      'valuesEN': ['', 'visible in cadastre', 'not visible in cadastre'],
      'valuesDE': ['', 'im Kataster erkennbar', 'nicht im Kataster erkennbar'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'nutzbare_feldkapazitaet',
      "labelEN": "Usable field capacity",
      "labelDE": "nutzbare Feldkapazität",
      "descriptionEN": """The usable field capacity contains information about the texture of the soil, the depth, and the humus content. It directly influences water storage capacity and correlates closely with the potential nitrate retention capacity. In Austria, these soil properties are mapped for agricultural land. The thematic map can be accessed below. If the hedge split over two areas, the larger area should always be selected. In the case of 50/50, a middle value should be taken (a and c become b). In the case where the two values are a and b, the higher value is selected, in this case b.""",
      "descriptionDE": """Die nutzbare Feldkapazität beinhaltet Information über die Textur des Bodens, die Gründigkeit und den Humusgehalt, steht für die Wasserspeicherfähigkeit und korreliert eng mit der potenziellen Nitratrückhaltekapa-zität. In Österreich sind diese Bodeneigenschaften der landwirtschaftlich genutzten Fläche kartiert. Die Themenkarte ist erreichbar über untenstehenden Link. Liegt die Hecke auf zwei verschiedenen Flächen, ist grundsätzlich die größere Fläche zu wählen. Bei 50/50 wird das Ergebnis gemittelt (a und c wird zu b) – bei a und b wird der höhere Wert gewählt – in diesem Fall b.""",
      "action": MapDescriptor.bodenkarteNutzbareFeldkapazitaet,
      "section": FormSection.map_soil,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.blue,
      'values': ['', 'lt_60mm', '60_to_140mm', '140_to-220mm', '220_to_300mm'],
      'valuesEN': ['', 'very low (<60mm)', 'low (60-140mm)', 'medium (140-220mm)', 'high (220-300mm)'],
      'valuesDE': ['', 'sehr gering (<60mm)', 'gering (60-140mm)', 'mittel (140-220mm)', 'hoch (220-300mm)'],
      'valueMap': {
        'Wasserschutz': [null, 5, 4, 2, 1],
        'Nähr- & Schadstoffkreisläufe': [null, 5, 4, 2, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'humusbilanz',
      "labelEN": "Humus balance",
      "labelDE": "Humusbilanz",
      "descriptionEN": """For the soil types of the Austrian Soil Map, the potential for humus accumulation and decomposition was calculated using the site-adapted humus balance according to Kolbe. As a result, a site group is assigned:\n-	Site group 1: Chernozem, clay soils >700 mm precipitation/year, sandy soils C/N-ratio >12;\n-	Site group 2: Sand, loamy sand and loamy sand under 8,5 °C temp., clay loam, clay soils; \n-	Site group 3: Sand, loamy sand and loamy sand above 8,5 °C temp.;\n-	Site group 4: Heavy sandy loam and sandy loam under 8,5 °C temp.-;	Site group 5: Heavy sandy loam and sandy loam, above 8,5 °C temp.;\n-	Site group 6: Loamy soils (KOLBE 2007).""",
      "descriptionDE": """Für die Bodenformen der österreichischen Bodenkarte wurde das Potenzial für Humusauf- und -abbau mittels der standortangepassten Humusbilanzierung nach Kolbe berechnet. Als Ergebnis wird dabei eine Standortgruppe zugewiesen:\n-	Standortgruppe 1: Schwarzerden, Tonböden >700 mm Niederschlag/Jahr, Sandböden mit C/N-Verhältnissen >12;\n-	Standortgruppe 2: Sand, anlehmiger Sand und lehmiger Sand unter 8,5 °C Temp., toniger Lehm, Tonbö-den;\n-	Standortgruppe 3: Sand, anlehmiger Sand und lehmiger Sand über 8,5 °C Temp.;\n-	Standortgruppe 4: stark sandiger Lehm und sandiger Lehm unter 8,5 °C Temp.;\n-	Standortgruppe 5: stark sandiger Lehm und sandiger Lehm, über 8,5 °C Temp.;\n-	Standortgruppe 6: Lehmböden (KOLBE 2007).\nDie Themenkarte ist erreichbar über untenstehenden Link. Liegt die Hecke auf zwei verschiedenen Flächen, ist grundsätzlich die größere Fläche zu wählen. Bei 50/50 wird das Ergebnis gemittelt (a und c wird zu b) – bei a und b wird der höhere Wert gewählt – in diesem Fall b.""",
      "action": MapDescriptor.bodenkarteHumusBilanz,
      "section": FormSection.map_soil,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.blue,
      'values': ['', 'standortgruppe_1_2', 'standortgruppe_3_4', 'standortgruppe_5_6'],
      'valuesEN': ['', 'site group 1 & 2', 'site group 3 & 4', 'site group 5 & 6'],
      'valuesDE': ['', 'Standortgruppe 1 & 2', 'Standortgruppe 3 & 4', 'Standortgruppe 5 & 6'],
      'valueMap': {
        "Klimaschutz": [null, 1, 3, 5],
      },
    },
    // gelände fields
    {
      'type': InputType.dropdown,
      'label': 'hang_position',
      "labelEN": "Position on slope",
      "labelDE": "Position zum Hang",
      "descriptionEN": """The soil map can be accessed below. If the hedge is located on two different site groups, the site group where the majority of the hedge lays is selected. In case of 50/50 the result is averaged (a and c becomes b) - in case of a and b the higher value is selected - in this case b.\nThe slope of the land influences many processes and characteristics of the natural environment and agricul-tural management. The prosperity hedgerows and their surrounding land are also subject to this pattern of effects as well. In addition to the slope gradient (an independent indicator), the position of the hedge on the slope is significant.""",
      "descriptionDE": """Mit der Neigung des Geländes ändern sich viele Prozesse und Charakteristiken des Naturraums und auch der landwirtschaftlichen Bewirtschaftung. Hecken sind diesem Wirkungsgefüge ebenfalls unterworfen, was Auswirkungen auf ihr eigenes Gedeihen und die Flächen um sie herum hat. Neben der Neigung des Hangs (eigenständiger Indikator) spielt die Position der Hecke im Hang eine Rolle.""",
      "action": null,
      "section": FormSection.location,
      "subSectionEN": "Slope",
      "subSectionDE": "Hang",
      "borderColor": MyColors.coral,
      'values': ['', 'in_hangrichtung', 'oberhang', 'diagonal_zur_falllinie', 'unterhang_hangfuss', 'im_hang_quer', 'keine_hangneigung'],
      'valuesEN': ['', 'in slope direction', 'on hilltop', 'diagonal to slope direction', 'in valley', 'across to slope direction', '(no slope)'],
      'valuesDE': ['', 'in Hangrichtung', 'Oberhang', 'diagonal zur Falllinie', 'Unterhang / Hangfuß', 'im Hang, quer', '(keine Hangneigung)'],
      'valueMap': {
        'Wasserschutz': [null, 1, 1, 3, 4, 5, 1],
        'Bodenschutz': [null, 1, 1, 3, 4, 5, 1],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 1, 3, 4, 5, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'hang_neigung',
      "labelEN": "Slope gradient",
      "labelDE": "Hangneigung",
      "descriptionEN": """In combination with the “position on slope” indicator, the slope gradient strengthens or weakens the same effects. It is recorded by estimation or measuring on site. A computer map can be used as a guide though the classification is not the same.""",
      "descriptionDE": """In Kombination mit dem Indikator "Position zum Hang" verstärkt oder vermindert die Neigung des Hangs dieselben Wirkungen. Erfasst wird sie durch Schätzen oder Messen vor Ort. Die Kartendarstellung am Computer kann als Anhalt herangezogen werden, die Klasseneinteilung ist jedoch nicht dieselbe.""",
      "action": null,
      "section": FormSection.location,
      "subSectionEN": "Slope",
      "subSectionDE": "Hang",
      "borderColor": MyColors.coral,
      'values': ['', 'annaehernd_eben', 'neigung_merkbar', 'deutlich_steigend', 'durchschn_bergstrasse', 'steilste_abschnitte_v_bergstraßen'],
      'valuesEN': ['', 'approximately level (0-3%)', 'slope noticeable (3-6%)', 'clearly rising (6-10 %)', 'average mountain road (10-15 %)', 'steepest sections of mountain roads (>15 %)'],
      'valuesDE': ['', 'annähernd eben (0-3 %)', 'Neigung merkbar (3-6 %)', 'deutlich steigend (6-10 %)', 'durchschn. Bergstraße (10-15 %)', 'steilste Abschnitte v. Bergstraßen (>15 %)'],
      'valueMap': {
        'Wasserschutz': [null, 1, 2, 3, 4, 5],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
        'Nähr- & Schadstoffkreisläufe': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'netzwerk',
      "labelEN": "Network",
      "labelDE": "Netzwerk",
      "descriptionEN": """Hedges fulfill their ecosystem services better when they are not isolated, but part of an interconnected system. The number of connections to other hedges or forests is counted (0/1/>1). This can be done on the computer or in the field. If the hedge is part of a linear mound network, this must also be indicated. """,
      "descriptionDE": """Hecken erfüllen ihre Ökosystemleistungen besser, wenn sie nicht isoliert stehen, sondern Teil eines Ver-bundsystems sind. Es wird die Anzahl der Verbindungen zu anderen Hecken oder Wald gezählt (0/1/>1). Dies ist sowohl am Computer als auch vor Ort im Feld möglich. Ist die Hecke Teil eines Rainnetzwerks, ist dies ebenfalls anzugeben. Mehrfachnennungen sind möglich.""",
      "action": null,
      "section": FormSection.location,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.coral,
      'values': ['', 'keine_verbindungen_natuerlichen_lr', '1_verbindung', 'gt_1_verbindung', 'teil_regennetzwerk'],
      'valuesEN': ['', 'no connection to other hedge/forest', '1 connection', '>1 connection', 'part of linear mound network'],
      'valuesDE': ['', 'keine Verbindungen zu (semi‑) natürlichen LR', '1 Verbindung', '>1 Verbindung', 'Teil von Rainnetzwerk'],
      'valueMap': {
        'Bestäubung': [null, 1, 2, 5, 3],
        'Korridor': [null, 1, 2, 5, 3],
        'Kulturerbe': [null, 1, 3, 5, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'erschliessung',
      "labelEN": "Accessibility",
      "labelDE": "Erschließung",
      "descriptionEN": """Apart from the general accessibility, accessible pathways in or along the hedge are necessary. These can be agricultural structures such as farm, field or hollow paths, as well as paths for hiking, cycling or pilgrimage. Unofficial access possibilities such as footpaths are also considered. Paths with prohibited access (marked on site) are equated as missing/no paths. If the hedge can be seen from the path, it should be classified as visually connected.""",
      "descriptionDE": """Voraussetzung für die Nutzung von Hecken zur Naherholung stellen Erschließungsstrukturen dar. Abgesehen von der allgemeinen Erreichbarkeit sind dafür begeh-/ befahrbare Weganlagen in oder entlang der Hecke notwendig. Dabei kann es sich sowohl um landwirtschaftliche Strukturen wie Wirtschafts-, Feld- oder Hohlwege handeln, als auch um Wander-, Rad- oder Pilgerwege. Inoffizielle Erschlie-ßungsmöglichkeiten wie Trampelpfade werden ebenfalls berücksichtigt. Wege, für die ein Betretungsverbot besteht (Kennzeichnung vor Ort), werden gleichgesetzt mit fehlendem Weg. Eine Sichtbeziehung besteht dann, wenn vom Weg aus die Hecke gesehen werden kann. Straße und Hecke sind dann visuell miteinander verbunden.""",
      "action": null,
      "section": FormSection.location,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.coral,
      'values': ['', 'weg_an_in_hecke', 'sichtbeziehung_zu_hecke', 'kein_weg'],
      'valuesEN': ['', 'path within/along hedge', 'no path vut visually connected', 'no path'],
      'valuesDE': ['', 'Weg an/in Hecke', 'Sichtbeziehung zu Hecke', 'Kein Weg'],
      'valueMap': {
        'Erholung & Tourismus': [null, 5, 3, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'horizontale_schichtung',
      "labelEN": "Horizontal stratification",
      "labelDE": "horizontale Schichtung",
      "descriptionEN": """Horizontal stratification defined by the horizontal structural layering of the hedge. It asks; is there only a tree layer? Are there no shrubs or are they so sparse that one cannot speak of a separate layer? """,
      "descriptionDE": """Die horizontale Schichtung fragt ab, wie sich die Schichtung in der Waagrechten darstellt, gibt es nur eine Baumschicht, sind Sträucher nicht vorhanden oder nur lückig, sodass man von keiner eigenen Schicht reden kann.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Layers",
      "subSectionDE": "Schichtung",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'vertikale_schichtung',
      "labelEN": "Vertical stratification",
      "labelDE": "vertikale Schichtung",
      "descriptionEN": """Vertical stratification describes the structure of a hedge in cross section. The mantel zone is the area of the hedge sides: it receives light and, especially on the south side, warmth. It is therefore made up of rather light-demanding shrubs that are often leafy all the way to the floor. A hedge that does not have a mantel is not closed off on its sides. A core zone is mainly found in older, wider hedges and is dark with a largely leafless interior. A hedge without a core zone is usually young and/or narrow, so that all plants get enough light.""",
      "descriptionDE": """Die vertikale Schichtung beschreibt den Aufbau einer Hecke im Querschnitt. Die Mantelzone ist der Bereich der Heckenseiten: er bekommt Licht und, vor allem südseitig, Wärme. Daher besteht er aus eher lichtbedürftigen Gebüschen, die oft bis unten belaubt sind. Eine Hecke, die keinen Mantel aufweist, schließt zur Seite hin nicht ab. Die Kernzone besteht vor allem bei älteren, breiteren Hecken und ist in ihrem Inneren dunkel und weitestgehend blattlos. Eine Hecke ohne Kernzone ist meist schmal und/oder noch jung, sodass alle Pflanzen genügend Licht bekommen.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Layers",
      "subSectionDE": "Schichtung",
      "borderColor": MyColors.purple,
      'values': ['', 'nur_kernzone', 'nur_mantelzone', 'kern_und_mantelzone'],
      'valuesEN': ['', 'core zone only', 'mantel zone only', 'core and mantel zone'],
      'valuesDE': ['', 'nur Kernzone', 'nur Mantelzone', 'Kern- und Mantelzone'],
      'valueMap': {
        'Fortpflanzungs- & Ruhestätte': [null, 0, 0, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'strukturvielfalt',
      "labelEN": "Structural diversity",
      "labelDE": "Strukturvielfalt",
      "descriptionEN": """Structural diversity refers to variation in width and height in the hedge. Variations are estimated over the length of the hedge. A slight increase/decrease in height or width is less significant than larger fluctuations in height and/or width.""",
      "descriptionDE": """Mit der Strukturvielfalt sind hier Breiten- und Höhenunterschiede in der Hecke gemeint. Sie werden über die Länge der Hecke hinweg geschätzt. Eine leichte Zu-/ Abnahme der Höhe oder Breite ist hier weniger entscheidend als größere Schwankungen in Höhe und/oder Breite.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Geomerty",
      "subSectionDE": "Geometrie",
      "borderColor": MyColors.purple,
      'values': ['', 'gleich_hoch_gleich_breit', '1_dimension_variabel', '2_dimensionen_variabel'],
      'valuesEN': ['', '+/- same height, same width', '1 dimension variable', '2 dimensions variable'],
      'valuesDE': ['', '+/- gleich hoch, gleich breit', '1 Dimension variabel', '2 Dimensionen variabel'],
      'valueMap': {
        'Schädlings- & Krankheitskontrolle': [null, 1, 3, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 3, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'luecken',
      "labelEN": "Gaps",
      "labelDE": "Lücken",
      "descriptionEN": """A gap is a hole in the canopy. Gaps <1 m are also counted in. For gaps, two things are considered: the presence of gaps larger than 5 m and the proportion of gaps relative to hedge length. The former can only be answered with yes or no: if there is a single gap of >5 m in the hedge, "A" is given. In the second category, the total length of all exist-ing gaps <5 m is given as a percentage of the total hedge length. For this, the length of all gaps is added up, then divided by the total length of the hedge and then multiplied by 100 %.""",
      "descriptionDE": """Als Lücke zählt ein Loch im Kronendach. Auch Lücken <1 m zählen. Für die Lücken werden zweierlei Dinge betrachtet: die Anwesenheit von Hecken größer 5 m sowie der Prozentsatz an Lücken bezogen auf die Heckenlänge. Ersteres ist lediglich mit ja oder nein zu beantworten: gibt es in der Hecke eine Einzellücke von >5 m, wird „A“ angegeben. Bei Zweiterem wird die Gesamtlänge aller vorhandenen Lücken <5 m als Prozentsatz der gesamten Heckenlänge angege-ben. Hierfür wird die Länge aller Lücken zusammengezählt, anschließend durch die Gesamtlänge der Hecke geteilt und dann mit 100 % multipliziert.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'totholz',
      "labelEN": "Deadwood",
      "labelDE": "Totholz",
      "descriptionEN": """The proportion of deadwood is estimated over the entire hedge. Both the amount and the deadwood value (standing is valued more than lying, thick more than thin) are taken into account. Depending on the number of times 'yes' is answered, the indicator is scored. The guiding questions are: \n-	Is there plenty (>10 %) of deadwood (DW)? \n-	Includes standing DW? \n-	Includes thick (>20 cm diameter at the thicker end) DW?\nNote: this refers to deadwood that remains in the hedge for a longer period, NOT to piles of wood that are to be removed. For these, see indicator ""(agroforestry) usage traces"".""",
      "descriptionDE": """Der Totholzanteil wird über die gesamte Hecke hinweg geschätzt. Es fließen sowohl Menge als auch Wertigkeit des Totholzes (stehendes ist besser als liegendes, dickes besser als dünnes) mit ein. Je nachdem, wie oft hier mit ‚Ja‘ geantwortet wird, wird der Indikator bewertet. Die Leitfragen sind:\n-	Gibt es viel (>10 %) Totholz (TH)?\n-	Zumindest auch stehendes TH?\n-	Zumindest auch starkes (>20 cm Durchmesser am dickeren Ende) TH?\nAnmerkung: es geht um Totholz, das längerfristig in der Hecke verbleibt, NICHT um Holzstapel, die abge-führt werden. Für diese, siehe Indikator „(agroforstliche) Nutzungsspuren“.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.purple,
      'values': ['', 'kein_totholz', 'kein_merkmal', '1_merkmal', '2_merkmale', '3_merkmale'],
      'valuesEN': ['', 'no deadwood', 'no attribute: little and lying and thin DW ', '1 attribute: plenty or standing or thick DW', '2 attributes', '3 attributes: plenty and standing and thick DW'],
      'valuesDE': ['', 'kein Totholz', 'kein Merkmal: wenig und liegendes und schwaches TH', '1 Merkmal: kein Merkmal erfüllt: wenig und liegendes und schwaches TH ', '2 Merkmale', '3 Merkmale: viel und stehendes und starkes TH'],
      'valueMap': {
        'Rohstoffe': [null, 0, 0, 0, -1, -1],
        'Nähr- & Schadstoffkreisläufe': [null, 5, 4, 3, 2, 1],
        'Bestäubung': [null, 1, 2, 3, 4, 5],
        'Nahrungsquelle': [null, 1, 2, 3, 4, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'alterszusammensetzung',
      "labelEN": "Age composition",
      "labelDE": "Alterszusammensetzung",
      "descriptionEN": """Estimating the age of the plants in the hedge requires some practice. For easier assessment, typical criteria for age (class) classification were taken from ZWÖLFER (1982a) (see below). It is possible that several age classes are present in a hedge. """,
      "descriptionDE": """Die Einschätzung des Alters der Pflanzen in der Hecke erfordert etwas Übung. Zur leichteren Einschätzung wurde aus ZWÖLFER (1982a) typische Kriterien für die Alters(klassen)zuordnung entnommen (siehe untenstehender Link). Es ist möglich, dass mehrere Altersklassen in einer Hecke vorkommen. """,
      "actionEN": ImageDescriptor.tabelle_altersklassen_engl, "actionDE": ImageDescriptor.tabelle_altersklassen,
      "section": FormSection.structure,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.purple,
      'values': ['', 'lt_6_jahre', '6_to_20_jahre', '20_to_50_jahre', 'gt_50_jahre', 'gemischtes_alter'],
      'valuesEN': ['', '<6 years (0, I)', '6-20 years (II, III)', '20-50 years (IV)', '>50 years (V)', 'mixed age (3+ age classes)'],
      'valuesDE': ['', '<6 Jahre (0, I)', '6-20 Jahre (II, III)', '20-50 Jahre (IV)', '>50 Jahre (V)', 'gemischtes Alter (3+ Altersstufen)'],
      'valueMap': {
        'Klimaschutz': [null, 1, 2, 4, 5, 4],
        'Bestäubung': [null, 1, 2, 4, 5, 4],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 2, 4, 3, 5],
        'Erholung & Tourismus': [null, 1, 2, 4, 5, 4],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'saum_art',
      "labelEN": "Fringe type",
      "labelDE": "Saumart",
      "descriptionEN": """The hedge fringe represents the border of the hedge and is made up of perennial grasses and shrubs. A fringe can be distinguished by a mown strip by the extensiveness of use (less frequent mowing, fewer nutrients) and the resulting species community. Fringes are characterized by annual or perennial tall herbs that usually form dense stands and, due to their abundance of flowers, stand out clearly from the mostly monotonous agricultural land. Since grasslands (meadows and pastures) are also not ploughed, which is a relevant factor for the fulfillment of some ESSs, they are also included here.""",
      "descriptionDE": """Der Heckensaum schließt an die Hecke an und ist mit mehrjährigen Gräsern und Stauden bestückt. Was den Saum im engeren Sinne vom Mähstreifen unterscheidet, ist die Extensivität (seltenere Mahd, weniger Nährstoffe) und die dadurch entstehende Artengemeinschaft, die durch ein- oder mehrjährige Hochstauden, die zumeist dichte Bestände bilden und sich aufgrund ihres Blütenreichtums deutlich von den meist monotonen landwirtschaftlichen Nutzflächen abheben geprägt sind.\nDa Grünland (Wiesen und Weiden) ebenfalls nicht gepflügt werden und dies für die Erfüllung einiger ÖSL der relevante Faktor ist, werden auch diese hier mit aufgenommen.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.purple,
      'values': ['', 'saum', 'maehstreifen', 'gruenland', 'nichts_davon'],
      'valuesEN': ['', 'fringe', 'mown strip', 'grassland', 'none'],
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
      'type': InputType.dropdown,
      'label': 'saum_breite',
      "labelEN": "Fringe width",
      "labelDE": "Saumbreite",
      "descriptionEN": """The fringe starts at the outer edge of the hedge. In the absence of the shrub layer, the herbaceous area under the hedge is not counted. The fringe is sampled in 30 m sections by estimating the average width in meters of the herbaceous border between the edge of the wooded area and the path or field edge on either side.""",
      "descriptionDE": """Der Saum beginnt an der Außenkante der Hecke. Beim Fehlen der Strauchschicht ist der krautige Bereich unter der Hecke nicht mitzuzählen. Er wird im 30 m-Abschnitt aufgenommen, indem die durchschnittliche Breite des Krautsaums zwischen Gehölzrand und Weg oder Feldrand zu beiden Seiten in Metern geschätzt wird.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'hecken_hoehe',
      "labelEN": "Height",
      "labelDE": "Höhe",
      "descriptionEN": """Height is determined as an average value over the 30 m section. If the hedge grows on an embankment, it is not included. In the case of an asymmetrical embankment, where the height of the hedge is lower on one side, the height on the lower side is recorded. Gaps in the hedge and individual trees are also not included in the estimation. If, on the other hand, the trees form the canopy (tree hedge), these are already included. The taller a hedge, the more difficult it is to accurately measure the height. Surveyors should give their best estimate; Under normal conditions, the height can typically be estimated to within 1-2 meters.""",
      "descriptionDE": """Die Höhe wird als Durchschnittswert im 30 m-Abschnitt ermittelt. Wächst die Hecke auf einer Bank, wird diese nicht mit einbezogen. Bei einer asymmetrischen Bank, bei der die Höhe der Hecke auf einer Seite geringer ist, wird die Höhe auf der niedrigeren Seite ermittelt. Ebenfalls nicht mit einbezogen in die Schätzung werden Lücken in der Hecke sowie Einzelbäume. Bilden hingegen die Bäume das Kronendach (Baumhecke) werden diese schon mit einbezogen.\nJe höher eine Hecke, desto schwieriger ist es, die Höhe genau zu messen. Gutachter:innen sollten ihre best mögliche Schätzung abgeben; unter realen Bedingungen kann die Höhe typischerweise auf 1-2 m Genauigkeit abgeschätzt werden.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Geomerty",
      "subSectionDE": "Geometrie",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'hecken_breite',
      "labelEN": "Width",
      "labelDE": "Breite",
      "descriptionEN": """For width, the mean value in the 30 m section is to be determined. This is either measured with a tape measure or, if not possible, estimated. If the hedge width is uniform along its length, the width can be meas-ured with a tape measure, the easiest way to do this is at a gap. Isolated hedge trees and gaps are not included in the width. Overhanging plant segments are only counted as part of the hedge width starting  0.5 m above the ground.""",
      "descriptionDE": """Es soll der Mittelwert im 30 m-Abschnitt ermittelt werden. Dieser wird entweder mit einem Maßband gemessen, oder, wenn Ersteres nicht möglich ist, geschätzt. Ist die Heckenbreite entlang der Länge gleichmäßig, kann die Breite mit einem Maßband gemessen werden, am einfachsten ist dies an einer Lücke. Vereinzelte Heckenbäume und Lücken fließen nicht in die Breite mit ein. Überhängende Pflanzenteile werden erst ab einer Höhe von 0,5 m zur Heckenbreite gezählt.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Geomerty",
      "subSectionDE": "Geometrie",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'baumanteil',
      "labelEN": "Proportion of trees",
      "labelDE": "Baumanteil",
      "descriptionEN": """Any living woody plants with a dominant shoot axis (trunk) and a diameter at breast height (= trunk diameter at a height of 1.30 m) of more than 7 cm is considered a tree. Accordingly, shrubs, lianas, grasses, herbs, deadwood, and litter are not considered as trees. The target value for the proportion of trees is the number of trees in the hedge per 100 m section. For this, the hedge length is needed (see above), as well as the total number of trees in the hedge. The formula for this is: Proportion of trees = No.trees /Length [m] * 100 m""",
      "descriptionDE": """Als Baum zählt jedes lebende Gehölz mit einer dominierenden Sprossachse (Stamm) und einem Brusthöhendurchmesser (= Stammdurchmesser in 1,30 m Höhe) von über 7 cm. Keine Bäume sind demnach Sträucher, Lianen, Gräser, Kräuter, Totholz und Streu.\nZielgröße für den Baumanteil ist die Anzahl der Bäume in der Hecke pro 100 m Heckenlänge. Hierfür wird die Heckenlänge benötigt (siehe oben), sowie die Gesamtanzahl der Bäume in der Hecke. Die Formel hierfür lautet: Baumanteil = Anzahl Bäume / Heckenlänge [m] * 100 m""",
      "action": null,
      "section": FormSection.plants,
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
      "borderColor": MyColors.green,
      'values': ['', '0', '1_to_2_per_00m', '3_to_9_per_00m', '10_to_20_per_100m', 'gt_20_per_100m'],
      'valuesEN': ['', '0', '1-2/ 100m', '3-9/ 100m', '10-20/ 100m', '>20/ 100m'],
      'valuesDE': ['', '0', '1-2/ 100m', '3-9/ 100m', '10-20/ 100m', '>20/ 100m'],
      'valueMap': {
        'Rohstoffe': [null, 1, 1, 1, 2, 3],
        'Schädlings- & Krankheitskontrolle': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'anzahl_gehoelz_arten',
      "labelEN": "Number of wood species",
      "labelDE": "Anzahl Gehölzarten",
      "descriptionEN": """To determine the number of woody species in the hedge, the various woody species are counted in a given 30 m section (FOULKES et al. 2013). It should be noted that, especially in heterogeneous hedges, the num-ber of woody species can sometimes be significantly higher than recorded in the 30 m section. Leaves, flowers/fruits and growth forms are particularly helpful in identifying and distinguisching woody spe-cies. Plant identification apps such as Flora Incognita or PlantNet can also provide useful assistance.""",
      "descriptionDE": """Um die Anzahl der Gehölzarten in der Hecke festzustellen, werden die verschiedenen Gehölzarten im 30 m-Abschnitt gezählt. Es sei hier festzuhalten, dass, gerade in heterogenen Hecken die Anzahl der Gehölzarten mitunter deutlich höher sein kann, als im 30 m-Abschnitt aufgenommen. Hilfe für die Unterscheidung der Gehölzarten bieten vor allem Blätter, Blüten/Früchte, sowie Wuchsformen. Auch Pflanzenbestimmungs-Apps wie z.B. Flora Incognita oder PlantNet können gute Dienste leisten. """,
      "action": null,
      "section": FormSection.plants,
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
      "borderColor": MyColors.green,
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
      'type': InputType.dropdown,
      'label': 'dominanzen',
      "labelEN": "Dominance of species",
      "labelDE": "Dominanzen",
      "descriptionEN": """The dominance of woody species in an ecosystem refers to the relative abundance and distribution of tree and shrub species in an area. Dominance depends on various factors, such as climate, soil composition, topo-graphic position, and/or the influence of human activities. The possible dominance of individual species is estimated in a given 30 m section.""",
      "descriptionDE": """Die Dominanz von Gehölzarten in einem Ökosystem bezieht sich auf die relative Häufigkeit und Verteilung von Baum- und Straucharten in einem bestimmten Gebiet. Die Dominanz hängt von verschiedenen Faktoren ab, wie zum Beispiel dem Klima, der Bodenzusammensetzung, der topographischen Lage oder dem Einfluss von menschlichen Aktivitäten. Die eventuellen Dominanzen einzelner Arten werden im 30 m-Abschnitt geschätzt. """,
      "action": null,
      "section": FormSection.plants,
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
      "borderColor": MyColors.green,
      'values': ['', 'quasi_keine', 'leichte_dominanz', 'starke_dominanz'],
      'valuesEN': ['', 'no dominances', 'slight dominance', 'strong dominance'],
      'valuesDE': ['', 'keine Dominanzen', 'leichte Dominanz', 'starke Dominanz'],
      'valueMap': {
        'Bestäubung': [null, 1, 3, 5],
        'Nahrungsquelle': [null, 1, 3, 5],
        'Fortpflanzungs- & Ruhestätte': [null, 1, 3, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'neophyten',
      "labelEN": "Neophytes",
      "labelDE": "Neophyten",
      "descriptionEN": """Neophytes are non-native plants that have been introduced by humans after the 15th century. A neophyte is invasive if it has significant undesirable effects on other species and biotic communities, such as displacement of native plants through competition for space and resources. Neophyte cover is estimated in the 30 m section. When recording neophytes, the following list can be used as a guide. If neophytes are detected that are not on the list, these should also be recorded. The percentage of neophytes is estimated. This does not refer to the proportion in relation to other species, but to the total cover.""",
      "descriptionDE": """Als Neophyten werden Pflanzen verstanden, die nicht heimisch sind und seit dem 16. Jahrhundert vom Men-schen eingeschleppt wurden. Invasiv ist ein Neophyt dann, wenn er we-sentliche unerwünschte Auswirkungen auf andere Arten und Lebensgemeinschaften hat, wie beispielsweise Verdrängung heimischer Pflanzen durch Platz- und Ressourcenkonkurrenz. Die Neophytenbedeckung wird im 30 m-Abschnitt geschätzt. Bei der Aufnahme von Neophyten kann sich an der nachstehenden Liste orientiert werden. Werden Neophyten erkannt, die nicht in der Liste stehen, sind diese ebenfalls zu berücksichtigen. Der prozentuelle Anteil von Neophyten wird geschätzt. Es geht hierbei nicht um den Anteil bezogen auf die Arten, sondern um die Gesamtbedeckung. Empfehlung bei Unsicherheiten: Pflanzenbestimmungs-Apps wie beispielsweise Flora Incognita oder Plant-Net.""",
      "action": null,
      "section": FormSection.plants,
      "subSectionEN": "Species Composition",
      "subSectionDE": "Artenzusammensetzung",
      "borderColor": MyColors.green,
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
    {
      "type": InputType.list,
      "label": "nachbar_flaechen",
      "labelEN": "Neighboring Areas",
      "labelDE": "Nachbarflächen",
      "descriptionEN": """As part of a landscape or ecosystem, hedges can have diverse neighboring areas that can influence their function and impact. The neighboring areas of the hedge are identified in the field. Extensive viticulture and orcharding are addressed as scattered orchard systems or vineyards with diverse ground cover, all remaining viticulture and orcharding areas are classified in the same category as arable land. All areas adjacent to the hedge are included. """,
      "descriptionDE": """Hecken können als Teil einer Landschaft oder eines Ökosystems verschiedene Nachbarflächen haben, die ihre Funktion und Wirkung beeinflussen können. Die Nachbarflächen der Hecke werden im Feld angegeben. Als extensiver Wein- und Obstbau werden Streuobstsysteme oder Weingärten mit diversem Bodenbewuchs angesprochen, alle restlichen Wein- und Obstbauflächen werden in derselben Kategorie wie Ackerflächen eingestuft. Es werden alle an die Hecke angrenzenden Flächen aufgenommen. Mehrfachnennungen sind möglich. """,
      "action": null,
      "section": FormSection.location,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.coral,
      "values": const ['siedlung_strasse', 'gruenland_ext', 'gruenland_int', 'acker', 'unbefestigter_weg', 'brache'],
      "valuesEN": const ['paved area', 'extensive grassland ', 'intensive grassland', 'arable land', 'unpaved road', 'fallow land'],
      "valuesDE": const ['Siedlung/Straße', 'extensives Grünland', 'intensives Grünland', 'Acker', 'unbefestigter Weg', 'Brache'],
      'valueMap': {
        'Ertragssteigerung': [null, 0, 1, 1, 1, 0, 0],
        'Nähr- & Schadstoffkreisläufe': [null, 4, 1, 2, 5, 1, 1],
        'Bestäubung': [null, -1, 1, 0, 0, -1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, -2, 2, 1, -1, -1, 2],
      },
    },
    {
      "type": InputType.list,
      "label": "nutzungs_spuren",
      "labelEN": "(Agroforestry) use traces",
      "labelDE": "Nutzungsspuren",
      "descriptionEN": """Agroforestry refers to the integration of trees or shrubs into agricultural land or systems to achieve ecological and economic benefits. Beehives, fruit trees and wood piles are all possible components of an agroforestry design of hedgerows.""",
      "descriptionDE": """Agroforstwirtschaft bezieht sich auf die Integration von Bäumen oder Sträuchern in landwirtschaftliche Flächen oder Systeme, um ökologische und ökonomische Vorteile zu erzielen. Bienenstöcke, Obstbäume und Holzstapel sind alles mögliche Bestandteile einer agroforstwirtschaftlichen Gestaltung von Hecken. """,
      "action": null,
      "section": FormSection.usage,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.coral,
      "values": const ['keine_ersichtlich', 'bienen_stoecke', 'obst', 'gelagerte_holzstapel', 'andere_nutzung'],
      "valuesEN": const ['none apparent', 'bee hives', 'fruit tree(s)', 'stored wood piles', 'other use'],
      "valuesDE": const ['keine ersichtlich', 'Bienenstöcke', 'Obst', 'gelagerte Holzstapel', 'andere Nutzung'],
      'valueMap': {
        'Rohstoffe': [null, 0, 1, 1, 1, 1],
        'Bestäubung': [null, 0, 1, 0, 0, 0],
      },
    },
    {
      "type": InputType.list,
      "label": "zusatz_strukturen",
      "labelEN": "Additional structures",
      "labelDE": "Zusatzstrukturen",
      "descriptionEN": """Additional structures next to or in the hedge that are (or can be) used by people are recorded. These factors are collected in the field. Other structures that serve educational or recreational purposes, such as themed trails, are also included here. """,
      "descriptionDE": """Erfasst werden Zusatzstrukturen neben oder in der Hecke, die von Menschen genutzt werden (können). Dies wird im Feld erhoben. Mehrfachnennungen sind möglich. Weitere Strukturen die der Bildung oder Erholung dienen, wie beispielsweise Themenwege, werden hier ebenso aufgenommen.""",
      "action": null,
      "section": FormSection.usage,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.coral,
      "values": const ['jagd_zb_hochstand', 'erholung_zb_bank', 'bildung_zb_schautafel', 'kulturdenkmal', 'naturdenkmal', 'nichts'],
      "valuesEN": const ['hunting, e.g. high stand', 'recreation, e.g. bench', 'education, e.g. display board', 'cultural monument', 'natural monument' 'none'],
      "valuesDE": const ['Jagd, z.B. Hochstand', 'Erholung, z.B. Bank', 'Bildung, z.B. Schautafel', 'Kulturdenkmal', 'Naturdenkmal', 'nichts'],
      'valueMap': {
        'Rohstoffe': [null, 1, 0, 0, 0, 0, 0],
        'Erholung & Tourismus': [null, 0.5, 1, 1, 0.5, 0.5, 0],
        'Kulturerbe': [null, 0, 0, 0, 1, 1, 0],
      },
    },
    {
      "type": InputType.list,
      "label": "management",
      "labelEN": "Management",
      "labelDE": "Management",
      "descriptionEN": """Traces of management are not always recognizable. It is not always possible to rule out the presence of man-agement practices that are not apparently visible. This section is concerned with visible management that has presumably taken place in recent years. Examples are visible cuts on woody plants, grazing protection around young woody plants or similar. """,
      "descriptionDE": """Spuren von Management sind nicht immer gut erkennbar. Es kann nicht ausgeschlossen werden, dass es Management gibt, das nicht unmittelbar sichtbar ist. Hier geht es also um sichtbares Management, das vermutlich in den letzten Jahren stattgefunden hat. Beispiele sind sichtbare Schnitte an Gehölzen, Verbissschutz um junge Gehölze oder ähnliches.""",
      "action": null,
      "section": FormSection.usage,
      "subSectionEN": null,
      "subSectionDE": null,
      "borderColor": MyColors.coral,
      "values": const ['nichts_sichtbar', 'baum_strauch_nachgepflanzt', 'seitenschnitt_sichtbar', 'auf_stock_gesetzt', 'einzelbaum_strauch_rueckschnitte', 'einzelstamm_entnahme'],
      "valuesEN": const ['no management visible', 'recent plantaion of (single) plant(s)', 'lateral cut', 'coppiccing', 'single tree/shrub removal', 'single stem removal'],
      "valuesDE": const ['nichts sichtbar', 'Baum/Strauch nachgepflanzt', 'Seitenschnitt sichtbar', 'auf Stock gesetzt', 'Einzelbaum/-strauch Rückschnitte', 'Einzelstamm Entnahme'],
      'valueMap': {
        'Rohstoffe': [null, 0, 0, -1, 2, 0, 1],
        'Bestäubung': [null, 1, 0, -1, 1, 1, 0],
      },
    },
    {
      "type": InputType.list,
      "label": "sonder_form",
      "labelEN": "Special type",
      "labelDE": "Sonderform",
      "descriptionEN": """A special type of hedge is one that grows on uneven ground, such as on a linear mound. In individual cases, multiple classifications are also possible. Explanation of terms: Clearance cairns are accumulations of stones, high linear mounds are narrow accumula-tions of soil and embankments are inclined surfaces or slopes.""",
      "descriptionDE": """Als Sonderform werden Hecken bezeichnet, die auf nicht ebenem Boden stocken, wie einem Hochrain. In Einzelfällen ist hier auch eine Mehrfachnennung möglich. Begriffserklärungen: Lesesteinhaufen sind Ansammlungen von Steinen, Hochraine sind schmale Anhäufungen von Erde und Böschungen sind geneigte Flächen oder Hänge.""",
      "action": null,
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.coral,
      "values": const ['keine_sonderform', 'lesesteinhecke', 'hecke_auf_hochrain', 'boeschungs_hecke', 'grabenhecke'],
      "valuesEN": const ['no special type', 'on clearance cairn', 'on linear mound', 'embankment hedge', 'trench hedge'],
      "valuesDE": const ['keine Sonderform', 'Lesesteinhecke', 'Hecke auf Hochrain', 'Böschungshecke', 'Grabenhecke'],
      'valueMap': {
        'Nähr- & Schadstoffkreisläufe': [null, 0, 1, 1, 0, 0],
        'Bestäubung': [null, 0, 1, 1, 1, 1],
        'Schädlings- & Krankheitskontrolle': [null, 0, 2, 2, 1, 1],
        'Fortpflanzungs- & Ruhestätte': [null, 0, 1, 1, 1, 1],
        'Kulturerbe': [null, 0, 1, 1, 1, 1],
      },
    },
  ];
}

List<String> getSectionsFromLocale(String locale) {
  return getSections()
      .map((section) => section["label$locale"].toString())
      .toList();
}

enum MapDescriptor {
  NULL,
  arcanum,
  bodenkarte,
  bodenkarteNutzbareFeldkapazitaet,
  bodenkarteHumusBilanz,
  geonodeLebensraumVernetzung,
  ecosystem,
  geoland,
  noeNaturschutz,
  eeaProtectedAreas
}

enum ImageDescriptor {
  kwb_noe4,
  kwb_noe_regionen,
  tabelle_altersklassen,
  tabelle_altersklassen_engl
}

enum InputType {
  text,
  number,
  dropdown,
  list
}

enum FormSection {
  general,
  location,
  usage,
  structure,
  map_location,
  map_soil,
  plants,
  images
}

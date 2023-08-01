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
    // deleted strings: physical, environmental, biodiversity, general, images
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
      'type': InputType.text,
      'label': 'hecken_name',
      "labelEN": "Hedge name/number",
      "labelDE": "Hecken Name /-nummer",
      // 'descriptionEN': 'Enter the name of the hedge',
      // 'descriptionDE': 'Geben Sie den Namen der Hecke ein',
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
      'action': MapDescriptor.arcanum,
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
      'section': FormSection.images,  // TODO: add to FormSection.images
      'borderColor': MyColors.yellow,
      'controller': TextEditingController(),
    },
    // gis fields
    {
      'type': InputType.number,
      'label': 'hecken_laenge',
      "labelEN": "Length [m]",
      "labelDE": "Länge [m]",
      "descriptionEN": """Enter the length of the hedge in meters""",
      "descriptionDE": """Die Länge der Hecke ist kein eigenständiger Indikator, sondern dient lediglich der Berechnung des Baumanteils. Diese Information kann beispielsweise über den Niederösterreich Atlas ermittelt werden, der unter dem Link https://atlas.noe.gv.at/webgisatlas zu finden ist. Dort kann die Länge in Metern einfach mit dem Werkzeug „Strecke messen“ ermittelt und in das entsprechende Feld eingetragen werden.""",
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
      "descriptionEN": """Select the compass direction""",
      "descriptionDE": """Trifft der Wind im rechten Winkel auf die Hecke, ist ihre bremsende Wirkung am höchsten. Die Hauptwindrichtung in weiten Teilen Österreichs liegt im Sektor W – NW, und auch die höchsten Geschwindigkeiten werden aus diesen Richtungen gemessen. Sogenannte Vb („fünf B“) Wetterlagen oder Mittelmeertiefs sind eine weitere bedeutende Erscheinung, die starke Windentwicklung aus S – SO mit sich bringen. Diese Muster gelten vor allem für den Raum am nordöstlichen Ende des Alpenbogens, also Niederösterreich – für andere Regionen kann es notwendig sein, die Einschätzung leicht abzuändern. Die Ausrichtung der Hecke zur Himmelsrichtung wird in einem beliebigen Kartenprogramm auf dem Satellitenbild abgelesen.""",
      "section": FormSection.map_location,
      "subSectionEN": "Orientation",
      "subSectionDE": "Ausrichtung",
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
      "descriptionEN": """Select the protected area status""",
      "descriptionDE": """Die Erfassung der Schutzgebiete erfolgt über den Niederösterreich Atlas (https://atlas.noe.gv.at/webgisatlas). Rechts oben neben der Suchleiste auf die drei parallelen Linien drücken und bei Weitere Karten – Naturraum – Naturschutz auswählen. Hier lässt sich „Natura 2000 FFH Außengrenze“, „Natura 2000 Vogelschutzgebiete“, „Nationalparks“, „Naturschutzgebiete“, „Landschaftsschutzgebiete“, „Naturparke“, „Biosphärenpark Wienerwald“ und „Ramsargebiete“ ankreuzen.""",
      "section": FormSection.map_location,
      "subSectionEN": "Conservation",
      "subSectionDE": "Schutzgebiet",
      "borderColor": MyColors.blue,
      'values': ['', 'schutzgebiet', 'kein_schutzgebiet'],
      'valuesEN': ['', 'protected area', 'no protected area'],
      'valuesDE': ['', 'Schutzgebiet', 'Kein Schutzgebiet'],
      'valueMap': {
        "Erholung & Tourismus": [null, 1, 0],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'naturdenkmal',
      "labelEN": "Natural monument",
      "labelDE": "Naturdenkmal",
      "descriptionEN": """Select if there is a natural monument in or near the hedge""",
      "descriptionDE": """"„Naturgebilde, die sich durch ihre Eigenart, Seltenheit oder besondere Ausstattung auszeichnen, der Land-schaft ein besonderes Gepräge verleihen oder die besondere wissenschaftliche oder kulturhistorische Bedeu-tung haben, können mit Bescheid von der Naturschutzbehörde zum Naturdenkmal erklärt werden. Zum Na-turdenkmal können daher insbesondere Klammen, Schluchten, Quellen, Bäume, Hecken, Alleen, Baum- oder Gehölzgruppen, [...] erklärt werden“ (NÖ Naturschutzgesetz, §12 (1)). """,
      "section": FormSection.map_location,
      "subSectionEN": "Conservation",
      "subSectionDE": "Schutzgebiet",
      "borderColor": MyColors.blue,
      'values': ['', 'naturdenkmal_in_nahe_hecke', 'kein_naturdenkmal_in_nahe_hecke'],
      'valuesEN': ['', 'Natural monument in/near the hedge', 'No natural monument in/near the hedge'],
      'valuesDE': ['', 'Naturdenkmal in/nahe der Hecke', 'Kein Naturdenkmal in/nahe der Hecke'],
      'valueMap': {
        "Kulturerbe": [null, 1, 0]
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'hecken_dichte',
      "labelEN": "Hedge density",
      "labelDE": "Heckendichte",
      "descriptionEN": """Select the density range of the hedge""",
      "descriptionDE": """Die Erfassung der Schutzgebiete erfolgt über den Niederösterreich Atlas (https://atlas.noe.gv.at/webgisatlas). Rechts oben neben der Suchleiste auf das Symbol mit drei parallelen Linien klicken und Weitere Karten aus-wählen. Unter Naturraum findet sich die Karte Naturschutz. Hier lässt sich Naturdenkmäler ankreuzen. Es wird „A“ gewählt, wenn entweder Hecke selbst Naturdenkmal ist, in der Hecke ein Einzelgehölz steht, das ein Naturdenkmal ist oder sich in unmittelbarer Nähe (sichtbar!) ein Naturdenkmal befindet.""",
      "section": FormSection.map_location,
      "subSectionEN": "Density and Capacity",
      "subSectionDE": "Dichte und Kapazität",
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
      "descriptionEN": """Select the climatic water balance color""",
      "descriptionDE": """Der Heckendichte in einem bestimmten Landschaftsausschnitt wird über die Website des Niederösterreich Atlas (https://atlas.noe.gv.at/webgisatlas) ermittelt. Hierfür wird um die zu bewertende Hecke mit dem Zeichenwerkzeug (Werkzeuge - zeichnen) ein Kreis gezogen, der den Radius 280 m besitzt (für einen Flächeninhalt von etwa 25 ha). Innerhalb dieses Kreises wird nun die Gesamtlänge aller Hecken ermittelt. Dies ist mit dem Tool „Bemaßung“ oder „Strecke messen“ möglich. """,
      "section": FormSection.map_location,
      "subSectionEN": "Climate and Water",
      "subSectionDE": "Klima und Wasser",
      "borderColor": MyColors.blue,
      'values': ['', 'violett', 'blau ', 'weissblau_hellblau ', 'hellgelb_weiss', 'rot, orange'],
      'valuesEN': ['', 'purple', 'blue ', 'white-blue-light blue ', 'light yellow-white ', 'red, orange'],
      'valuesDE': ['', 'violett', 'blau ', 'weißblau-hellblau ', 'hellgelb-weiß ', 'rot, orange'],
      'valueMap': {
        'Klimaschutz': [null, 5, 4, 3, 2, 1],
        'Bodenschutz': [null, 1, 2, 3, 4, 5],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'bevoelkerungs_dichte',
      "labelEN": "Population density",
      "labelDE": "Bevölkerungsdichte",
      "descriptionEN": """Select the population density range""",
      "descriptionDE": """Der wesentliche Unterschied in den klimatischen Gegebenheiten innerhalb Österreichs liegt im Wasserhaushalt, der stark je nach Gebiet variiert und von vielen Faktoren, wie z.B. Niederschlagsmenge, Verdunstung, Bodenbeschaffenheit und Topografie abhängt. Die klimatische Wasserbilanz ist hierfür der aussagekräftigste Indikator, sie gibt die Differenz zwischen Jahresniederschlag und potenzieller Verdunstung wieder. Die Karte der klimatischen Wasserbilanz für Niederösterreich befindet sich in Anhang 2.""",
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
      "descriptionEN": """Select if the location is in a wildlife corridor""",
      "descriptionDE": """Die Erfassung der Bevölkerungsdichte (Einwohner:innen/km²) erfolgt über https://ecosystem-accounts.jrc.ec.europa.eu/map. Zunächst wird mittels des quadratischen Kartensymbols am linken Rand als Basis Layer colorful (bright) ausgewählt und die Opazität mithilfe des Reglers ganz hoch stellen. Im nächsten Schritt in der Zeile oberhalb des Kartenbildes die Sparte Cultural (links) auswählen. Darunter erscheint die Auswahlmöglichkeit Nature-based recreation. Anklicken und im aufgehenden Fenster die Option Demand wählen. Links über der Legende kann mithilfe des blauen Reglers die Opazität verändert werden. Die Orientierung erfolgt über die Kartenbeschriftung, Orts-/ Koordinatensuche ist nicht möglich. Erfassung der Nachfrage anhand der eingeblendeten Farbe am Standort der Hecke und Einordnung entsprechend der Legende. Sofern sich die Hecke genau an der Grenze zwischen zwei Gebieten mit unterschiedlich hoher Bevölkerungsdichte befindet, ist der höhere Wert zu wählen.""",
      "section": FormSection.map_location,
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
      "borderColor": MyColors.blue,
      'values': ['', 'ja', 'nein'],
      'valuesEN': ['', 'yes', 'no'],
      'valuesDE': ['', 'ja', 'nein'],
      'valueMap': {
        "Korridor": [null, 1, 0],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'traditionelle_heckenregion',
      "labelEN": "Traditional hedgerow region",
      "labelDE": "traditionelle Heckenregion",
      "descriptionEN": """Select if it is a traditional hedge region or not""",
      "descriptionDE": """Die Umsetzung der Grünraumvernetzung ist in Österreich auf Länderebene unterschiedlich weit entwickelt. Während in manchen Bundesländern wie der Steiermark Grünkorridore per Verordnung abgesichert sind, gibt es solcherlei rechtliche Absicherung in anderen Bundesländern nicht (BMK 2020). Seit 2018 gibt es jedoch einen österreichweiten Vorschlag für überregionale Lebensraumvernetzung, der über die Web-Applikation der Lebensraumvernetzung Österreich, einem Informationsportal des BMK (mit Unterstützung von Bund (BML) und Europäischer Union. Darin liegen die Korridore in Linienform vor. Für die Bewertung der Korridorabschnitte wurde jedoch mit einem Pufferbereich gerechnet, die für die Indikatoraufnahme herangezogen wird. Liegt die Hecke innerhalb des Puffers, wird davon ausgegangen, dass sich die Hecke in einem Wildtierkorridor befindet. Aufzurufen sind die Daten unter https://geonode.lebensraumvernetzung.at/maps/63/view#/. Links unter Ebenen ist die Bewertung LRVA durch das Auge zu aktivieren.""",
      "section": FormSection.map_location,
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
      "borderColor": MyColors.blue,
      'values': ['', 'heckenregion', 'keine_heckenregion'],
      'valuesEN': ['', 'hedge region', 'no hedge region'],
      'valuesDE': ['', 'Heckenregion', 'Keine Heckenregion'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'franziszeischer_kataster',
      "labelEN": "Franziscean cadaster",
      "labelDE": "Franziszeischer Kataster",
      "descriptionEN": """Select if it is identifiable in the French cadastre or not""",
      "descriptionDE": """Niederösterreich verzeichnet einige Regionen, die eine lange Heckentradition haben. In anderen Regionen ist dies nicht der Fall. Anhand der Kulturlandschaftsgliederung Österreichs (Wrbka et al. 2002) wurden traditionelle Heckenregionen herausgearbeitet. In Bewertung der Ökosystemleistung findet sich eine Karte der Heckenregionen in Niederösterreich. Für andere Bundesländer/Länder sind hier Anpassungen notwendig. """,
      "section": FormSection.map_location,
      "subSectionEN": "Landscape and Population",
      "subSectionDE": "Landschaft und Bevölkerung",
      "borderColor": MyColors.blue,
      'values': ['', 'im_kataster_erkennbar', 'nicht_im_kataster_erkennbar'],
      'valuesEN': ['', 'Identifiable in cadastre', 'Not identifiable in cadastre'],
      'valuesDE': ['', 'Im Kataster erkennbar', 'Nicht im Kataster erkennbar'],
      'valueMap': {
        "Kulturerbe": [null, 5, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'nutzbare_feldkapazitaet',
      "labelEN": "Usable field capacity",
      "labelDE": "nutzbare Feldkapazität",
      "descriptionEN": """Enter the usable field capacity""",
      "descriptionDE": """Der Franziszeische Kataster ist ein historisches Kartenwerk, das zwischen 1810 und 1870 als Grundlage für die Berechnung der Grundsteuer erstellt wurde und bis heute die Basis für die Grundbücher Österreichs bildet. Die Kartenblätter für den Raum Wien und Niederösterreich entstanden in der Zeit von 1817-1824. Beim Vergleich der Altkarten mit aktuellen Aufnahmen wird deutlich, dass die Gliederung der Landschaft und ihrer Strukturelemente in vielen Fällen auch nach 200 Jahren noch starke Parallelen aufweist. Die Erfassung erfolgt durch das Überlagern der Satellitenkarte (Basiskarte) mit dem Franziszeischen Kataster auf https://maps.arcanum.com/. Durch Regeln der Opazität des Katasters kann die aktuelle Luftbildaufnahme gut verglichen werden.""",
      "section": FormSection.map_soil,
      "subSectionEN": "Density and Capacity",
      "subSectionDE": "Dichte und Kapazität",
      "borderColor": MyColors.blue,
      'values': ['', 'lt_60mm', '60_to_140mm', '140_to-220mm', '220_to_300mm'],
      'valuesEN': ['', 'Very low (<60mm)', 'Low (60-140mm)', 'Medium (140-220mm)', 'High (220-300mm)'],
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
      "descriptionEN": """Select the humus balance""",
      "descriptionDE": """"Die nutzbare Feldkapazität beinhaltet Information über die Textur des Bodens, die Gründigkeit und den Hu-musgehalt, steht für die Wasserspeicherfähigkeit und korreliert eng mit der potenziellen Nitratrückhaltekapa-zität. In Österreich sind diese Bodeneigenschaften der landwirtschaftlich genutzten Fläche kartiert.""",
      "section": FormSection.map_soil,
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
      "borderColor": MyColors.blue,
      'values': ['', 'standortgruppe_1_2', 'standortgruppe_3_4', 'standortgruppe_5_6'],
      'valuesEN': ['', 'site group 1, 2', 'site group 3, 4', 'site group 5, 6'],
      'valuesDE': ['', 'Standortgruppe 1, 2', 'Standortgruppe 3, 4', 'Standortgruppe 5, 6'],
      'valueMap': {
        "Klimaschutz": [null, 1, 3, 5],
      },
    },
    // gelände fields
    {
      'type': InputType.dropdown,
      'label': 'hang_position',
      "labelEN": "Position to the slope",
      "labelDE": "Position zum Hang",
      "descriptionEN": """Select the position to the slope""",
      "descriptionDE": """Die Themenkarte ist erreichbar auf https://bodenkarte.at/ über die Schaltflächen Kartensteuerung – Kartenap-plikationen – Bundesamt für Wasserwirtschaft – Nitrat und Feldkapazität. Liegt die Hecke auf zwei verschie-denen Flächen, ist grundsätzlich die größere Fläche zu wählen. Bei 50/50 wird das Ergebnis gemittelt (a und c wird zu b) – bei a und b wird der höhere Wert gewählt – in diesem Fall b.""",
      "section": FormSection.location,
      "subSectionEN": "Position and Characteristics",
      "subSectionDE": "Position und Eigenschaften",
      "borderColor": MyColors.coral,
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
      'type': InputType.dropdown,
      'label': 'hang_neigung',
      "labelEN": "Slope gradient",
      "labelDE": "Hangneigung",
      "descriptionEN": """Select the slope gradient""",
      "descriptionDE": """"Für die Bodenformen der österreichischen Bodenkarte wurde das Potenzial für Humusauf- und -abbau mittels der standortangepassten Humusbilanzierung nach Kolbe berechnet. Als Ergebnis wird dabei eine Standortgruppe zugewiesen:""",
      "section": FormSection.location,
      "subSectionEN": "Position and Characteristics",
      "subSectionDE": "Position und Eigenschaften",
      "borderColor": MyColors.coral,
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
      'type': InputType.dropdown,
      'label': 'netzwerk',
      "labelEN": "Network",
      "labelDE": "Netzwerk",
      "descriptionEN": """Select the network""",
      "descriptionDE": """-	Standortgruppe 1: Schwarzerden, Tonböden >700 mm Niederschlag/Jahr, Sandböden mit C/N-Verhältnissen >12;""",
      "section": FormSection.location,
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
      "borderColor": MyColors.coral,
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
      'type': InputType.dropdown,
      'label': 'erschliessung',
      "labelEN": "Accessibility",
      "labelDE": "Erschließung",
      "descriptionEN": """Select the access""",
      "descriptionDE": """-	Standortgruppe 2: Sand, anlehmiger Sand und lehmiger Sand unter 8,5 °C Temp., toniger Lehm, Tonbö-den; """,
      "section": FormSection.location,
      "subSectionEN": "Management and Connectivity",
      "subSectionDE": "Management und Vernetzung",
      "borderColor": MyColors.coral,
      'values': ['', 'weg_an_in_hecke', 'sichtbeziehung_zu_hecke', 'kein_weg'],
      'valuesEN': ['', 'path at/in hedge', 'line of sight to hedge', 'no path'],
      'valuesDE': ['', 'Weg an/in Hecke', 'Sichtbeziehung zu Hecke', 'Kein Weg'],
      'valueMap': {
        'Erholung & Tourismus': [null, 5, 3, 1],
      },
    },
    {
      'type': InputType.dropdown,
      'label': 'horizontale_schichtung',
      "labelEN": "Horizontal layering",
      "labelDE": "horizontale Schichtung",
      "descriptionEN": """Select the horizontal layering""",
      "descriptionDE": """-	Standortgruppe 3: Sand, anlehmiger Sand und lehmiger Sand über 8,5 °C Temp.;""",
      "section": FormSection.structure,
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
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
      "labelEN": "Vertical layering",
      "labelDE": "vertikale Schichtung",
      "descriptionEN": """Enter the vertical layering""",
      "descriptionDE": """-	Standortgruppe 4: stark sandiger Lehm und sandiger Lehm unter 8,5 °C Temp.;""",
      "section": FormSection.structure,
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
      "borderColor": MyColors.purple,
      'values': ['', 'nur_kernzone', 'nur_mantelzone', 'kern_und_mantelzone'],
      'valuesEN': ['', 'core zone only', 'mantle zone only', 'core and mantle zone'],
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
      "descriptionEN": """Enter the structural diversity""",
      "descriptionDE": """-	Standortgruppe 5: stark sandiger Lehm und sandiger Lehm, über 8,5 °C Temp.;""",
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
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
      "descriptionEN": """Enter the gaps""",
      "descriptionDE": """-	Standortgruppe 6: Lehmböden (KOLBE 2007).""",
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
      "descriptionEN": """Enter the deadwood""",
      "descriptionDE": """Die Themenkarte ist erreichbar auf https://bodenkarte.at/ über die Schaltflächen Kartensteuerung – Kartenapplikationen – Bioforschung Austria. Liegt die Hecke auf zwei verschiedenen Flächen, ist grundsätzlich die größere Fläche zu wählen. Bei 50/50 wird das Ergebnis gemittelt (a und c wird zu b) – bei a und b wird der höhere Wert gewählt – in diesem Fall b.""",
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'alterszusammensetzung',
      "labelEN": "Age composition",
      "labelDE": "Alterszusammensetzung",
      "descriptionEN": """Enter the age composition""",
      "descriptionDE": """Mit der Neigung des Geländes ändern sich viele Prozesse und Charakteristiken des Naturraums und auch der landwirtschaftlichen Bewirtschaftung. Hecken sind diesem Wirkungsgefüge ebenfalls unterworfen, was Aus-wirkungen auf ihr eigenes Gedeihen und die Flächen um sie herum hat. Neben der Neigung des Hangs (ei-genständiger Indikator) spielt die Position der Hecke im Hang eine Rolle.""",
      "section": FormSection.structure,
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'saum_art',
      "labelEN": "Margin type",
      "labelDE": "Saumart",
      "descriptionEN": """Enter the hem type""",
      "descriptionDE": """In Kombination mit dem Indikator Position zum Hang verstärkt oder vermindert die Neigung des Hangs dieselben Wirkungen. Erfasst wird sie durch Schätzen oder Messen vor Ort. Die Kartendarstellung am Computer kann als Anhalt herangezogen werden, die Klasseneinteilung ist jedoch nicht dieselbe.""",
      "section": FormSection.structure,
      "subSectionEN": "Structural Elements",
      "subSectionDE": "Strukturelemente",
      "borderColor": MyColors.purple,
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
      'type': InputType.dropdown,
      'label': 'saum_breite',
      "labelEN": "Margin width",
      "labelDE": "Saumbreite",
      "descriptionEN": """Enter the hem width""",
      "descriptionDE": """Hecken erfüllen ihre Ökosystemleistungen besser, wenn sie nicht isoliert stehen, sondern Teil eines Ver-bundsystems sind. Es wird die Anzahl der Verbindungen zu anderen Hecken oder Wald gezählt (0/1/>1). Dies ist sowohl am Computer als auch vor Ort im Feld möglich. Ist die Hecke Teil eines Rainnetzwerks, ist dies ebenfalls anzugeben. Mehrfachnennungen sind möglich.""",
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
      "descriptionEN": """Enter the height of the hedge""",
      "descriptionDE": """Voraussetzung für die Nutzung von Hecken zur Naherholung stellen Erschließungsstrukturen dar (PARACCHINI et al. 2014). Abgesehen von der allgemeinen Erreichbarkeit sind dafür begeh-/ befahrbare Weganlagen in oder entlang der Hecke notwendig. Dabei kann es sich sowohl um landwirtschaftliche Strukturen wie Wirt-schafts-, Feld- oder Hohlwege handeln, als auch um Wander-, Rad- oder Pilgerwege. Inoffizielle Erschlie-ßungsmöglichkeiten wie Trampelpfade werden ebenfalls berücksichtigt. Wege, für die ein Betretungsverbot besteht (Kennzeichnung vor Ort), werden gleichgesetzt mit fehlendem Weg. Eine Sichtbeziehung besteht dann, wenn vom Weg aus die Hecke gesehen werden kann. Straße und Hecke sind dann visuell miteinander verbunden.""",
      "section": FormSection.structure,
      "subSectionEN": "Dimensions",
      "subSectionDE": "Abmessungen",
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
      "descriptionEN": """Enter the width of the hedge""",
      "descriptionDE": """Die horizontale Schichtung fragt ab, wie sich die Schichtung in der Waagrechten darstellt, gibt es nur eine Baumschicht, sind Sträucher nicht vorhanden oder nur lückig, sodass man von keiner eigenen Schicht reden kann.""",
      "section": FormSection.structure,
      "subSectionEN": "Dimensions",
      "subSectionDE": "Abmessungen",
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
      "labelEN": "Percentage of trees",
      "labelDE": "Baumanteil",
      "descriptionEN": """Select the proportion of trees""",
      "descriptionDE": """Die vertikale Schichtung beschreibt den Aufbau einer Hecke im Querschnitt. Die Mantelzone ist der Bereich der Heckenseiten: er bekommt Licht und, vor allem südseitig, Wärme (RINGLER et al. 1997). Daher besteht er aus eher lichtbedürftigen Gebüschen, die oft bis unten belaubt sind. Eine Hecke, die keinen Mantel aufweist, schließt zur Seite hin nicht ab. Die Kernzone besteht vor allem bei älteren, breiteren Hecken und ist in ihrem Inneren dunkel und weitestgehend blattlos (SCHULZE et al. 1984). Eine Hecke ohne Kernzone ist meist schmal und/oder noch jung, sodass alle Pflanzen genügend Licht bekommen.""",
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
      "descriptionEN": """Select the number of wood species within 30m""",
      "descriptionDE": """Mit der Strukturvielfalt sind hier Breiten- und Höhenunterschiede in der Hecke gemeint. Sie werden über die Länge der Hecke hinweg geschätzt. Eine leichte Zu-/ Abnahme der Höhe oder Breite ist hier weniger ent-scheidend als größere Schwankungen in Höhe und/oder Breite.""",
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
      "labelEN": "Dominances",
      "labelDE": "Dominanzen",
      "descriptionEN": """Select the dominance level""",
      "descriptionDE": """Als Lücke zählt ein Loch im Kronendach. Abbildung 12 erläutert genauer, was als Lücke zählt und was nicht. Auch Lücken <1 m zählen. Für die Lücken werden zweierlei Dinge betrachtet: die Anwesenheit von Hecken größer 5 m sowie der Prozentsatz an Lücken bezogen auf die Heckenlänge. Ersteres ist lediglich mit ja oder nein zu beantworten: gibt es in der Hecke eine Einzellücke von >5 m, wird „A“ angegeben. Bei Zweiterem wird die Gesamtlänge aller vorhandenen Lücken <5 m als Prozentsatz der gesamten Heckenlänge angege-ben. Hierfür wird die Länge aller Lücken zusammengezählt, anschließend durch die Gesamtlänge der Hecke geteilt und dann mit 100 % multipliziert.""",
      "section": FormSection.plants,
      "subSectionEN": "Biodiversity Layers",
      "subSectionDE": "Biodiversitätsschichten",
      "borderColor": MyColors.green,
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
      'type': InputType.dropdown,
      'label': 'neophyten',
      "labelEN": "Neophytes",
      "labelDE": "Neophyten",
      "descriptionEN": """Select the percentage of neophytes""",
      "descriptionDE": """"Der Totholzanteil wird über die gesamte Hecke hinweg geschätzt. Es fließen sowohl Menge als auch Wertig-keit des Totholzes (stehendes ist besser als liegendes, dickes besser als dünnes) mit ein. Je nachdem, wie oft hier mit ‚Ja‘ geantwortet wird, wird der Indikator bewertet. Die Leitfragen sind: """,
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
      'section': FormSection.location,
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
      'section': FormSection.usage,
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
      'section': FormSection.usage,
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
      'section': FormSection.usage,
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
      'section': FormSection.structure,
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
  plants,
  map_location,
  map_soil,
  images
}

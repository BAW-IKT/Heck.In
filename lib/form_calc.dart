import 'dart:math';

class FormCalc {
  Map<String, dynamic> _radarChartData = {};

  Map<String, double> performCalculations(radarChartDataListsReduced) {
    _radarChartData = radarChartDataListsReduced;

    // rohstoffe - min 1, max 5, sum of values
    double rohstoffeSum = getGroupSum("Rohstoffe");
    rohstoffeSum = max(min(rohstoffeSum, 5), 1);

    // ertragssteigerung - if nachbarflächen > 0 = 1, else rounded mean
    double ertragNachbarValue =
    getItem("Ertragssteigerung", "nachbar_flaechen");
    double ertragssteigerungSum = ertragNachbarValue > 0
        ? getFixedGroupAverage("Ertragssteigerung", 4)
        : 1;

    // klimaschutz
    double klimaschutzSum = getGroupAverage("Klimaschutz");

    // wasserschutz
    List<double> wasserschutzHangValues =
    getList("Wasserschutz", ["hang_position", "hang_neigung"]);
    double wasserschutzHangSum = wasserschutzHangValues.reduce(min);
    List<double> wasserschutzFlaecheValues =
    getList("Wasserschutz", ["hecken_dichte", "hecken_breite"]);
    double wasserschutzFlaecheSum = wasserschutzFlaecheValues.reduce(max);
    List<double> wasserschutzSumValues = getList("Wasserschutz",
        ["horizontale_schichtung", "saum_breite", "nutzbare_feldkapazitaet"]);
    wasserschutzSumValues.addAll([wasserschutzHangSum, wasserschutzFlaecheSum]);
    double wasserschutzSum = getFixedAverage(wasserschutzSumValues, 4);

    // bodenschutz
    List<double> bodenschutzHangValues =
    getList("Bodenschutz", ["hang_position", "hang_neigung"]);
    double bodenschutzHangSum = bodenschutzHangValues.reduce(min);
    List<double> bodenschutzLageValues = getList("Bodenschutz",
        ["himmelsrichtung", "hecken_dichte", "klimatische_wasserbilanz"]);
    bodenschutzLageValues.add(bodenschutzHangSum);
    double bodenschutzLageSum = bodenschutzLageValues.reduce(max);
    List<double> bodenschutzSumValues =
    getList("Bodenschutz", ["luecken", "hecken_hoehe", "hecken_breite"]);
    bodenschutzSumValues.add(bodenschutzLageSum);
    double bodenschutzSum = getAverage(bodenschutzSumValues);

    // nähr- & schadstoffkreisläufe
    List<double> naehrstoffHangValues = getList(
        "Nähr- & Schadstoffkreisläufe", ["hang_position", "hang_neigung"]);
    double naehrstoffHangSum = naehrstoffHangValues.reduce(min);
    List<double> naehrstoffSumValues = getList("Nähr- & Schadstoffkreisläufe", [
      "nutzbare_feldkapazitaet",
      "totholz",
      "hecken_breite",
      "sonder_form",
      "nachbar_flaechen"
    ]);
    naehrstoffSumValues.add(naehrstoffHangSum);
    double naehrstoffSum = getFixedAverage(naehrstoffSumValues, 5);

    // bestäubung
    List<double> bestaeubungStrukturValues = getList(
        "Bestäubung", ["totholz", "alterszusammensetzung", "sonder_form"]);
    bestaeubungStrukturValues
        .add(getProduct("Bestäubung", ["saum_art", "saum_breite"]));
    double bestaebungStrukturSum =
    getFixedAverage(bestaeubungStrukturValues, 4, round: false);
    List<double> bestaeubungLageValues = getList(
        "Bestäubung", ["nachbar_flaechen", "netzwerk", "hecken_dichte"]);
    double bestaeubungLageSum = getSum(bestaeubungLageValues) / 2;
    List<double> bestaeubungPflanzenValues = getList(
        "Bestäubung", ["anzahl_gehoelz_arten", "dominanzen", "neophyten"]);
    double bestaeubungPflanzenSum = getAverage(bestaeubungPflanzenValues);
    List<double> bestaeubungNutzungValues =
    getList("Bestäubung", ["nutzungs_spuren", "management"]);
    double bestaeubungNutzungSum = getSum(bestaeubungNutzungValues);
    double bestaeubungSum = getSum([
      bestaebungStrukturSum,
      bestaeubungLageSum,
      bestaeubungPflanzenSum,
      bestaeubungNutzungSum
    ]);
    bestaeubungSum = bestaeubungSum / 3;
    bestaeubungSum = bestaeubungSum.roundToDouble();

    // schädlungs- & krankheitskontrolle
    List<double> schaedlingStrukturValues = getList(
        "Schädlings- & Krankheitskontrolle", [
      "horizontale_schichtung",
      "strukturvielfalt",
      "sonder_form",
      "luecken"
    ]);
    schaedlingStrukturValues.add(getProduct(
        "Schädlings- & Krankheitskontrolle", ["saum_art", "saum_breite"]));
    double schaedlingStrukturSum = getSum(schaedlingStrukturValues) / 3;
    schaedlingStrukturSum = min(5, schaedlingStrukturSum);
    List<double> schaedlingLageValues =
    getList("Schädlings- & Krankheitskontrolle", ["himmelsrichtung"]);
    schaedlingLageValues.add(getItem(
        "Schädlings- & Krankheitskontrolle", "hecken_dichte",
        multiplicator: 2));
    double schaedlingLageSum = getSum(schaedlingLageValues) / 3;
    schaedlingLageSum = min(5, schaedlingLageSum);
    List<double> schaedlingPflanzenValues = getList(
        "Schädlings- & Krankheitskontrolle", ["baumanteil", "neophyten"]);
    schaedlingPflanzenValues.add(getItem(
        "Schädlings- & Krankheitskontrolle", "anzahl_gehoelz_arten",
        multiplicator: 2));
    double schaedlingPflanzenSum = getSum(schaedlingPflanzenValues) / 3;
    schaedlingPflanzenSum = min(5, schaedlingPflanzenSum);
    double schaedlingSum = getAverage([
      schaedlingStrukturSum,
      schaedlingStrukturSum,
      schaedlingLageSum,
      schaedlingPflanzenSum
    ]);

    // Nahrungsquelle
    double nahrungsquelleStrukturSum =
    getProduct("Nahrungsquelle", ["saum_art", "saum_breite"]);
    nahrungsquelleStrukturSum += getItem("Nahrungsquelle", "totholz");
    nahrungsquelleStrukturSum = nahrungsquelleStrukturSum / 2;
    double nahrungsquellePflanzenSum = getAverage(
        getList("Nahrungsquelle",
            ["neophyten", "dominanzen", "anzahl_gehoelz_arten"]),
        round: false);
    double nahrungsquelleSum = getAverage([
      nahrungsquelleStrukturSum,
      nahrungsquellePflanzenSum,
      nahrungsquellePflanzenSum
    ]);

    // Korridor
    double korridorStrukturSum = getAverage(
        getList("Korridor", ["luecken", "hecken_hoehe", "hecken_breite"]),
        round: false);
    double korridorLageSum = getSum(getList(
        "Korridor", ["hecken_dichte", "in_wildtierkorridor", "netzwerk"])) /
        2;
    double korridorSum =
    getAverage([korridorStrukturSum, korridorLageSum, korridorLageSum]);

    // Fortpflanzungs- und Ruhestätte
    List<double> fortpflanzungsStukturValues =
    getList("Fortpflanzungs- & Ruhestätte", [
      "sonder_form",
      "alterszusammensetzung",
      "totholz",
      "strukturvielfalt",
      "vertikale_schichtung",
      "horizontale_schichtung",
      "hecken_hoehe",
      "hecken_breite"
    ]);
    fortpflanzungsStukturValues.add(getProduct(
        "Fortpflanzungs- & Ruhestätte", ["saum_art", "saum_breite"]));
    double fortpflanzungsStrukturSum = getSum(fortpflanzungsStukturValues) / 6;
    double fortpflanzungsLageSum = getSum(getList(
        "Fortpflanzungs- & Ruhestätte", ["hecken_dichte", "nachbar_flaechen"]));
    double fortpflanzungsPflanzenSum = getAverage(
        getList("Fortpflanzungs- & Ruhestätte",
            ["anzahl_gehoelz_arten", "dominanzen"]),
        round: false);
    double fortpflanzungsSum = getAverage([
      fortpflanzungsStrukturSum,
      fortpflanzungsStrukturSum,
      fortpflanzungsLageSum,
      fortpflanzungsPflanzenSum
    ]);

    // Erholung
    double erholungLandschaftSum = getSum(getList("Erholung & Tourismus", [
      "schutzgebiet",
      "hecken_dichte",
      "alterszusammensetzung",
      "anzahl_gehoelz_arten"
    ]));
    erholungLandschaftSum +=
        getProduct("Erholung & Tourismus", ["saum_art", "saum_breite"]);
    erholungLandschaftSum = erholungLandschaftSum / 4;
    double erholungMenschlichSum = getSum(getList("Erholung & Tourismus",
        ["bevoelkerungs_dichte", "erschliessung", "zusatz_strukturen"]));
    erholungMenschlichSum = min(erholungMenschlichSum / 2, 5);
    double erholungErschliessungVal =
    getItem("Erholung & Tourismus", "erschliessung");
    double erholungSum = erholungErschliessungVal == 1
        ? 1
        : getAverage([erholungMenschlichSum, erholungLandschaftSum]);

    // Kulturerbe
    double kulturerbeSum = getSum(getList("Kulturerbe", [
      // "naturdenkmal",
      "traditionelle_heckenregion",
      "franziszeischer_kataster",
      "netzwerk",
      "neophyten",
      "zusatz_strukturen",
      "sonder_form"
    ]));
    kulturerbeSum += getItem("Kulturerbe", "franziszeischer_kataster");
    kulturerbeSum = kulturerbeSum / 5;
    kulturerbeSum = min(kulturerbeSum, 5).roundToDouble();

    return {
      'Rohstoffe': rohstoffeSum,
      'Ertragssteigerung': ertragssteigerungSum,
      'Klimaschutz': klimaschutzSum,
      'Wasserschutz': wasserschutzSum,
      'Bodenschutz': bodenschutzSum,
      'Nähr- & Schadstoffkreisläufe': naehrstoffSum,
      'Bestäubung': bestaeubungSum,
      'Schädlings- & Krankheitskontrolle': schaedlingSum,
      'Nahrungsquelle': nahrungsquelleSum,
      'Korridor': korridorSum,
      'Fortpflanzungs- & Ruhestätte': fortpflanzungsSum,
      'Erholung & Tourismus': erholungSum,
      'Kulturerbe': kulturerbeSum,
    };
  }


  /// maps a Map<String, double> to List<double>
  List<double> mapToListOfDoubles(var map) {
    List<double> values = [];
    for (var elem in map.values) {
      values.add(elem.toDouble());
    }
    return values;
  }

  /// returns sum for a list of doubles
  double getSum(List<double> values, {bool round = true}) {
    double sum = values.reduce((v, e) => (v + e));
    if (!round) {
      return sum;
    }
    return sum.roundToDouble();
  }

  /// returns sum for all values of a group
  double getGroupSum(String group) {
    return getSum(mapToListOfDoubles(_radarChartData[group]));
  }

  /// returns average for a list of doubles
  double getAverage(List<double> values, {bool round = true}) {
    double average = values.reduce((v, e) => (v + e)) / values.length;
    if (!round) {
      return average;
    }
    return average.roundToDouble();
  }

  /// returns average for all values of a group
  double getGroupAverage(String group, {bool round = true}) {
    return getAverage(mapToListOfDoubles(_radarChartData[group]),
        round: round);
  }

  /// returns sum divided by divisor for a list of doubles
  double getFixedAverage(List<double> values, int divisor,
      {bool round = true}) {
    double fixedAverage = values.reduce((v, e) => (v + e)) / divisor;
    if (!round) {
      return fixedAverage;
    }
    return fixedAverage.roundToDouble();
  }

  /// returns sum divided by divisor for all values of a group
  double getFixedGroupAverage(String group, int divisor, {bool round = true}) {
    return getFixedAverage(
        mapToListOfDoubles(_radarChartData[group]), divisor,
        round: round);
  }

  /// returns a list of doubles from group and parameters
  List<double> getList(String group, List<String> parameters) {
    List<double> values = [];
    for (var entry in _radarChartData[group].entries) {
      if (parameters.contains(entry.key)) {
        values.add(entry.value.toDouble());
      }
    }
    return values;
  }

  /// Returns a single item from the map, allows multiplications
  double getItem(String group, String parameter, {multiplicator = 1}) {
    for (var entry in _radarChartData[group].entries) {
      if (entry.key == parameter) {
        return entry.value.toDouble() * multiplicator;
      }
    }
    return 0.0;
  }

  double getProduct(String group, List<String> parameters) {
    List<double> productValues = getList(group, parameters);
    if (productValues.isEmpty) {
      return 0.0;
    }
    return productValues.fold(
        1.0, (previousValue, element) => previousValue * element);
  }
}
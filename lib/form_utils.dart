import 'package:flutter/material.dart';
import 'package:hedge_profiler_flutter/form_data.dart';
import 'package:photo_view/photo_view.dart';

void doNothing() {}

int determineRequiredColumnsFromScreenWidth(var mediaQueryData) {
  final screenWidth = mediaQueryData.size.width;
  int columns = 1;
  if (screenWidth > 960) {
    columns = 5;
  } else if (screenWidth > 840) {
    columns = 4;
  } else if (screenWidth > 720) {
    columns = 3;
  } else if (screenWidth > 600) {
    columns = 2;
  }
  return columns;
}

Padding paddedWidget(Widget widget,
    {double horizontalPadding = 4.0, double verticalPadding = 4.0}) {
  return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: widget);
}

Column widgetWithBottomPadding(Widget widget) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      widget,
      const SizedBox(height: 16)
    ],
  );
}

Center createHeader(String headerText, {double fontSize = 24}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        headerText,
        style: TextStyle(fontSize: fontSize),
      ),
    ),
  );
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

class ToolTipDialog extends StatelessWidget {
  final String header;
  final String message;
  final String navigateToButtonText;
  final VoidCallback onNavigateTo;
  final String closeButtonText;
  final VoidCallback onClose;
  final bool createNavigateToButton;

  const ToolTipDialog(
      {Key? key,
      required this.header,
      required this.message,
      required this.navigateToButtonText,
      required this.onNavigateTo,
      required this.closeButtonText,
      required this.onClose,
      required this.createNavigateToButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actionsList = [];

    if (createNavigateToButton) {
      actionsList.add(
        TextButton(
            onPressed: onNavigateTo, child: Text(navigateToButtonText)),
      );
    }

    actionsList.add(TextButton(
      onPressed: onClose,
      child: Text(closeButtonText),
    ));

    return AlertDialog(
      title: Text(header),
      content: Text(message, textAlign: TextAlign.justify),
      // content: Linkify(
      //   onOpen: (link) async {
      //     if (!await launchUrl(Uri.parse(link.url))) {
      //       showSnackbar(context, "Could not launch ${link.url}",
      //           success: false);
      //     }
      //   },
      //   text: message,
      //   textAlign: TextAlign.justify,
      // ),
      actions: actionsList,
    );
  }
}

class LocaleMap {
  List<Map<String, dynamic>> formFields = [];
  List<Map<String, dynamic>> sections = [];

  void initialize(
      List<Map<String, dynamic>> formFields,
      List<Map<String, dynamic>> sections) {
    this.formFields = formFields;
    this.sections = sections;
  }

  Map<String, String> getLocaleToOriginal(String locale) {
    Map<String, String> map = {};

    if (locale.isEmpty) {
      return map;
    }

    if (locale == "null") {
      locale = "EN";
    }

    for (Map<String, dynamic> field in formFields) {
      map[field["label$locale"]] = field["label"];
      if (field.containsKey("values")) {
        for (int i = 0; i < field["values"].length; i++) {
          if (field["values"][i] == "") {
            continue;
          }
          map[field["values$locale"][i]] = field["values"][i];
        }
      }
    }

    for (Map<String, dynamic> sec in sections) {
      map[sec["label$locale"]] = sec["label"].toString();
    }

    return map;
  }

  Map<String, String> getOriginalToLocale(String locale) {
    Map<String, String> map = {};

    if (locale.isEmpty) {
      return map;
    }

    if (locale == "null") {
      locale = "EN";
    }

    for (Map<String, dynamic> field in formFields) {
      map[field["label"]] = field["label$locale"];
      if (field.containsKey("values")) {
        for (int i = 0; i < field["values"].length; i++) {
          if (field["values"][i] == "") {
            continue;
          }
          map[field["values"][i]] = field["values$locale"][i];
        }
      }
    }

    for (Map<String, dynamic> sec in sections) {
      map[sec["label"].toString()] = sec["label$locale"];
    }

    return map;
  }
}

Map<String, dynamic> filterAndSimplifySubmittedFormData(
    Map<String, dynamic> formData, LocaleMap localeMap) {
  String locale = formData["locale"];
  Map<String, String> translate = {
    "geo_latitude": locale == "EN" ? "Latitude" : "Breitengrad",
    "geo_longitude": locale == "EN" ? "Longitude" : "Längengrad",
    "form_submit_timestamp": locale == "EN" ? "Timestamp" : "Zeitpunkt",
  };

  Map<String, dynamic> filteredMap = {};

  // exclude certain fileds defined in form_data, translate certain fields
  for (var entry in formData.entries) {
    if (!excludedFieldsFromExport.contains(entry.key)) {
      String newKey =
          translate.containsKey(entry.key) ? translate[entry.key]! : entry.key;
      filteredMap[newKey] = entry.value;
    }
  }

  // bring in order of sections
  List<String> processed = [];
  Map<String, dynamic> orderedMapWithSections = {};
  for (Map<String, dynamic> sec in localeMap.sections) {
    if (sec["label"] == FormSection.images) {
      continue;
    }
    orderedMapWithSections[sec["label$locale"]] = null;  // header
    for (Map<String, dynamic> field in localeMap.formFields) {
      String fieldLabel = field["label"];
      if (field["section"] == sec["label"]
          && !excludedFieldsFromExport.contains(fieldLabel)) {
        // skips attaching anmerkungen in case its null (prevents creation of header)
        if (filteredMap[fieldLabel] != null) {
          orderedMapWithSections[fieldLabel] = filteredMap[fieldLabel];
        }
        processed.add(fieldLabel);
      }
    }
  }

  // add parameters that are not form inputs (geo coords)
  if (filteredMap.length > processed.length) {
    String variousHeader = locale == "EN" ? "Various" : "Diverses";
    orderedMapWithSections[variousHeader] = null;
    for (var filteredEntry in filteredMap.entries) {
      if (!processed.contains(filteredEntry.key)) {
        orderedMapWithSections[filteredEntry.key] = filteredEntry.value;
      }
    }
  }

  // SplayTreeMap<String, dynamic> sortedMap =
  //     SplayTreeMap<String, dynamic>.from(filteredMap);

  return orderedMapWithSections;
}

void validateSelectedValueOfDropdownFieldMatchesCurrentLocale(
    String locale, Map field) {
  String selectedValue = field["selectedValue"];
  if (selectedValue.isNotEmpty) {
    if (!field["values$locale"].contains(selectedValue)) {
      String otherLocale = locale == "EN" ? "DE" : "EN";
      int idxFromOtherLocalesList =
          field["values$otherLocale"].indexOf(selectedValue);
      if (idxFromOtherLocalesList != -1) {
        field["selectedValue"] =
        field["values$locale"][idxFromOtherLocalesList];
      }
    }
  }
}

class ImageView extends StatelessWidget {
  final String imagePath;

  const ImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: AssetImage(imagePath),
      )
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/widgets.dart';

class PdfCreator {
  late String filePath;
  Document pdf = Document();
  late Map<String, String> originalToLocale;
  late String currentLocale;

  // thats a constructor
  PdfCreator(this.originalToLocale, this.currentLocale);

  void addFormData(Map<String, dynamic> formData) {
    int rowsPerPage = 46;
    List<TableRow> rows = createRowsFromFormData(formData);
    addHeaderToRows(
        rows, currentLocale == "EN" ? "Input values" : "Eingabedaten");

    addPagesFromRows(rows, rowsPerPage, columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(1),
    });
  }

  List<TableRow> createRowsFromFormData(Map<String, dynamic> formData) {
    List<TableRow> rows = [];

    addDividerToRowsEnd(rows, 2);

    formData.forEach((key, value) {
      String translatedKey =
          originalToLocale.containsKey(key) ? originalToLocale[key]! : key;

      if (value == null) {
        // sections in bold (have null as value)
        rows.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            // adjust the value to your requirements
            child: Text(translatedKey,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            // adjust the value to your requirements
            child: Text(''),
          ),
        ]));
      } else if (value is List) {
        // nested lists of values
        for (var i = 0; i < value.length; i++) {
          String translatedItem = originalToLocale.containsKey(value[i])
              ? originalToLocale[value[i]]!
              : value[i];
          rows.add(TableRow(children: [
            i == 0 ? Text(translatedKey) : Text(''),
            Text(translatedItem),
          ]));
        }
      } else {
        // normal key-value pairs
        String translatedValue = originalToLocale.containsKey(value)
            ? originalToLocale[value]!
            : value;
        rows.add(TableRow(children: [
          Text(translatedKey),
          Text(translatedValue),
        ]));
      }
    });

    addDividerToRowsEnd(rows, 2);

    return rows;
  }

  void addDividerToRowsStart(List<TableRow> rows, int columns) {
    rows.insert(0, _buildDividerTableRow(columns));
  }

  void addDividerToRowsEnd(List<TableRow> rows, int columns) {
    rows.add(_buildDividerTableRow(columns));
  }

  TableRow _buildDividerTableRow(int columns) {
    return TableRow(
      children: List<Widget>.generate(
        columns,
        (index) => Divider(),
      ),
    );
  }

  void addImages(List<File> images) {
    for (int i = 0; i < images.length; i++) {
      final imageFile = images[i];
      final image = MemoryImage(imageFile.readAsBytesSync());
      int imageIndex = i + 1;
      pdf.addPage(
        Page(
          build: (Context context) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    currentLocale == "EN"
                        ? "Image $imageIndex"
                        : "Bild $imageIndex",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Divider(),
              Expanded(child: Center(child: Image(image))),
            ],
          ),
        ),
      );
    }
  }

  void addRadarChartDataDetailed(Map<String, dynamic> radarChartData) {
    int rowsPerPage = 48;
    List<TableRow> rows = createRowsFromRadarChartData(radarChartData);
    addHeaderToRows(
        rows,
        currentLocale == "EN"
            ? "Scores (Detailed)"
            : "Ergebnisse (Detailliert)");

    addPagesFromRows(rows, rowsPerPage, columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(1),
      2: const FlexColumnWidth(0.3)
    });
  }

  void addRadarChartDataOverview(Map<String, dynamic> radarChartData) {
    int rowsPerPage = 20;
    List<TableRow> rows = radarChartData.entries
        .map((entry) =>
            TableRow(children: [Text(entry.key), Text(entry.value.toString())]))
        .toList();
    addDividerToRowsStart(rows, 2);
    addDividerToRowsEnd(rows, 2);
    addHeaderToRows(rows,
        currentLocale == "EN" ? "Scores (Overview)" : "Ergebnisse (Überblick)");
    addPagesFromRows(rows, rowsPerPage, columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(1)
    });
  }

  List<TableRow> createRowsFromRadarChartData(
      Map<String, dynamic> radarChartData) {
    List<TableRow> rows = [];
    for (var group in radarChartData.entries) {
      bool groupNameWritten = false;
      group.value.entries.forEach((parameter) {
        // divider before actual content at beginning of group
        if (!groupNameWritten) {
          addDividerToRowsEnd(rows, 3);
        }
        rows.add(
          TableRow(children: [
            Text(groupNameWritten ? "" : group.key),
            Text(originalToLocale[parameter.key]!),
            Text(parameter.value.toString()),
          ]),
        );
        groupNameWritten = true;
      });
    }

    addDividerToRowsEnd(rows, 3);

    return rows;
  }

  void addHeaderToRows(List<TableRow> rows, String headerText) {
    rows.insert(
        0,
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Text(headerText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ]));
  }

  void addPagesFromRows(List<TableRow> rows, int rowsPerPage,
      {required Map<int, TableColumnWidth> columnWidths}) {
    for (int i = 0; i < rows.length; i += rowsPerPage) {
      pdf.addPage(Page(
          build: (Context context) => Table(
              columnWidths: columnWidths,
              children: rows.sublist(
                  i,
                  i + rowsPerPage > rows.length
                      ? rows.length
                      : i + rowsPerPage))));
    }
  }

  void addRadarChartGraph(Uint8List? graphAsImage) {
    if (graphAsImage == null) {
      return;
    }
    final image = MemoryImage(graphAsImage);
    pdf.addPage(Page(
      build: (Context context) => Center(
        child: Image(image),
      ),
    ));
  }

  void saveToFileAndOpenPDF() async {
    final path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    DateFormat dateFormat = DateFormat("yyyyMMdd_HHmmss");
    filePath = "$path/hedge_profiler_${dateFormat.format(DateTime.now())}.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(filePath);
  }
}

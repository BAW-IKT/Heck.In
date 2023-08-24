import 'dart:io';
import 'dart:typed_data';
import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/widgets.dart';

class PdfCreator {
  late String filePath;
  Document pdf = Document();

  PdfCreator();

  List<TableRow> processFormData(
      Map<String, dynamic> formData, Map<String, String> originalToLocale) {
    List<TableRow> rows = [];

    formData.forEach((key, value) {
      String translatedKey =
          originalToLocale.containsKey(key) ? originalToLocale[key]! : key;

      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          String translatedItem = originalToLocale.containsKey(value[i])
              ? originalToLocale[value[i]]!
              : value[i];
          rows.add(TableRow(children: [
            // Add key for the first row only
            i == 0 ? Text(translatedKey) : Text(''),
            Text(translatedItem),
          ]));
        }
      } else {
        String translatedValue = originalToLocale.containsKey(value)
            ? originalToLocale[value]!
            : value;
        rows.add(TableRow(children: [
          Text(translatedKey),
          Text(translatedValue),
        ]));
      }
    });

    return rows;
  }

  void addFormData(
      Map<String, dynamic> formData, Map<String, String> originalToLocale) {
    pdf.addPage(Page(
        build: (Context context) => Table(columnWidths: {
              0: const FlexColumnWidth(1),
              1: const FlexColumnWidth(1),
            }, children: processFormData(formData, originalToLocale))));
  }

  void addImages(List<File> images) {
    for (File imageFile in images) {
      final image = MemoryImage(imageFile.readAsBytesSync());
      pdf.addPage(Page(
        build: (Context context) => Center(
          child: Image(image),
        ),
      ));
    }
  }

  void addRadarChartData() {

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

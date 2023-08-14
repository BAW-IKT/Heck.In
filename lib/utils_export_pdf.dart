import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/widgets.dart';

class PdfCreator {
  final Map<String, dynamic> formData;
  final Map<String, String> originalToLocale;
  final List<File> images;
  late String filePath;
  late Document pdf;

  PdfCreator(this.formData, this.originalToLocale, this.images);

  List<TableRow> processFormData() {
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

  Future<void> createAndOpenPDF() async {
    pdf = Document();
    _addFormData();
    _addImages();
    saveToFileAndOpenPDF();
  }

  void _addFormData() {
    pdf.addPage(Page(
        build: (Context context) => Table(columnWidths: {
              0: const FlexColumnWidth(1),
              1: const FlexColumnWidth(1),
            }, children: processFormData())));
  }

  void _addImages() {
    for (File imageFile in images) {
      final image = MemoryImage(imageFile.readAsBytesSync());
      pdf.addPage(Page(
        build: (Context context) => Center(
          child: Image(image),
        ),
      ));
    }
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

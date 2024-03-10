import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';

import 'colors.dart';

class PdfFileList extends StatefulWidget {
  final String currentLocale;
  final bool darkMode;

  const PdfFileList({
    super.key,
    required this.currentLocale,
    required this.darkMode,
  });

  @override
  _PdfFileListState createState() => _PdfFileListState();
}

class _PdfFileListState extends State<PdfFileList> {
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _listPdfFiles();
  }

  Future<void> _listPdfFiles() async {
    final path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    Directory directory = Directory(path);
    setState(() {
      _files = directory.listSync().where((file) {
        return file.path.endsWith('.pdf');
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasExistingPdfFiles = _files.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentLocale == "EN"
            ? "Hedge Rating History"
            : "Hecken Bewertungs Verlauf"),
      ),
      body: Column(
        children: <Widget>[
          const Divider(
            height: 1,
            color: MyColors.black,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: hasExistingPdfFiles
                  ? createListOfExistingHedgePdfs()
                  : noHedgesYetText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget noHedgesYetText() {
    return Text(
        widget.currentLocale == "EN"
            ? "No hedge reviews available yet. Get started by rating your first hedge and manage all your results here!"
            : "Bisher sind keine Heckenbewertungen vorhanden. Beginnen Sie mit der Bewertung Ihrer ersten Hecke und verwalten Sie hier alle Ihre Ergebnisse!",
        style: const TextStyle(color: MyColors.black, fontSize: 16));
  }

  Widget createListOfExistingHedgePdfs() {
    return ListView.separated(
      itemCount: _files.length,
      itemBuilder: (context, index) {
        String fileName = _files[index].path.split("/").last;

        return ListTile(
          title: sanitizeFileName(fileName),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.folder,
                  color: MyColors.green,
                ),
                onPressed: () {
                  OpenFile.open(_files[index].path);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: MyColors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(widget.currentLocale == "EN"
                            ? "Delete Rating"
                            : "Bewertung Löschen"),
                        content: Text(widget.currentLocale == "EN"
                            ? "Please confirm if you want to delete the following file:\n\n $fileName"
                            : "Bitte bestätigen, dass sie die folgende Datei löschen möchten:\n\n $fileName"),
                        actions: <Widget>[
                          TextButton(
                            child: Text(widget.currentLocale == "EN"
                                ? "Cancel"
                                : "Abbrechen"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(widget.currentLocale == "EN"
                                ? "Confirm"
                                : "Bestätigen"),
                            onPressed: () {
                              File(_files[index].path).delete();
                              _listPdfFiles();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Text sanitizeFileName(String fileName) {
    try {
      List<String> dateStringArray = fileName
          .replaceFirst("hedge_profiler_", "")
          .replaceFirst(".pdf", "")
          .split("_");
      String date = formatDate(dateStringArray[0]);
      String time = formatTime(dateStringArray[1]);
      return Text("$date $time");
    } catch (e) {
      return Text(fileName);
    }
  }

  String formatDate(String dateStr) {
    return "${dateStr.substring(6, 8)}.${dateStr.substring(4, 6)}.${dateStr.substring(0, 4)}";
  }

  String formatTime(String timeStr) {
    String time = timeStr.padLeft(6, '0');
    return "${time.substring(0, 2)}:${time.substring(2, 4)}:${time.substring(4, 6)}";
  }
}

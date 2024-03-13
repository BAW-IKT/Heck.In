import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// creates a document based on the given arguments
/// returns a tuple (bool, String) with success status and message
Future<void> writeDocument(Map<String, dynamic> formData, List<File> images,
    Function(bool, String, Map<String, dynamic>) onResult) async {
  try {
    Map<String, dynamic> documentData = await writeToMongoDb(images, formData);
    onResult(true, "success", formData);
  } catch (e) {
    onResult(false, "$e", {});
  }
}

Future<Map<String, dynamic>> writeToMongoDb(
    List<File> images, Map<String, dynamic> formData) async {
  Map<String, dynamic> documentData = {};
  for (var entry in formData.entries) {
    documentData[entry.key] = entry.value;
  }

  List<Uint8List> encodedImageList = [];
  for (File image in images) {
    Uint8List imageData = await loadImageAsBytes(image.path);
    encodedImageList.add(imageData);
  }

  // TODO: ensure all data is there (raw, consolidated)
  documentData["images"] = encodedImageList;
  documentData["form_submit_timestamp"] = DateTime.now();

  var db = await Db.create(dotenv.get("DB_URI"));
  await db.open();

  DbCollection collection = db.collection("hedges");
  await collection.insert(documentData);
  await db.close();

  return documentData;
}

Future<Uint8List> loadImageAsBytes(String imagePath) async {
  var imageFile = File(imagePath);
  Uint8List imageBytes = await imageFile.readAsBytes();
  return imageBytes;
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// creates a document based on the given arguments
/// returns a tuple (bool, String) with success status and message
Future<void> writeDocument(
    Map<String, dynamic> formData,
    Map<String, dynamic> radarDataFull,
    Map<String, dynamic> radarDataReduced,
    List<File> images,
    Function(bool, String, Map<String, dynamic>) onResult) async {
  Map<String, dynamic> transaction =
      await writeToMongoDb(images, formData, radarDataFull, radarDataReduced);
  onResult(transaction["success"], transaction["message"], transaction["data"]);
}

Future<Map<String, dynamic>> writeToMongoDb(
  List<File> images,
  Map<String, dynamic> formData,
  Map<String, dynamic> radarDataFull,
  Map<String, dynamic> radarDataReduced,
) async {
  const timeout = Duration(seconds: 10);
  String message = "";
  bool success = false;

  Map<String, dynamic> data = {};
  Map<String, dynamic> dbData = {
    "form_data": {},
    "graph_data_full": radarDataFull,
    "graph_data_reduced": radarDataReduced,
    "images": [],
  };

  for (var entry in formData.entries) {
    data[entry.key] = entry.value;
    dbData["form_data"][entry.key] = entry.value;
  }

  Db? db;

  try {
    message = "Failed to encode images";
    List<Uint8List> encodedImageList = [];
    for (File image in images) {
      Uint8List imageData = await loadImageAsBytes(image.path);
      encodedImageList.add(imageData);
      dbData["images"].add(imageData);
    }

    data["images"] = encodedImageList;
    DateTime timeStamp = DateTime.now();
    data["form_submit_timestamp"] = timeStamp.toString();
    dbData["timestamp"] = timeStamp;

    message = "Failed to connect to database";
    db = await Db.create(dotenv.get("DB_URI")).timeout(timeout);

    message = "Failed to open database";
    await db.open().timeout(timeout);

    DbCollection collection = db.collection("hedges");

    message = "Failed to insert document data";
    await collection.insert(dbData).timeout(timeout);

    message = "Failed to close database connection";
    await db.close().timeout(timeout);

    message = "Success";
    success = true;
  } catch (e) {
    message = "$message: $e";
  } finally {
    if (db != null) {
      await db.close().timeout(timeout);
    }
  }

  return {
    "data": data,
    "success": success,
    "message": message,
  };
}

Future<Uint8List> loadImageAsBytes(String imagePath) async {
  var imageFile = File(imagePath);
  Uint8List imageBytes = await imageFile.readAsBytes();
  return imageBytes;
}

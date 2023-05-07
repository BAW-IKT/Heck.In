import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

String collectionName = "hedge_profiles";

/// returns all documents from the collection
Future<List<DocumentSnapshot>> getAllDocuments() async {
  List<DocumentSnapshot> documents = [];
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collectionName).get();
  for (var doc in snapshot.docs) {
    documents.add(doc);
  }
  return documents;
}

/// creates a document based on the given arguments
/// returns a tuple (bool, String) with success status and message
Future<void> writeDocument(
    String name,
    String latitude,
    String longitude,
    List<File> images,
    DateTime timestamp,
    Function(bool, String) onResult) async {
  try {
    // Get a reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection(collectionName);

    // Create a new document with a unique ID
    final document = collection.doc();

    // Upload images to Firebase Storage and get download URLs
    List<String> downloadUrls = [];
    for (File image in images) {
      String imageName = path.basename(image.path);
      // saves images into folder images/2023-05-07/NAME
      Reference imageRef = FirebaseStorage.instance.ref().child(
          'images/${timestamp.toString().split(" ")[0]}/$name/$imageName');
      await imageRef.putFile(image);
      String downloadUrl = await imageRef.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    // Set the data for the new document
    await document.set({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'images': downloadUrls,
      'timestamp': timestamp,
    });

    // Call the callback function with success status and message
    onResult(true, 'Document saved successfully.');
  } catch (e) {
    // Call the callback function with error status and message
    onResult(false, 'Error saving document: $e');
  }
}


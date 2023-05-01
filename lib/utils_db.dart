import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

// /// returns the current amount of documents in the collection
// Future<int> getDocumentCounts() async {
//   Stream<QuerySnapshot> snapshots =
//       FirebaseFirestore.instance.collection(collectionName).snapshots();
//   return snapshots.length;
// }

/// creates a document based on the given arguments
/// returns a tuple (bool, String) with success status and message
Future<void> writeDocument(String name, String latitude, String longitude,
    DateTime timestamp, Function(bool, String) onResult) async {
  try {
    // onResult(false, 'ERROR TEST');
    // Get a reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection(collectionName);

    // Create a new document with a unique ID
    final document = collection.doc();

    // Set the data for the new document
    await document.set({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    });

    // Call the callback function with success status and message
    // int docCounts = await getDocumentCounts();
    onResult(true, 'Document saved successfully.');
  } catch (e) {
    // Call the callback function with error status and message
    onResult(false, 'Error saving document: $e');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';

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

Future<String> signInAnonymousUserAndGetUID() async{
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  if (auth.currentUser == null) {
    UserCredential userCredential = await auth.signInAnonymously();
    user = userCredential.user!;
  } else {
    user = auth.currentUser!;
  }
  return user.uid;
}

/// creates a document based on the given arguments
/// returns a tuple (bool, String) with success status and message
Future<void> writeDocument(
    Map<String, dynamic> formData,
    List<File> images,
    Function(bool, String) onResult) async {
  try {
    // Sign in anonymously
    String uid = await signInAnonymousUserAndGetUID();

    // Get a reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection(collectionName);

    // Create a new document with a unique ID
    final document = collection.doc();
    DateTime timestamp = DateTime.now();

    // Upload images to Firebase Storage and get download URLs
    List<String> downloadUrls = [];
    for (File image in images) {
      String imageName = path.basename(image.path);
      Reference imageRef = FirebaseStorage.instance.ref().child('$uid/$imageName');
      await imageRef.putFile(image);
      String downloadUrl = await imageRef.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    // Set the data for the new document
    // populate formdata, images, timestamp and geo coords
    Map<String, dynamic> documentData = {};
    for (var entry in formData.entries) {
      documentData[entry.key] = entry.value;
    }
    documentData['images'] = downloadUrls;
    documentData['form_submit_timestamp'] = timestamp.toString();
    documentData['uid'] = uid;
    await document.set(documentData);

    // Call the callback function with success status and message
    onResult(true, 'success');
  } catch (e) {
    // Call the callback function with error status and message
    onResult(false, '$e');
  }
}

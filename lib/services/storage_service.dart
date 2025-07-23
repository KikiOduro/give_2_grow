import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';

// This service handles uploading files (like receipt images) to Firebase Storage
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance; // Access the Firebase Storage instance

  /// Uploads a receipt image to Firebase Storage under a specific user's folder
  /// Returns the public download URL of the uploaded image
  Future<String> uploadReceiptImage(String userId, File imageFile) async {
    try {
      // Use current timestamp as a unique filename (avoids overwrites)
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Define the storage path: receipts/userId/timestamp.jpg
      final ref = _storage.ref().child('receipts/$userId/$fileName.jpg');

      // Upload the image file to Firebase
      final uploadTask = await ref.putFile(imageFile);

      // Get the public URL for the uploaded image
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      log('Error uploading image: $e'); // Log the error for debugging
      return ''; // Return empty string if upload fails
    }
  }
}

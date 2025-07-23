import 'package:cloud_firestore/cloud_firestore.dart';

// This class represents a school that can receive donations
class School {
  final String id;            // The unique document ID from Firestore
  final String name;          // Name of the school
  final String location;      // City or region where the school is located
  final String imageUrl;      // URL to an image representing the school
  final String description;   // Brief info about the school's needs or mission

  // Constructor to create a School object
  School({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.description,
  });

  // Factory method to create a School object from a Firestore document
  factory School.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Cast document data to a map
    return School(
      id: doc.id,                         // Use Firestore document ID as the school ID
      name: data['name'] ?? '',           // If 'name' is missing, use an empty string
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '', // Load description (important for showing school needs)
    );
  }
}

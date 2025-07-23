import 'package:cloud_firestore/cloud_firestore.dart';

// This class represents a single donation made by a user
class Donation {
  final String id; // Unique ID for the donation (e.g., Firestore doc ID)
  final String userId; // ID of the user who made the donation
  final String schoolId; // ID of the school receiving the donation
  final List<Map<String, dynamic>> items; // List of items donated (with details like name and amount)
  final DateTime timestamp; // When the donation was made
  final String userEmail; // Donor's email address
  final String userName; // Donor's name (used for display purposes)
  final String status; // Donation status: Pending, Completed, etc.

  // Constructor to create a Donation object
  Donation({
    required this.id,
    required this.userId,
    required this.schoolId,
    required this.items,
    required this.timestamp,
    required this.userEmail,
    required this.userName,
    this.status = 'Pending', // Default status is 'Pending'
  });

  // Converts this Donation object into a map that can be saved to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'schoolId': schoolId,
      'items': items,
      'timestamp': timestamp.toIso8601String(), // Save as string for readability
      'userEmail': userEmail,
      'userName': userName,
      'status': status,
    };
  }

  // Factory constructor: Creates a Donation object from Firestore data
  factory Donation.fromMap(String id, Map<String, dynamic> map) {
    return Donation(
      id: id,
      userId: map['userId'] ?? '', // Fallback to empty string if null
      schoolId: map['schoolId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []), // Safely cast list of item maps
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(), // Convert Firestore timestamp to Dart DateTime
      userEmail: map['userEmail'] ?? '',
      userName: map['userName'] ?? 'Unknown', // Default to 'Unknown' if missing
      status: map['status'] ?? 'Pending',
    );
  }
}

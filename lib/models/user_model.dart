// This class represents a user in the GiveToGrow app
class UserModel {
  final String id;              // Unique ID for the user (e.g., from Firestore)
  final String name;            // Full name of the user
  final String email;           // Email address used for login and communication
  final double totalDonated;    // Tracks the total amount this user has donated

  // Constructor to create a UserModel object
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.totalDonated = 0.0,    // Starts at 0.0 if not specified
  });

  // Converts the user object into a map so it can be saved to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'totalDonated': totalDonated,
    };
  }

  // Factory constructor to create a user from Firestore data
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id, // ID is usually the document ID in Firestore
      name: map['name'], // Assumes 'name' is always present
      email: map['email'], // Assumes 'email' is always present
      totalDonated: (map['totalDonated'] ?? 0).toDouble(), // Converts to double just in case
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/school_model.dart';
import '../models/donation_model.dart';

// This service class handles all Firestore interactions for users, schools, needs, and donations
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  /// Creates or updates a user document in the 'users' collection
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  /// Retrieves a single user by their userId from the 'users' collection
  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.id, doc.data()!);
    }
    return null; // Return null if user doesn't exist
  }



  /// Retrieves all schools stored in the 'schools' collection
  Future<List<School>> fetchSchools() async {
    try {
      final snapshot = await _db.collection('schools').get();
      return snapshot.docs.map((doc) => School.fromFirestore(doc)).toList();
    } catch (e) {
      // If something goes wrong, return an empty list instead of crashing
      return [];
    }
  }



  /// Gets a list of needs (items requested) for a specific school
  Future<List<Map<String, dynamic>>> fetchNeedsForSchool(String schoolId) async {
    final snapshot = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('needs')
        .get();

    // Add the document ID to each item for easier use in the app
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  /// Saves a donation made by a user into the 'donations' collection
  Future<void> recordDonation(Donation donation) async {
    await _db.collection('donations').doc(donation.id).set(donation.toMap());
  }

  /// Retrieves all donations made by a specific user, sorted by newest first
  Future<List<Donation>> getUserDonations(String userId) async {
    final snapshot = await _db
        .collection('donations')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            Donation.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Retrieves all donations in the system (useful for admin or analytics)
  Future<List<Donation>> fetchDonations() async {
    final snapshot = await _db
        .collection('donations')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            Donation.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}

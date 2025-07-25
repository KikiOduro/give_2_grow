import 'package:firebase_auth/firebase_auth.dart';

// This class handles all authentication-related tasks using FirebaseAuth
class AuthService {
  // Create an instance of FirebaseAuth to interact with Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Logs in a user using their email and password
  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user; // Returns the logged-in user
  }

  // Registers a new user with an email and password
  Future<User?> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(//auth is the firebase authentication controller
      email: email,
      password: password,
    );
    return result.user; // Returns the newly created user
  }

  // Signs out the currently logged-in user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // A stream that notifies the app when the user's login state changes
  // (e.g., login, logout, or app restart)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

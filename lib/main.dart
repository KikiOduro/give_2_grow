import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';// Contains platform-specific Firebase config

void main() async {
  // Ensures all Flutter bindings are initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase with platform-specific config
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Launch the app
  runApp(const MyApp());
}

// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GiveToGrow', // App title
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green, // Base color for theming
      ),
      debugShowCheckedModeBanner: false, // Hides the "debug" label

      //  Register all named routes used across the app
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },

      // Decide what screen to show first based on auth status
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen for login/logout
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking auth state, show a loading spinner
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            // User is logged in → go to Home screen
            return const HomeScreen();
          } else {
            // User is not logged in → go to Login screen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

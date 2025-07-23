import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../auth/login_screen.dart';
import '../profile/past_donations.dart';

// This screen displays user profile information, daily quote, and past donations
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  String dailyQuote = 'Loading quote...';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch stored user name/email from SharedPreferences
    _loadQuote();    // Fetch quote of the day from ZenQuotes API
  }

  // Load user name and email from local storage
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'No Name';
      userEmail = prefs.getString('user_email') ?? 'No Email';
    });
  }

  // Fetch daily motivational quote from ZenQuotes API
  Future<void> _loadQuote() async {
    try {
      final res = await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          dailyQuote = '${data[0]['q']} — ${data[0]['a']}';
        });
      } else {
        setState(() {
          dailyQuote = 'Could not fetch quote.';
        });
      }
    } catch (e) {
      setState(() {
        dailyQuote = 'Error fetching quote.';
      });
    }
  }

  // Generate a unique DiceBear avatar URL based on user email
  String getDiceBearAvatarUrl(String email) {
    final encodedEmail = Uri.encodeComponent(email.trim().toLowerCase());
    return 'https://api.dicebear.com/7.x/micah/png?seed=$encodedEmail';
  }

  // Logout the user and return to Login screen
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF88A48A),
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Avatar (auto-generated using DiceBear)
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFDCEFE4),
                backgroundImage: NetworkImage(getDiceBearAvatarUrl(userEmail)),
              ),
              const SizedBox(height: 12),

              // Display user name
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5843),
                ),
              ),

              // Display user email
              Text(
                userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // Daily motivational quote
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F3EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dailyQuote,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Button to view past donations
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PastDonationsScreen()),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('View Past Donations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF88A48A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const Spacer(),

              // Logout button at the bottom
              TextButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

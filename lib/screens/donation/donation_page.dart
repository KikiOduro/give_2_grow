import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/school_model.dart';
import '../../models/donation_model.dart';
import 'cart_screen.dart';

// This page allows the user to select donation items and amounts for a specific school
class DonationPage extends StatefulWidget {
  final School school; // The school the user is donating to

  const DonationPage({super.key, required this.school});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  // A list to hold the user's selected donation items
  final List<Map<String, dynamic>> donationItems = [];

  // Text controllers for item name and amount input
  final itemController = TextEditingController();
  final amountController = TextEditingController();

  // Donor details retrieved from SharedPreferences
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user info when the screen is initialized
  }

  // Retrieves the user's name and email from local storage
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Anonymous';
      userEmail = prefs.getString('user_email') ?? 'unknown@example.com';
    });
  }

  // Adds an item to the donation list if valid
  void addItem() {
    final item = itemController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (item.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        donationItems.add({'item': item, 'amount': amount});
        itemController.clear();
        amountController.clear();
      });
    }
  }

  // Creates a Donation object and navigates to the cart screen
  void goToCart() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    final donation = Donation(
      id: const Uuid().v4(), // Generate a unique ID for the donation
      userId: userId,
      schoolId: widget.school.id,
      items: donationItems,
      timestamp: DateTime.now(),
      userEmail: userEmail,
      userName: userName,
    );

    // Navigate to the cart screen with the donation details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(
          donation: donation,
          userName: userName,
          userEmail: userEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Items to Donate')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input field for donation item name
            TextField(
              controller: itemController,
              decoration: const InputDecoration(labelText: 'Item'),
            ),
            const SizedBox(height: 10),

            // Input field for donation amount (in Ghana cedis)
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₵)'),
            ),
            const SizedBox(height: 20),

            // Add item button
            ElevatedButton(
              onPressed: addItem,
              child: const Text('Add Item'),
            ),
            const SizedBox(height: 20),

            // List of added donation items
            Expanded(
              child: ListView.builder(
                itemCount: donationItems.length,
                itemBuilder: (context, index) {
                  final item = donationItems[index];
                  return ListTile(
                    title: Text(item['item']),
                    trailing: Text('₵${item['amount']}'),
                  );
                },
              ),
            ),

            // Review & confirm button (disabled if no items)
            ElevatedButton(
              onPressed: donationItems.isEmpty ? null : goToCart,
              child: const Text('Review & Confirm Donation'),
            ),
          ],
        ),
      ),
    );
  }
}

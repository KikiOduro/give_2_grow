import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/school_model.dart';
import '../../models/donation_model.dart';
import '../donation/cart_screen.dart';

// This screen shows details about a selected school
// and allows the user to add donation items for that school.
class SchoolDetailScreen extends StatefulWidget {
  final School school;

  const SchoolDetailScreen({super.key, required this.school});

  @override
  State<SchoolDetailScreen> createState() => _SchoolDetailScreenState();
}

class _SchoolDetailScreenState extends State<SchoolDetailScreen> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  List<Map<String, dynamic>> donationItems = []; // List of donation items
  String userName = '';     // Donor's name from SharedPreferences
  String userEmail = '';    // Donor's email from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load donor info on screen load
  }

  // Load user name and email from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Anonymous';
      userEmail = prefs.getString('user_email') ?? 'unknown@example.com';
    });
  }

  // Add item to the donation cart
  void _addItem() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    final item = itemController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (item.isNotEmpty && amount != null) {
      setState(() {
        donationItems.add({'item': item, 'amount': amount});
        itemController.clear();
        amountController.clear();
      });
    }
  }

  // Create a Donation object and go to CartScreen
  void _goToCart() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    final donation = Donation(
      id: const Uuid().v4(), // Unique ID for the donation
      userId: userId,
      schoolId: widget.school.id,
      items: donationItems,
      timestamp: DateTime.now(),
      userEmail: userEmail,
      userName: userName,
    );

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
    final school = widget.school;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4), // Soft green background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6FBF4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // Back button color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App logo at the top
              Center(
                child: Image.asset(
                  'assets/login.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 16),

              // School name and location
              Text(
                school.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Text(
                school.location,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7F8C8D),
                ),
              ),
              const SizedBox(height: 16),

              // School description
              Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    school.description.isNotEmpty
                        ? school.description
                        : 'No description available.',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section to add donation items
              const Text(
                'Add Donation Item',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: itemController,
                decoration: InputDecoration(
                  labelText: 'Item',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₵)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),

              // Add to Cart Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF88A48A),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add to Cart'),
              ),
              const SizedBox(height: 20),

              // Donation cart preview
              Text(
                'Donation Cart (${donationItems.length} items)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              donationItems.isEmpty
                  ? const Center(child: Text('No items added yet.'))
                  : ListView.builder(
                      itemCount: donationItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        final item = donationItems[index];
                        return ListTile(
                          title: Text(item['item']),
                          trailing: Text('₵${item['amount']}'),
                        );
                      },
                    ),
              const SizedBox(height: 20),

              // Donate Now button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF88A48A),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: donationItems.isNotEmpty ? _goToCart : null,
                child: const Text('Donate Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

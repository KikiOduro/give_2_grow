import 'package:flutter/material.dart';
import '../../models/donation_model.dart';
import '../donation/thank_you_screen.dart';
import '../../services/firestore_service.dart';

// This screen displays the user's donation cart and allows them to confirm the donation
class CartScreen extends StatelessWidget {
  final Donation donation;    // Donation object containing items, school ID, etc.
  final String userName;      // Donor's name
  final String userEmail;     // Donor's email

  const CartScreen({
    super.key,
    required this.donation,
    required this.userName,
    required this.userEmail,
  });

  // Calculates the total donation amount by summing all item amounts
  double getTotalAmount() {
    return donation.items.fold(
      0.0,
      (sum, item) => sum + (item['amount'] ?? 0.0),
    );
  }

  // Submits the donation to Firestore and navigates to the Thank You screen
  void _submitDonation(BuildContext context) async {
    try {
      await FirestoreService().recordDonation(donation); // Save to Firestore

      if (!context.mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation submitted successfully!')),
      );

      // Navigate to Thank You screen and clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ThankYouScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      // Show error if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = getTotalAmount();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FDF8), // Light background for a clean feel
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B614D), // Deep green app bar
        title: const Text('Your Donation Cart'),
      ),
      body: Column(
        children: [
          // Header with gradient background showing school and donor info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4B614D), Color(0xFFD4AF37)], // Green to gold gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.volunteer_activism, color: Colors.white, size: 30),
                const SizedBox(height: 8),
                Text(
                  'School ID: ${donation.schoolId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Donor: $userName',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Donation Items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF4B614D),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Donation item list
          Expanded(
            child: donation.items.isEmpty
                ? const Center(child: Text('No items in the cart.')) // Show message if empty
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: donation.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = donation.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000), // subtle shadow
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item['item'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              '₵${item['amount'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Bottom total + confirm donation button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF5EA),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -1), // top shadow
                ),
              ],
            ),
            child: Column(
              children: [
                // Total amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₵${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Confirm donation button
                ElevatedButton.icon(
                  onPressed: () => _submitDonation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B614D), // dark green
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.favorite, color: Colors.white),
                  label: const Text(
                    'Confirm Donation',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

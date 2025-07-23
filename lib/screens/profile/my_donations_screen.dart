import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/donation_model.dart';

// This screen displays all the donations made by the currently logged-in user
class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Donation>> _donationFuture;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _donationFuture = _firestoreService.getUserDonations(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Donations')),

      // Fetch and display donations
      body: FutureBuilder<List<Donation>>(
        future: _donationFuture,
        builder: (context, snapshot) {
          // Show loading spinner while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no donations found
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('You have not made any donations yet.'),
            );
          }

          final donations = snapshot.data!;

          // Display each donation as a card
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];

              // Calculate total amount donated in this entry
              double totalAmount = donation.items.fold(
                0.0,
                (sum, item) => sum + (item['amount'] as num).toDouble(),
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show the ID of the school donated to
                      Text(
                        'School ID: ${donation.schoolId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Show each item donated
                      ...donation.items.map(
                        (item) => Text(
                          '• ${item['item']} - GHS ${item['amount'].toStringAsFixed(2)}',
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Total amount and status
                      Text('Total: GHS ${totalAmount.toStringAsFixed(2)}'),
                      Text('Status: ${donation.status}'),

                      // Timestamp of donation
                      Text(
                        'Date: ${donation.timestamp.toLocal().toString().split('.')[0]}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

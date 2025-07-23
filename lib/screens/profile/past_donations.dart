import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamps
import '../../models/donation_model.dart';
import '../../services/firestore_service.dart';

// This screen displays a list of all donations (useful for admin or history)
class PastDonationsScreen extends StatefulWidget {
  const PastDonationsScreen({super.key});

  @override
  State<PastDonationsScreen> createState() => _PastDonationsScreenState();
}

class _PastDonationsScreenState extends State<PastDonationsScreen> {
  late Future<List<Donation>> _donationsFuture;

  @override
  void initState() {
    super.initState();
    // Load all past donations from Firestore on screen load
    _donationsFuture = FirestoreService().fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      appBar: AppBar(
        title: const Text('Past Donations'),
        backgroundColor: const Color(0xFF88A48A),
        centerTitle: true,
      ),

      // Display past donations using FutureBuilder
      body: FutureBuilder<List<Donation>>(
        future: _donationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while fetching
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message if no data found
            return const Center(
              child: Text(
                'No donations found.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final donations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];

              // Calculate total donation amount
              final totalAmount = donation.items.fold<double>(
                0,
                (sum, item) => sum + (item['amount'] ?? 0.0),
              );

              // Format donation date
              final dateStr = DateFormat.yMMMd().add_jm().format(donation.timestamp);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: School ID and status badge
                      Row(
                        children: [
                          const Icon(Icons.school, color: Color(0xFF88A48A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'School ID: ${donation.schoolId}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Status badge (e.g., "Pending", "Completed")
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: donation.status == 'Pending'
                                  ? Colors.orange[200]
                                  : Colors.green[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              donation.status,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Total amount
                      Text('Total Amount: ₵${totalAmount.toStringAsFixed(2)}'),

                      // Number of items donated
                      const SizedBox(height: 6),
                      Text('Items Donated: ${donation.items.length}'),

                      // Date of donation
                      const SizedBox(height: 6),
                      Text('Date: $dateStr'),
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

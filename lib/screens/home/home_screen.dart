import 'package:flutter/material.dart';
import '../../models/school_model.dart';
import '../../services/firestore_service.dart';
import 'school_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../../services/shared_prefs_service.dart';

// The main home screen that displays featured and available schools to donate to
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<School>> _schoolFuture; // Holds future school data
  String? lastDonated; // Stores name of last donated school (from SharedPreferences)

  @override
  void initState() {
    super.initState();

    // Load school list from Firestore
    _schoolFuture = _firestoreService.fetchSchools();

    // Load last donated school name from local storage
    SharedPrefsService().getLastDonatedSchool().then((value) {
      setState(() {
        lastDonated = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF88A48A),
        title: const Text(
          'GiveToGrow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Profile icon in the app bar
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      // Use FutureBuilder to wait for Firestore school data
      body: FutureBuilder<List<School>>(
        future: _schoolFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while fetching data
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message if no schools were returned
            return const Center(child: Text('No schools found.'));
          }

          final schools = snapshot.data!;
          final urgentSchool = schools.first; // Assume first school is most urgent for now

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Introductory image and message
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/login.png',
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Support education in under-resourced schools across Ghana. Every donation helps!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B614D),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Show the last school the user donated to (if any)
              if (lastDonated != null)
                Text(
                  'You last donated to: $lastDonated',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 20),

              // Highlight a school with urgent needs
              const Text(
                'Urgent Need for Donations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Card(
                color: const Color(0xFFE1F5E5), // Soft green card
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(urgentSchool.imageUrl),
                  ),
                  title: Text(
                    urgentSchool.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(urgentSchool.location),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SchoolDetailScreen(school: urgentSchool),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 30),

              // List all available schools
              const Text(
                'All Schools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Loop through and render all school cards
              ...schools.map(
                (school) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SchoolDetailScreen(school: school),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // School image on the left
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          child: Image.network(
                            school.imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // School name and location
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  school.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B614D),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        school.location,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Right arrow icon
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

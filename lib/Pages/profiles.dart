import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = {
        'name': prefs.getString('name') ?? '',
        'country': prefs.getString('country') ?? '',
        'phone': prefs.getString('phone') ?? '',
        'dob': prefs.getString('dob') ?? '',
        'lastMenstruation': prefs.getString('lastMenstruation') ?? '',
        'weight': prefs.getString('weight') ?? '',
        'yourHeight': prefs.getString('yourHeight') ?? '',
        'partnerHeight': prefs.getString('partnerHeight') ?? '',
      };
    });
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pinkAccent, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          value.isEmpty ? 'Not provided' : value,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon!')),
              );
            },
          ),
        ],
      ),
      body: userData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar & Name
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink.shade100,
              backgroundImage: AssetImage('assets/images/05.jpg'),
              //child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              userData['name'] ?? 'User',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userData['country'] ?? '',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Info cards
            _infoCard('Phone', userData['phone'] ?? '', Icons.phone),
            _infoCard('Date of Birth', userData['dob'] ?? '', Icons.cake),
            _infoCard('Last Menstruation', userData['lastMenstruation'] ?? '', Icons.calendar_today),
            _infoCard('Weight', '${userData['weight']} kg', Icons.fitness_center),
            _infoCard('Your Height', '${userData['yourHeight']} cm', Icons.height),
            _infoCard('Partner Height', '${userData['partnerHeight']} cm', Icons.height),
          ],
        ),
      ),
    );
  }
}

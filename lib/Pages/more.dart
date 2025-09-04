import 'package:flutter/material.dart';
import 'dart:io';
import 'package:nini/register.dart';

class More extends StatefulWidget {
  @override
  State<More> createState() => _More();
}

class _More extends State<More> {
  bool _isDarkTheme = false;


  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  void _exitApp() {
    exit(0);
  }

  Widget _buildCard(
      {required IconData icon, required String title, String? subtitle, VoidCallback? onTap, Color? color}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (color ?? Colors.blue).withOpacity(0.2),
          child: Icon(icon, color: color ?? Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: onTap == null && title == 'Change Theme'
            ? Switch(value: _isDarkTheme, onChanged: (value) => _toggleTheme())
            : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            _buildCard(
              icon: Icons.brightness_6,
              title: 'Change Theme',
              color: Colors.deepPurple,
            ),
            _buildCard(
              icon: Icons.support_agent,
              title: 'About Us',
              subtitle: 'Get help or ask questions',
              color: Colors.green,
            ),
            _buildCard(
              icon: Icons.app_registration,
              title: 'Register',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationForm()),
                );
              },
              color: Colors.black,
            ),
            _buildCard(
              icon: Icons.contact_mail,
              title: 'Contact Us',
              subtitle: 'Visit our website',
              color: Colors.blue,
            ),
            _buildCard(
              icon: Icons.roundabout_left,
              title: 'About',
              onTap: _exitApp,
              color: Colors.pink,
            ),
            _buildCard(
              icon: Icons.accessibility_new_outlined,
              title: 'Legal Information',
              onTap: _exitApp,
              color: Colors.brown,
            ),
            _buildCard(
              icon: Icons.exit_to_app,
              title: 'Exit',
              onTap: _exitApp,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}


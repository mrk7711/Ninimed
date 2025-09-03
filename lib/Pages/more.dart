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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.brightness_6, color: Colors.deepPurple),
              title: Text('Change Theme'),
              trailing: Switch(
                value: _isDarkTheme,
                onChanged: (value) {
                  _toggleTheme();
                },
              ),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.green),
              title: Text('About Us'),
              subtitle: Text('Get help or ask questions'),

            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.app_registration, color: Colors.black),
              title: Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationForm()),
                );
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.blue),
              title: Text('Contact Us'),
              subtitle: Text('Visit our website'),

            ),
            Divider(),
            Divider(),
            ListTile(
              leading: Icon(Icons.roundabout_left, color: Colors.pink[200]),
              title: Text('About'),
              onTap: _exitApp,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.accessibility_new_outlined, color: Colors.brown),
              title: Text('Legal Information'),
              onTap: _exitApp,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Exit'),
              onTap: _exitApp,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nini/homescreen.dart';
import 'package:nini/Pages/home.dart';
import 'package:nini/Pages/papers.dart';
import 'package:nini/Pages/profiles.dart';
import 'package:nini/Pages/more.dart';
import 'package:nini/Pages/calender.dart';
import 'package:nini/Widgets/bottomnavigationbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _navigationBottomSelect(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  final List _pages = [
    Home(),
    PregnancyCalculator(),
    Papers(),
    ProfileScreen(),
    More(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _navigationBottomSelect,
      ),
    );
  }
}
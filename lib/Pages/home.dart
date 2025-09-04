import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nini/Pages/papers.dart';
import 'package:nini/Pages/profiles.dart';
import 'package:nini/Pages/calender.dart';
import 'package:nini/Widgets/baby_sizes.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int currentWeek = 0;
  Map<String, String> userData = {
    'name': '',
    'country': '',
    'phone': '',
    'dob': '',
    'lastMenstruation': '',
    'weight': '',
    'yourHeight': '',
    'partnerHeight': '',
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // خواندن اطلاعات کاربر
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

    // محاسبه هفته بارداری بر اساس آخرین قاعدگی
    if (userData['lastMenstruation'] != null &&
        userData['lastMenstruation']!.isNotEmpty) {
      DateTime lastMenstruation = DateTime.parse(userData['lastMenstruation']!);
      DateTime now = DateTime.now();
      int diffDays = now.difference(lastMenstruation).inDays;
      setState(() {
        currentWeek = (diffDays ~/ 7) + 1;
        if (currentWeek > 40) currentWeek = 40;
        if (currentWeek < 1) currentWeek = 1;
      });
    } else {
      setState(() {
        currentWeek = 0;
      });
    }
  }

  String getBabySize(int week) {
    for (var item in babySizes.reversed) {
      if (week >= int.parse(item['week']!)) {
        return '${item['emoji']} Your baby is the size of a ${item['size']}!';
      }
    }
    return '👶 Your baby is just starting to grow!';
  }

  @override
  Widget build(BuildContext context) {
    String displayName = userData['name']!.isNotEmpty ? userData['name']! : 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('NiniMed Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // سلام به کاربر
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hi, $displayName!',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // کارت وضعیت بارداری
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PregnancyCalculator()),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.pink.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.pink.shade100,
                        child: const Icon(Icons.pregnant_woman,
                            size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pregnancy Status',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Current Week: $currentWeek',
                              style: const TextStyle(fontSize: 14)),
                          Text('Tap to see calendar',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // کارت Fun / اندازه بچه بزرگ و جذاب
            Card(
              elevation: 8,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade200, Colors.orange.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      babySizes
                          .firstWhere(
                              (item) =>
                          currentWeek >= int.parse(item['week']!),
                          orElse: () => {
                            'emoji': '👶',
                            'size': 'starting'
                          })['emoji'] ??
                          '👶',
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        getBabySize(currentWeek),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // دسترسی سریع به ماژول‌ها
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _moduleCard(
                    title: 'Articles',
                    icon: Icons.article,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Papers()),
                      );
                    }),
                _moduleCard(
                    title: 'Profile',
                    icon: Icons.person,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()),
                      );
                    }),
                _moduleCard(
                    title: 'Pregnancy Timeline',
                    icon: Icons.timeline,
                    color: Colors.pinkAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PregnancyCalculator()),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleCard(
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

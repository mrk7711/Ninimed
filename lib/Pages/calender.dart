import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:nini/Widgets/events.dart';

class PregnancyCalculator extends StatefulWidget {
  const PregnancyCalculator({super.key});

  @override
  State<PregnancyCalculator> createState() => _PregnancyCalculatorState();
}

class _PregnancyCalculatorState extends State<PregnancyCalculator> {
  DateTime? lastMenstruation;
  DateTime? dueDate;
  int currentWeek = 0;
  int daysLeft = 0;
  bool isLoading = true;
  double progress = 0.0;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lm = prefs.getString('lastMenstruation');

    if (lm != null && lm.isNotEmpty) {
      lastMenstruation = DateTime.parse(lm);
      dueDate = lastMenstruation!.add(const Duration(days: 280)); // 40 weeks

      DateTime now = DateTime.now();
      int diffDays = now.difference(lastMenstruation!).inDays;
      currentWeek = (diffDays ~/ 7) + 1;
      daysLeft = dueDate!.difference(now).inDays;
      progress = (diffDays / 280); // 40 هفته = 280 روز
      if (progress > 1.0) progress = 1.0;
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Calculator'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
            child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
            children: [
              // Avatar / Icon
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.pink.shade100,
                child: const Icon(Icons.pregnant_woman, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
            
              // Week Info
              _infoCard(
                'Current Week',
                currentWeek > 0 ? 'Week $currentWeek' : 'Not started',
                Icons.calendar_today,
                Colors.pinkAccent,
              ),

              // Days left
              _infoCard(
                'Days Left',
                daysLeft > 0 ? '$daysLeft days remaining' : 'N/A',
                Icons.timer,
                Colors.orangeAccent,
              ),
            
              // Due Date
              _infoCard(
                'Estimated Due Date',
                dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : 'N/A',
                Icons.date_range,
                Colors.green,
              ),
            

              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Week $currentWeek / 40',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Container(
                            height: 25,
                            width: MediaQuery.of(context).size.width * progress,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Colors.orangeAccent, Colors.deepOrange],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                '${(progress * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your baby is ${(progress * 100).toStringAsFixed(1)}% ready!',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Tip / Advice Section
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.pink.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '💡 Tip: Remember to attend your weekly check-ups and maintain a healthy diet.',
                    style: TextStyle(fontSize: 14, color: Colors.pink.shade900),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _infoCard(
                events[0]['title'],
                events[0]['value'],
                events[0]['icon'],
                events[0]['color'],
              ),
              _infoCard(
                events[1]['title'],
                events[1]['value'],
                events[1]['icon'],
                events[1]['color'],
              ),
              _infoCard(
                events[2]['title'],
                events[2]['value'],
                events[2]['icon'],
                events[2]['color'],
              ),
              _infoCard(
                events[3]['title'],
                events[3]['value'],
                events[3]['icon'],
                events[3]['color'],
              ),
            ],
                    ),
                  ),
          ),
    );
  }
}

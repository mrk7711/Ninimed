import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
          : Padding(
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

            const SizedBox(height: 20),

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
          ],
        ),
      ),
    );
  }
}

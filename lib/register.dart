import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nini/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegistrationForm extends StatefulWidget {
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String? country;
  String phone = '';
  DateTime? dob;
  DateTime? lastMenstruation;
  String weight = '';
  String yourHeight = '';
  String partnerHeight = '';

  List<String> countries = [
    'United States', 'United Kingdom', 'Canada', 'Germany',
    'France', 'Australia', 'Iran', 'India', 'Other',
  ];

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      ValueChanged<DateTime> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) onDateSelected(picked);
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
    await prefs.setString('name', name);
    await prefs.setString('country', country ?? '');
    await prefs.setString('phone', phone);
    await prefs.setString('dob', dob != null ? dob!.toIso8601String() : '');
    await prefs.setString('lastMenstruation',
        lastMenstruation != null ? lastMenstruation!.toIso8601String() : '');
    await prefs.setString('weight', weight);
    await prefs.setString('yourHeight', yourHeight);
    await prefs.setString('partnerHeight', partnerHeight);
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  FormFieldSetter<String>? onSaved,
    String? hintText,
  }) {
    return _buildCard(
      child: TextFormField(
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Form'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              _buildTextField(
                label: 'Name',
                onSaved: (val) => name = val ?? '',
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter your name' : null,
              ),

              // Country Dropdown
              _buildCard(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  value: country,
                  items: countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => country = val),
                  validator: (val) =>
                  val == null ? 'Please select your country' : null,
                ),
              ),

              // Phone
              _buildTextField(
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                onSaved: (val) => phone = val ?? '',
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter your phone' : null,
              ),

              // Date of Birth
              _buildTextField(
                label: 'Date of Birth',
                readOnly: true,
                hintText: dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
                onTap: () => _selectDate(context, dob, (picked) {
                  setState(() => dob = picked);
                }),
                validator: (_) => dob == null ? 'Select your date of birth' : null,
              ),

              // Last Menstruation
              _buildTextField(
                label: 'Last Menstruation',
                readOnly: true,
                hintText: lastMenstruation != null
                    ? DateFormat('yyyy-MM-dd').format(lastMenstruation!)
                    : '',
                onTap: () => _selectDate(context, lastMenstruation, (picked) {
                  setState(() => lastMenstruation = picked);
                }),
                validator: (_) =>
                lastMenstruation == null ? 'Select last menstruation' : null,
              ),

              // Weight
              _buildTextField(
                label: 'Weight (kg)',
                keyboardType: TextInputType.number,
                onSaved: (val) => weight = val ?? '',
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter your weight' : null,
              ),

              // Your Height
              _buildTextField(
                label: 'Your Height (cm)',
                keyboardType: TextInputType.number,
                onSaved: (val) => yourHeight = val ?? '',
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter your height' : null,
              ),

              // Partner Height
              _buildTextField(
                label: 'Partner Height (cm)',
                keyboardType: TextInputType.number,
                onSaved: (val) => partnerHeight = val ?? '',
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter partner height' : null,
              ),

              SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await _saveData(); // ذخیره در SharedPreferences

                      // هدایت به صفحه اصلی و جایگزینی صفحه فعلی
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration successful')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: Text('Submit', style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

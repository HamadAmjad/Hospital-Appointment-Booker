import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddDoctorsScreen extends StatefulWidget {
  const AddDoctorsScreen({super.key});

  @override
  State<AddDoctorsScreen> createState() => _AddDoctorsScreenState();
}

class _AddDoctorsScreenState extends State<AddDoctorsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref('doctors');

  Future<void> _addDoctor() async {
    final newDoctor = {
      'name': _nameController.text.trim(),
      'experience': _experienceController.text.trim(),
      'education': _educationController.text.trim(),
      'fee': _feeController.text.trim(),
      'specialty': _specialtyController.text.trim(),
    };

    try {
      // Save to Firebase
      await _database.push().set(newDoctor);
      print("Doctor added successfully.");

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Doctor Added'),
          content: const Text('Doctor details have been successfully added.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Clear fields after submission
      _nameController.clear();
      _experienceController.clear();
      _educationController.clear();
      _feeController.clear();
      _specialtyController.clear();
    } catch (e) {
      print("Error adding doctor: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add doctor: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Add Doctors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Doctor Details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Doctor Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Doctor Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the doctor\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Experience Field
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience (in years)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the experience';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Education Field
                TextFormField(
                  controller: _educationController,
                  decoration: const InputDecoration(
                    labelText: 'Education',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the education details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Consultation Fee Field
                TextFormField(
                  controller: _feeController,
                  decoration: const InputDecoration(
                    labelText: 'Consultation Fee',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the consultation fee';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Specialty Field
                TextFormField(
                  controller: _specialtyController,
                  decoration: const InputDecoration(
                    labelText: 'Specialty',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the specialty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addDoctor();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  child: const Text('Add Doctor',style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

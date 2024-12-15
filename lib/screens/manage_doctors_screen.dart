import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ManageDoctorsScreen extends StatefulWidget {
  const ManageDoctorsScreen({super.key});

  @override
  State<ManageDoctorsScreen> createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('doctors');
  late DatabaseReference _doctorsRef;
  List<Map<String, String>> doctorsList = [];

  @override
  void initState() {
    super.initState();
    _doctorsRef = FirebaseDatabase.instance.ref('doctors');
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    _doctorsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final Map<dynamic, dynamic> doctorsMap = data is Map<dynamic, dynamic>
            ? Map<dynamic, dynamic>.from(data)
            : {};

        final List<Map<String, String>> loadedDoctors = [];

        doctorsMap.forEach((key, value) {
          final doctorData = Map<String, dynamic>.from(value);

          loadedDoctors.add({
            'id': key,
            'name': doctorData['name'] ?? '',
            'experience': doctorData['experience']?.toString() ?? '',
            'education': doctorData['education'] ?? '',
            'fee': doctorData['fee']?.toString() ?? '',
            'specialty': doctorData['specialty'] ?? '',
          });
        });

        setState(() {
          doctorsList = loadedDoctors;
        });
      }
    });
  }

  Future<void> _deleteDoctor(String id) async {
    try {
      await _doctorsRef.child(id).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor deleted successfully')),
      );
      _fetchDoctors();  // Re-fetch the doctors list after deletion
      // Trigger a full refresh by navigating back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete doctor: $e')),
      );
    }
  }

  Future<void> _editDoctor(String id, Map<String, String> doctorDetails) async {
    final TextEditingController _nameController = TextEditingController(text: doctorDetails['name']);
    final TextEditingController _experienceController = TextEditingController(text: doctorDetails['experience']);
    final TextEditingController _educationController = TextEditingController(text: doctorDetails['education']);
    final TextEditingController _feeController = TextEditingController(text: doctorDetails['fee']);
    final TextEditingController _specialtyController = TextEditingController(text: doctorDetails['specialty']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Doctor Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Doctor Name'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Experience (in years)'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _educationController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Education'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _feeController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Consultation Fee'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _specialtyController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Specialty'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                final updatedDoctor = {
                  'name': _nameController.text.trim(),
                  'experience': _experienceController.text.trim(),
                  'education': _educationController.text.trim(),
                  'fee': _feeController.text.trim(),
                  'specialty': _specialtyController.text.trim(),
                };
                await _doctorsRef.child(id).update(updatedDoctor);
                Navigator.pop(context);  // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Doctor updated successfully', style: TextStyle(color: Colors.blueAccent))),
                );
                _fetchDoctors();  // Re-fetch the doctors list after editing
                // Trigger a full refresh by navigating back
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Doctors'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: doctorsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: doctorsList.length,
          itemBuilder: (context, index) {
            final doctor = doctorsList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['name'] ?? '',
                            style: const TextStyle(fontSize: 22,color: Colors.blueAccent),
                          ),
                          Text(
                            'Specialty: ${doctor['specialty']}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Experience: ${doctor['experience']} years',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Consultation Fee: \$${doctor['fee']}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editDoctor(doctor['id']!, doctor),
                          tooltip: 'Edit Doctor',
                          color: Colors.blueAccent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteDoctor(doctor['id']!),
                          tooltip: 'Delete Doctor',
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

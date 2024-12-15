import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BookDoctorAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic>? doctor;

  const BookDoctorAppointmentScreen({super.key, this.doctor});

  @override
  _BookDoctorAppointmentScreenState createState() =>
      _BookDoctorAppointmentScreenState();
}

class _BookDoctorAppointmentScreenState extends State<BookDoctorAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Variable to store selected doctor
  Map<String, dynamic>? _selectedDoctor;

  @override
  void initState() {
    super.initState();
    if (widget.doctor != null) {
      _selectedDoctor = widget.doctor;
    }
  }

  // Select Date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0]; // Formatting to YYYY-MM-DD
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      final databaseReference = FirebaseDatabase.instance.ref();
      final doctorAppointmentsRef = databaseReference
          .child('appointments')
          .child(_selectedDoctor?['name'] ?? '')
          .child(_dateController.text);

      try {
        // Fetch existing appointments for the doctor and date
        final snapshot = await doctorAppointmentsRef.get();

        // Prepare the appointments map
        Map<String, dynamic> appointments = {};

        if (snapshot.exists) {
          if (snapshot.value is Map) {
            appointments = Map<String, dynamic>.from(snapshot.value as Map);
          } else if (snapshot.value is List) {
            final listAppointments = snapshot.value as List;
            for (int i = 0; i < listAppointments.length; i++) {
              if (listAppointments[i] != null) {
                appointments[(i + 1).toString()] = listAppointments[i];
              }
            }
          } else {
            print("Unexpected data format: ${snapshot.value.runtimeType}");
            appointments = {};
          }
        }

        // Generate the next token number
        int nextTokenNumber = appointments.isEmpty
            ? 1
            : (appointments.keys.map((key) => int.tryParse(key) ?? 0).toList()..sort()).last + 1;

        // Create appointment data
        final appointmentData = {
          'doctorName': _selectedDoctor?['name'] ?? 'Unknown',
          'patientName': _nameController.text,
          'phone': _phoneController.text,
          'appointmentDate': _dateController.text,
          'appointmentTime': 'TBD', // Placeholder for time
          'createdAt': ServerValue.timestamp,
          'token': nextTokenNumber,
        };

        // Save the appointment to Firebase
        await doctorAppointmentsRef.child(nextTokenNumber.toString()).set(appointmentData);

        // Store form values before clearing
        String patientName = _nameController.text;
        String phone = _phoneController.text;
        String appointmentDate = _dateController.text;

        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Appointment Booked'),
            content: Text(
              'Name: $patientName\n'
                  'Phone: $phone\n'
                  'Date: $appointmentDate\n'
                  'Doctor: ${_selectedDoctor?['name'] ?? 'No doctor selected'}\n'
                  'Token: $nextTokenNumber\n',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Clear form fields
        _nameController.clear();
        _phoneController.clear();
        _dateController.clear();
      } catch (e) {
        print("Error saving appointment: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to book appointment. Error: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedDoctor != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Selected Doctor: ${_selectedDoctor!['name']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              const Text(
                'Enter your details:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Appointment Date',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      validator: (value) => value!.isEmpty ? 'Please select a date' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Book Appointment', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

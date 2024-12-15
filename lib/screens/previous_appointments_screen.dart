import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PreviousAppointmentsScreen extends StatefulWidget {
  const PreviousAppointmentsScreen({super.key});

  @override
  _PreviousAppointmentsScreenState createState() =>
      _PreviousAppointmentsScreenState();
}

class _PreviousAppointmentsScreenState extends State<PreviousAppointmentsScreen> {
  late DatabaseReference _appointmentsRef;
  List<String> doctors = [];
  String? selectedDoctor;
  List<Map<String, dynamic>> appointmentsList = [];

  @override
  void initState() {
    super.initState();
    _appointmentsRef = FirebaseDatabase.instance.ref().child('appointments');
    _fetchDoctors();
  }

  // Fetch the list of doctors from Firebase
  void _fetchDoctors() async {
    final doctorsSnapshot = await _appointmentsRef.get();

    if (doctorsSnapshot.exists) {
      setState(() {
        doctors = List<String>.from(doctorsSnapshot.children.map((child) => child.key!));
      });
    }
  }

  // Fetch appointments for the selected doctor
  void _fetchAppointmentsForDoctor(String doctorName) async {
    final appointmentsSnapshot = await _appointmentsRef.child(doctorName).get();

    if (appointmentsSnapshot.exists) {
      List<Map<String, dynamic>> fetchedAppointments = [];

      appointmentsSnapshot.children.forEach((appointmentDateSnapshot) {
        appointmentDateSnapshot.children.forEach((appointmentSnapshot) {
          final appointmentDetails = appointmentSnapshot.value as Map?;
          if (appointmentDetails != null) {
            fetchedAppointments.add({
              'token': appointmentDetails['token'] ?? 0,
              'patientName': appointmentDetails['patientName'] ?? 'Unknown',
              'phone': appointmentDetails['phone'] ?? 'Unknown',
              'appointmentDate': appointmentDateSnapshot.key,
            });
          }
        });
      });

      setState(() {
        appointmentsList = fetchedAppointments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Appointments'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: doctors.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching doctors
            : Column(
          children: [
            // Doctor selection dropdown
            DropdownButton<String>(
              hint: const Text('Select Doctor'),
              value: selectedDoctor,
              onChanged: (String? newDoctor) {
                setState(() {
                  selectedDoctor = newDoctor;
                  appointmentsList.clear(); // Clear previous appointments
                });
                if (newDoctor != null) {
                  _fetchAppointmentsForDoctor(newDoctor); // Fetch appointments when doctor is selected
                }
              },
              items: doctors.map((doctor) {
                return DropdownMenuItem<String>(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Display appointments list
            appointmentsList.isEmpty
                ? const Center(child: Text('No appointments available for the selected doctor'))
                : Expanded(
              child: ListView.builder(
                itemCount: appointmentsList.length,
                itemBuilder: (context, index) {
                  final appointment = appointmentsList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text('Patient: ${appointment['patientName']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone: ${appointment['phone']}'),
                          Text('Token: ${appointment['token']}'),
                          Text('Date: ${appointment['appointmentDate']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

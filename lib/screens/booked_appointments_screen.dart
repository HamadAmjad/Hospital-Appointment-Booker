import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BookedAppointmentsScreen extends StatefulWidget {
  const BookedAppointmentsScreen({super.key});

  @override
  _BookedAppointmentsScreenState createState() =>
      _BookedAppointmentsScreenState();
}

class _BookedAppointmentsScreenState extends State<BookedAppointmentsScreen> {
  late DatabaseReference _appointmentsRef;
  String? selectedDoctor;
  String? selectedDate;
  List<String> doctors = [];
  List<Map<String, dynamic>> allAppointments = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() async {
    // Fetch the list of doctors from Firebase
    final doctorsSnapshot = await FirebaseDatabase.instance.ref().child('appointments').get();

    if (doctorsSnapshot.exists) {
      setState(() {
        doctors = List<String>.from(doctorsSnapshot.children.map((child) => child.key!));
      });
    }
  }

  void _onDoctorSelected(String? doctorName) {
    setState(() {
      selectedDoctor = doctorName;
      selectedDate = null; // Reset the date when doctor changes
      allAppointments.clear(); // Clear previous appointments
    });
  }

  void _onDateSelected(String? date) {
    setState(() {
      selectedDate = date;
    });
    _fetchAppointments(); // Fetch appointments for the selected date
  }

  void _fetchAppointments() async {
    if (selectedDoctor != null && selectedDate != null) {
      // Fetch appointments for the selected doctor and date
      final appointmentsSnapshot = await FirebaseDatabase.instance
          .ref()
          .child('appointments')
          .child(selectedDoctor!)
          .child(selectedDate!)
          .get();

      if (appointmentsSnapshot.exists) {
        List<Map<String, dynamic>> fetchedAppointments = [];
        appointmentsSnapshot.children.forEach((appointment) {
          final appointmentDetails = appointment.value as Map?;
          if (appointmentDetails != null) {
            fetchedAppointments.add({
              'token': appointmentDetails['token'] ?? 0,
              'patientName': appointmentDetails['patientName'] ?? 'Unknown',
              'phone': appointmentDetails['phone'] ?? 'Unknown',
            });
          }
        });

        setState(() {
          allAppointments = fetchedAppointments;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Appointments'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: selectedDoctor == null
            ? _buildDoctorSelection()
            : selectedDate == null
            ? _buildDateSelection()
            : _buildAppointmentList(),
      ),
    );
  }

  Widget _buildDoctorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Select a Doctor:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 20),
        doctors.isEmpty
            ? const CircularProgressIndicator() // Show loading indicator until doctors are fetched
            : Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: DropdownButton<String>(
              hint: const Text('Choose Doctor'),
              value: selectedDoctor,
              onChanged: _onDoctorSelected,
              items: doctors.map((doctor) {
                return DropdownMenuItem<String>(
                  value: doctor,
                  child: Text(
                    doctor,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Select Appointment Date:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              _onDateSelected(pickedDate.toString().split(' ')[0]); // Use YYYY-MM-DD format
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white70,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Pick a Date',
            style: TextStyle(fontSize: 18,color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentList() {
    return allAppointments.isEmpty
        ? const Center(
      child: Text(
        'No Appointments Found!',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    )
        : ListView.builder(
      itemCount: allAppointments.length,
      itemBuilder: (context, index) {
        final appointment = allAppointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Patient: ${appointment['patientName']}',
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone: ${appointment['phone']}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Token: ${appointment['token']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

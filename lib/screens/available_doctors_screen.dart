import 'package:appointmentbooker/screens/doctors_details_screen.dart';
import 'package:flutter/material.dart';

class AvailableDoctorsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> doctors;

  const AvailableDoctorsScreen({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(doctor['name']),
            subtitle: Text(doctor['specialty']),
            trailing: Text('PKR ${doctor['fee']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailsScreen(doctor: doctor),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:appointmentbooker/main.dart';
import 'package:appointmentbooker/screens/booked_appointments_screen.dart';
import 'package:appointmentbooker/screens/add_doctors_screen.dart';
import 'package:appointmentbooker/screens/previous_appointments_screen.dart';
import 'package:flutter/material.dart';
import 'package:appointmentbooker/screens/manage_doctors_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 buttons per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              'Book Appointment',
              Icons.calendar_month_outlined,
              Colors.blueAccent,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              'Add Doctors',
              Icons.person_add,
              Colors.blueAccent,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDoctorsScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              'Booked Appointments',
              Icons.bookmark,
              Colors.blueAccent,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookedAppointmentsScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              'Manage Doctors',
              Icons.medical_services,
              Colors.blueAccent,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageDoctorsScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              'Coming Soon',
              Icons.flutter_dash,
              Colors.blueAccent,
                  () {},
            ),
            _buildDashboardCard(
              context,
              'Coming Soon',
              Icons.flutter_dash,
              Colors.blueAccent,
                  () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: color,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                softWrap: true,
                title,
                textAlign: TextAlign.center,
                maxLines: 2, // Ensures that the text will wrap into two lines at most
                overflow: TextOverflow.ellipsis, // Adds ellipsis if the text is too long for two lines
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

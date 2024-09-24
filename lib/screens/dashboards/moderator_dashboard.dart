// lib/screens/dashboards/moderator_dashboard.dart
import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/dashboards/pest_list_screen.dart';
import 'package:pest_survey_app/screens/forms/create_task_form.dart'; // Import the task assignment form
import 'map_screen.dart'; // Assuming pest distribution map is in this file
import 'review_reports_screen.dart'; // For reviewing pest reports
import 'package:pest_survey_app/screens/forms/add_user_form.dart'; // Import the AddUserForm for creating accounts

class ModeratorDashboard extends StatelessWidget {
  const ModeratorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderator Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PestListScreen()), // Navigate to pest list screen
                );
              },
              child: const Text('View Pest Lists'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()), // Navigate to map visualization
                );
              },
              child: const Text('View Pest Distribution Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewReportsScreen()), // Navigate to report review
                );
              },
              child: const Text('Review Pest Reports'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PestListScreen()), // Navigate to pest management
                );
              },
              child: const Text('Manage Pests'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserForm()), // Navigate to the form for adding FSOs and Farmers
                );
              },
              child: const Text('Add FSO/Farmer'),
            ),
            const SizedBox(height: 20),
            // New Button to Assign Tasks to FSOs
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTaskForm()), // Navigate to the form for assigning tasks to FSOs
                );
              },
              child: const Text('Assign Task to FSO'), // New button for task assignment
            ),
          ],
        ),
      ),
    );
  }
}

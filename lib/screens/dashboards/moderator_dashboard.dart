import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/dashboards/pest_list_screen.dart';
import 'map_screen.dart'; // Assuming pest distribution map is in this file
import 'review_reports_screen.dart'; // For reviewing pest reports

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
             onPressed: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => PestListScreen()),
                 );
             },
             child: const Text('View Pest Lists')),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()), // Navigate to map visualization
                );
              },
              child: const Text('View Pest Distribution Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewReportsScreen()), // Navigate to report review
                );
              },
              child: const Text('Review Pest Reports'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestListScreen()), // Navigate to pest management
                );
              },
              child: const Text('Manage Pests'),
            ),
          ],
        ),
      ),
    );
  }
}

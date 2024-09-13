import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/dashboards/pest_list_screen.dart';

import '../forms/survey_form.dart';
// import '../form'; // Import the new DynamicSurveyForm

class FSODashboard extends StatelessWidget {
  const FSODashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FSO Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestListScreen()),
                );
              },
              child: const Text('View Pest Lists'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to DynamicSurveyForm for "Delimiting" survey type
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DynamicSurveyForm(), // No need to pass survey type as a constructor argument now
                  ),
                );
              },
              child: const Text('Delimiting Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to DynamicSurveyForm for "Monitoring" survey type
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DynamicSurveyForm(), // The form will be dynamically built
                  ),
                );
              },
              child: const Text('Monitoring Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to DynamicSurveyForm for "Detection" survey type
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DynamicSurveyForm(),
                  ),
                );
              },
              child: const Text('Detection Survey'),
            ),
          ],
        ),
      ),
    );
  }
}

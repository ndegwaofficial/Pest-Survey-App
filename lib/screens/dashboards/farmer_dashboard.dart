import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/forms/new_pest_report_form.dart';
import 'pest_scanner.dart'; 

class FarmerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestScanner()), // Navigate to pest scanner
                );
              },
              child: Text('Scan Pest'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPestReportForm()), // Navigate to pest report form
                );
              },
              child: Text('Report New Pest'),
            ),
          ],
        ),
      ),
    );
  }
}

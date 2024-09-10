import 'package:flutter/material.dart';
import 'survey_form.dart';

class FSODashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FSO Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm('delimiting')),
                );
              },
              child: Text('Delimiting Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm('monitoring')),
                );
              },
              child: Text('Monitoring Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm('detection')),
                );
              },
              child: Text('Detection Survey'),
            ),
          ],
        ),
      ),
    );
  }
}

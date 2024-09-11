import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/dashboards/pest_list_screen.dart';
import '../forms/survey_form.dart';

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
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestListScreen()),
                  );
              },
              child: Text('View Pest Lists')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm('delimiting', surveyType: '',)),
                );
              },
              child: Text('Delimiting Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm('monitoring', surveyType: '',)),
                );
              },
              child: Text('Monitoring Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm('detection', surveyType: '',)),
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

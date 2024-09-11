import 'package:flutter/material.dart';
import '../../services/survey_form/excel_service.dart';
import 'package:postgres/postgres.dart';

class SurveyForm extends StatefulWidget {
  final String surveyType;
  final String? initialPestName; //Pre-filled pest name

  SurveyForm(String s, {required this.surveyType, this.initialPestName});

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> _controllers = {};
  List<String> _fields = [];
  late ExcelService _excelService;

  @override
  void initState() {
    super.initState();
    _excelService = ExcelService('/path/to/Surveillance Form.xlsx'); // Path to the uploaded Excel file
    _loadFields();
  }

   Future<void> _loadFields() async {
    Map<String, List<String>> surveyFields = await _excelService.loadSurveyFields();
    setState(() {
      _fields = surveyFields[widget.surveyType]!;
      _controllers = {
        for (var field in _fields) field: TextEditingController(
          text: (field.toLowerCase() == 'pest name') ? widget.initialPestName ?? '' : ''
        )
      };
    });
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare data to submit
      Map<String, String> surveyData = {
        for (var field in _fields) field: _controllers[field]!.text
      };

      // Submit to PostgreSQL database
      await _submitSurveyToDatabase(surveyData);
    }
  }
Future<void> _submitSurveyToDatabase(Map<String, String> surveyData) async {
  final connection = PostgreSQLConnection(
    'localhost',
    5432,
    'pestsurveillance',
    username: 'postgres',
    password: '',
  );

  try {
    await connection.open();

    // Insert survey into the database
    await connection.query('''
      INSERT INTO surveys (fso_id, survey_type, survey_results, created_at)
      VALUES (@fso_id, @survey_type, @survey_results, NOW())
    ''', substitutionValues: {
      'fso_id': 1, // Example FSO ID
      'survey_type': widget.surveyType,
      'survey_results': surveyData.toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Survey submitted successfully!'),
    ));

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error submitting survey: $e'),
    ));

    // Show option to retry the submission
    _showSubmissionErrorDialog();
  } finally {
    await connection.close();
  }
}

Future<void> _showSubmissionErrorDialog() async {
  bool retry = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Submission Failed'),
        content: Text('An error occurred while submitting the survey. Would you like to retry?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ) ?? false;

  if (retry) {
    _submitForm(); // Retry submission
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.surveyType.capitalize()} Survey'),
      ),
      body: _fields.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ..._fields.map((field) {
                      return TextFormField(
                        controller: _controllers[field],
                        decoration: InputDecoration(labelText: field),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter $field';
                          }
                          return null;
                        },
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit Survey'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}

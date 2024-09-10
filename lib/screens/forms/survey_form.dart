import 'package:flutter/material.dart';
import '../../services/survey_form/excel_service.dart';
import 'package:postgres/postgres.dart';

class SurveyForm extends StatefulWidget {
  final String surveyType;

  SurveyForm(this.surveyType);

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
        for (var field in _fields) field: TextEditingController()
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
      'your_database_url',
      5432,
      'your_database_name',
      username: 'your_username',
      password: 'your_password',
    );
    await connection.open();

    // Insert survey into the database (modify according to your table schema)
    await connection.query('''
      INSERT INTO surveys (fso_id, survey_type, survey_results, created_at)
      VALUES (@fso_id, @survey_type, @survey_results, NOW())
    ''', substitutionValues: {
      'fso_id': 1, // Example FSO ID, use actual ID in real implementation
      'survey_type': widget.surveyType,
      'survey_results': surveyData.toString(),
    });

    await connection.close();
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

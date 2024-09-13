import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp
import 'package:pest_survey_app/services/survey_to_dbservice.dart';
import 'survey_data.dart';
// import 'database_sessrvice.dart'; // This file will handle database logic

class DynamicSurveyForm extends StatefulWidget {
  final String? initialPestName; // New optional parameter for pest name
  final String? preSelectedSurveyType; // New optional parameter for survey type

  const DynamicSurveyForm({super.key, this.initialPestName, this.preSelectedSurveyType}); // Constructor update

  @override
  _DynamicSurveyFormState createState() => _DynamicSurveyFormState();
}

class _DynamicSurveyFormState extends State<DynamicSurveyForm> {
  String? selectedSurveyType;
  Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  TextEditingController officerController = TextEditingController(); // For officer's name
  TextEditingController pestController = TextEditingController(); // For pest name
  late String timestamp; // For timestamp

  @override
  void initState() {
    super.initState();
    timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()); // Get the current timestamp

    // Pre-fill pest name and survey type if provided
    if (widget.initialPestName != null) {
      pestController.text = widget.initialPestName!;
    }
    if (widget.preSelectedSurveyType != null) {
      selectedSurveyType = widget.preSelectedSurveyType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Survey Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Officer's name field
              TextFormField(
                controller: officerController,
                decoration: const InputDecoration(labelText: "Field Surveillance Officer's Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter officer\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pest name field
              TextFormField(
                controller: pestController,
                decoration: const InputDecoration(labelText: 'Pest Name'),
                onChanged: (value) {
                  formData['pest_name'] = value;
                },
              ),
              const SizedBox(height: 20),

              // Survey Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Survey Type'),
                value: selectedSurveyType, // Pre-select survey type if available
                items: surveyFields.keys
                    .map((surveyType) => DropdownMenuItem(
                          value: surveyType,
                          child: Text(surveyType),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSurveyType = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Dynamic form fields based on the selected survey type
              if (selectedSurveyType != null)
                Expanded(
                  child: ListView(
                    children: surveyFields[selectedSurveyType]!
                        .where((field) => field.isVisible)
                        .map((field) => buildField(field))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 20),

              // Display timestamp
              Text("Timestamp: $timestamp"),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    formData['officer_name'] = officerController.text;
                    formData['timestamp'] = timestamp;
                    formData['pest_name'] = pestController.text;

                    // Save to database
                    await DatabaseService().saveSurveyData(formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Survey Saved')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Create the form field widget dynamically
  Widget buildField(SurveyField field) {
    switch (field.fieldType) {
      case 'text':
        return TextFormField(
          decoration: InputDecoration(labelText: field.fieldName),
          onChanged: (value) {
            formData[field.fieldName] = value;
          },
        );
      case 'dropdown':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: field.fieldName),
          items: field.options!
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            formData[field.fieldName] = value;
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

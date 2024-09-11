import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class NewPestReportForm extends StatefulWidget {
  const NewPestReportForm({super.key});

  @override
  _NewPestReportFormState createState() => _NewPestReportFormState();
}

class _NewPestReportFormState extends State<NewPestReportForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pestNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final connection = PostgreSQLConnection(
        'your_database_url',
        5432,
        'your_database_name',
        username: 'your_username',
        password: 'your_password',
      );
      await connection.open();

      await connection.query('''
        INSERT INTO reports (pest_name, location, details, created_at)
        VALUES (@pest_name, @location, @details, NOW())
      ''', substitutionValues: {
        'pest_name': _pestNameController.text,
        'location': _locationController.text,
        'details': _detailsController.text,
      });

      await connection.close();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pest report submitted successfully!'),
      ));

      Navigator.pop(context); // Return to Farmer Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Pest Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pestNameController,
                decoration: const InputDecoration(labelText: 'Pest Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pest name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Details'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide details about the pest';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

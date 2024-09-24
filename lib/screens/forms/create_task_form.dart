import 'package:flutter/material.dart';
import 'package:pest_survey_app/services/task_service.dart';

class CreateTaskForm extends StatefulWidget {
  @override
  _CreateTaskFormState createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPest;
  String? selectedSurveyType;
  String? selectedFSO;
  DateTime? dueDate;

  // Example list of pests, FSOs, and survey types
  List<String> pestList = ['Pest 1', 'Pest 2', 'Pest 3'];
  List<String> fsoList = ['FSO 1', 'FSO 2', 'FSO 3'];
  List<String> surveyTypes = ['Monitoring', 'Delimiting', 'Detection'];

  // Submit task creation form
  Future<void> _submitTask() async {
    if (_formKey.currentState!.validate()) {
      // Assuming a service that creates a task
      await TaskService().createTask(selectedPest!, selectedSurveyType!, selectedFSO!, dueDate!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task assigned to FSO')),
      );
      Navigator.pop(context);
    }
  }

  // Select a due date
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Select a Pest from the master list
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Pest'),
                items: pestList.map((pest) {
                  return DropdownMenuItem<String>(
                    value: pest,
                    child: Text(pest),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPest = value;
                  });
                },
              ),

              // Select a Survey Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Survey Type'),
                items: surveyTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSurveyType = value;
                  });
                },
              ),

              // Select an FSO to assign the task
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Assign to FSO'),
                items: fsoList.map((fso) {
                  return DropdownMenuItem<String>(
                    value: fso,
                    child: Text(fso),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFSO = value;
                  });
                },
              ),

              // Select a due date
              ElevatedButton(
                onPressed: () => _selectDueDate(context),
                child: Text(dueDate == null ? 'Select Due Date' : 'Due Date: ${dueDate!.toLocal()}'),
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Assign Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

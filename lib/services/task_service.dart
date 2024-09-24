
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  final String baseUrl = 'https://your-backend-url.com'; // Replace with your backend URL

  // Fetch tasks assigned to an FSO
  Future<List<Task>> getAssignedTasks(String fsoId) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks?fso_id=$fsoId'));
    if (response.statusCode == 200) {
      final List tasks = json.decode(response.body);
      return tasks.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Create a new task and assign it to an FSO
  Future<void> createTask(String pestName, String surveyType, String fsoId, DateTime dueDate) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'pest_name': pestName,
        'survey_type': surveyType,
        'fso_id': fsoId,
        'due_date': dueDate.toIso8601String(),
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  // Mark a task as completed
  Future<void> completeTask(String taskId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': 'Completed'}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to complete task');
    }
  }
}

// Task model 
class Task {
  final String id;
  final String pestName;
  final String surveyType;
  final String fsoId;
  final DateTime dueDate;
  final String status;

  Task({
    required this.id,
    required this.pestName,
    required this.surveyType,
    required this.fsoId,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      pestName: json['pest_name'],
      surveyType: json['survey_type'],
      fsoId: json['fso_id'],
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'],
    );
  }
}

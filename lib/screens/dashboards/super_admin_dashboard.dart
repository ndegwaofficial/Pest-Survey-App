import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/forms/add_moderator_form.dart';
import 'package:postgres/postgres.dart';

class SuperAdminDashboard extends StatefulWidget {
  // Mark the constructor as const
  const SuperAdminDashboard({super.key}); // Added const

  @override
  _SuperAdminDashboardState createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final connection = PostgreSQLConnection(
      '127.0.0.1',
      5432,
      'pestsurveillance',
      username: 'ndegwaofficial',
      password: 'ndegwaofficial',
    );
    await connection.open();

    List<List<dynamic>> results = await connection.query('SELECT id, name, email, role FROM users');
    
    setState(() {
      _users = results.map((row) {
        return {
          'id': row[0],
          'name': row[1],
          'email': row[2],
          'role': row[3],
        };
      }).toList();
    });

    await connection.close();
  }

  void _navigateToAddModerator() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddModeratorForm()), // Mark as const if possible
    ).then((_) => _fetchUsers()); // Refresh user list after adding a moderator
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'), // Mark as const
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _navigateToAddModerator,
            child: const Text('Add Moderator'), // Mark as const
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('Role: ${user['role']}, Email: ${user['email']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

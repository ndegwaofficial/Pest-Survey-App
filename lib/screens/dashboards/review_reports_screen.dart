import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class ReviewReportsScreen extends StatefulWidget {
  @override
  _ReviewReportsScreenState createState() => _ReviewReportsScreenState();
}

class _ReviewReportsScreenState extends State<ReviewReportsScreen> {
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'postgres',
      username: 'postgres',
      password: '',
    );
    await connection.open();

    List<List<dynamic>> results = await connection.query('SELECT id, pest_name, location, details FROM reports');
    
    setState(() {
      _reports = results.map((row) {
        return {
          'id': row[0],
          'pest_name': row[1],
          'location': row[2],
          'details': row[3],
        };
      }).toList();
    });

    await connection.close();
  }

  Future<void> _approveReport(int reportId) async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'postgres',
      username: 'postgres',
      password: '',
    );
    await connection.open();

    await connection.query('UPDATE reports SET status = @status WHERE id = @id', substitutionValues: {
      'status': 'approved',
      'id': reportId,
    });

    await connection.close();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Report approved'),
    ));

    _fetchReports(); // Refresh report list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Pest Reports'),
      ),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];

          return ListTile(
            title: Text(report['pest_name']),
            subtitle: Text('Location: ${report['location']}\nDetails: ${report['details']}'),
            trailing: ElevatedButton(
              onPressed: () {
                _approveReport(report['id']);
              },
              child: Text('Approve'),
            ),
          );
        },
      ),
    );
  }
}

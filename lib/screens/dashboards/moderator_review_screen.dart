import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';

class ModeratorReviewScreen extends StatelessWidget {
  const ModeratorReviewScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchPendingPests() async {
    final connection = PostgreSQLConnection(
      'localhost', 5432, 'pestsurveillance',
      username: 'postgres',
      password: '',
    );

    await connection.open();
    var results = await connection.query('''
      SELECT id, image_path, pest_name FROM pest_reports WHERE status = 'pending'
    ''');

    await connection.close();

    return results.map((row) => {
      'id': row[0],
      'image_path': row[1],
      'pest_name': row[2],
    }).toList();
  }

  Future<void> _approvePest(int pestId) async {
    final connection = PostgreSQLConnection(
      'localhost', 5432, 'pestsurveillance',
      username: 'postgres',
      password: '',
    );

    await connection.open();
    await connection.query('''
      UPDATE pest_reports
      SET status = 'approved'
      WHERE id = @id
    ''', substitutionValues: {'id': pestId});

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Pests')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPendingPests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pests = snapshot.data ?? [];

          return ListView.builder(
            itemCount: pests.length,
            itemBuilder: (context, index) {
              final pest = pests[index];
              return ListTile(
                leading: Image.file(File(pest['image_path'])),
                title: Text(pest['pest_name']),
                subtitle: Text('Pending approval'),
                trailing: ElevatedButton(
                  child: const Text('Approve'),
                  onPressed: () async {
                    await _approvePest(pest['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pest approved!'))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

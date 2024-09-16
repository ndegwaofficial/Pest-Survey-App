import 'package:postgres/postgres.dart';

Future<void> submitPestForApproval(
    String imagePath, String pestName, String description, double latitude, double longitude) async {
  final connection = PostgreSQLConnection(
    'localhost', 5432, 'pestsurveillance',
    username: 'postgres',
    password: '',
  );

  try {
    await connection.open();
    await connection.query('''
      INSERT INTO pest_reports (farmer_id, image_path, pest_name, description, location, status, created_at)
      VALUES (@farmer_id, @image_path, @pest_name, @description, POINT(@latitude, @longitude), 'pending', NOW())
    ''', substitutionValues: {
      'farmer_id': 1, // Replace with actual farmer ID
      'image_path': imagePath,
      'pest_name': pestName,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    });

    print('Pest submitted for approval.');
  } catch (e) {
    print('Error submitting pest: $e');
  } finally {
    await connection.close();
  }
}

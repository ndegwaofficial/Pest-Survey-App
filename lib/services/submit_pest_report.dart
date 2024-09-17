import 'package:postgres/postgres.dart';

Future<void> submitPestForApproval(
    String imagePath, String pestName, double latitude, double longitude) async {
  final connection = PostgreSQLConnection(
    '10.100.1.147', 5432, 'pestsurveillance',
    username: 'ndegwaofficial',
    password: 'ndegwaofficial',
  );

  try {
    await connection.open();
    await connection.query('''
      INSERT INTO pest_reports (image_path, pest_name, location, status, created_at)
      VALUES (@image_path, @pest_name, POINT(@latitude, @longitude), 'pending', NOW())
    ''', substitutionValues: {
      'image_path': imagePath,
      'pest_name': pestName,
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

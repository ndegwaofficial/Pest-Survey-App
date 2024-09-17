import 'package:postgres/postgres.dart';

class DatabaseService {
  final connection = PostgreSQLConnection(
    '10.100.1.147',  // 
    5432,    // Port number
    'pestsurveillance',  // Database name
    username: 'ndegwaofficial',  // Your database username
    password: 'ndegwaofficial',  // Your database password
  );

  Future<void> connect() async {
    await connection.open();
    print("Connected to PostgreSQL");
  }

  Future<void> saveSurveyData(Map<String, dynamic> formData) async {
    try {
      await connect();

      String officerName = formData['officer_name'];
      String timestamp = formData['timestamp'];
      String surveyType = formData['survey_type'] ?? 'Unknown';

      // Convert the formData map into a format suitable for inserting
      Map<String, dynamic> otherFields = formData..remove('officer_name')..remove('timestamp');

      // Save data to PostgreSQL
      await connection.query(
        '''
        INSERT INTO surveys (officer_name, timestamp, survey_type, other_fields)
        VALUES (@officer_name, @timestamp, @survey_type, @other_fields::json)
        ''',
        substitutionValues: {
          'officer_name': officerName,
          'timestamp': timestamp,
          'survey_type': surveyType,
          'other_fields': otherFields,  // Store other fields as JSON
        },
      );

      print('Survey saved successfully!');
    } catch (e) {
      print('Error saving survey: $e');
    } finally {
      await connection.close();
    }
  }
}

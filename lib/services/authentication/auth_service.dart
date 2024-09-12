import 'package:postgres/postgres.dart';

// AuthService manages logging in users
class AuthService {
  final connection = PostgreSQLConnection(
    'localhost', // for now localhost
    5432,
    'pestsurveillance', // DB Name
    username: 'ndegwaofficial',
    password: 'ndegwaofficial',
  );

  // Open connection if it's not already open
  Future<void> connect() async {
    if (connection.isClosed) {
      try {
        await connection.open(); // Ensure app establishes connection before performing any query
      } catch (e) {
        print('Error opening PostgreSQL connection: $e');
        rethrow; // You can handle this further depending on your needs
      }
    }
  }

  // Login function to check DB for user
  Future<Map<String, dynamic>?> login(String email, String password) async {
    // Ensure the connection is open before executing the query
    await connect();

    try {
      // Perform the query to find the user
      var results = await connection.query(
        'SELECT id, role, name FROM users WHERE email = @email AND password = @password',
        substitutionValues: { // Use email and password placeholders to prevent SQL Injection
          'email': email,
          'password': password,
        },
      );

      if (results.isNotEmpty) {
        var user = results.first.toColumnMap();
        return user; // Return user information
      } else {
        return null; // Return null if no user is found
      }
    } catch (e) {
      print('Error executing login query: $e');
      return null; // Handle query failure by returning null
    }
  }

  // Close the connection when not needed (optional)
  Future<void> disconnect() async {
    if (!connection.isClosed) {
      await connection.close();
    }
  }
}

import 'package:postgres/postgres.dart';


// AuthService manages logging in users
class AuthService {
  final connection = PostgreSQLConnection(
    'localhost', // for now localhost
    5432, 
    'pestsurveillance', //DB Name
    username: 'postgres', 
    password: '',
  );


  Future<void> connect() async {
    await connection.open(); //Ensure app establishes connection before performing any query
  }

//login() function to check DB for user
  Future<Map<String, dynamic>?> login(String email, String password) async {
    var results = await connection.query(
      'SELECT id, role, name FROM users WHERE email = @email AND password = @password',
      substitutionValues: { //use email and password placeholder to prevent SQL Injection
        'email': email,
        'password': password,
      },
    );


    if (results.isNotEmpty) {
      var user = results.first.toColumnMap();
      return user; //return user information
    } else {
      return null;
    }
  }
}

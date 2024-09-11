import 'package:flutter/material.dart';
import 'services/authentication/auth_service.dart';
import 'screens/dashboards/farmer_dashboard.dart';
import 'screens/dashboards/fso_dashboard.dart';
import 'screens/dashboards/moderator_dashboard.dart';


void main() {
  runApp(PestApp());
}

class PestApp extends StatelessWidget {
  const PestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pest Survey App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(), //set the initial screen as the Login Page
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
 //Handle login functionality, Allow Dynamic Updates to UI
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> { //Manage actual state of Login Screen
  final AuthService _authService = AuthService();

  // Login Logic (_logic() method responsible for authenticating user)
  Future<void> _login(String email, String password) async {
    var user = await _authService.login(email, password);
    if (user != null) {
      String role = user['role'];
      //Replace the current screen with the appropriate dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => _getDashboardForRole(role),
        ),
      );
    } else {
      // Handle login failure
    }
  }

// Method to decide which dashboard to display
  Widget _getDashboardForRole(String role) {
    if (role == 'FSO') return FSODashboard();
    if (role == 'Farmer') return FarmerDashboard();
    if (role == 'Moderator') return ModeratorDashboard();
    //TODO: Handle this error more robustly
    return Container(); // Return Empty container if role doesn't match any of the three. 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(hintText: 'Email'),
            ),
            const TextField(
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                _login('email@example.com', 'password123');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

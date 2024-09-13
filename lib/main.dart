import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/dashboards/landing_page.dart'; // Import the landing page
import 'services/authentication/auth_service.dart';
import 'screens/dashboards/farmer_dashboard.dart';
import 'screens/dashboards/fso_dashboard.dart';
import 'screens/dashboards/moderator_dashboard.dart';
import 'screens/dashboards/super_admin_dashboard.dart';
void main() {
  runApp(const PestApp());
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
      home: const LandingPage(), // Set the initial screen as the Landing Page
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Login Logic (_login() method responsible for authenticating user)
  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password';
      });
      return;
    }

    var user = await _authService.login(email, password);
    if (user != null) {
      String role = user['role'];
      // Replace the current screen with the appropriate dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => _getDashboardForRole(role),
        ),
      );
    } else {
      // Handle login failure
      setState(() {
        _errorMessage = 'Invalid login credentials';
      });
    }
  }

  // Method to decide which dashboard to display
  Widget _getDashboardForRole(String role) {
    if (role == 'FSO') return const FSODashboard();
    if (role == 'Farmer') return const FarmerDashboard();
    if (role == 'Moderator') return const ModeratorDashboard();
    if (role == 'Super Admin') return const SuperAdminDashboard();

    return const Scaffold(
      body: Center(
        child: Text('Error: Unknown role'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login, // Call the _login method
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

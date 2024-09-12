import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class AddModeratorForm extends StatefulWidget {
  @override
  _AddModeratorFormState createState() => _AddModeratorFormState();
}

class _AddModeratorFormState extends State<AddModeratorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final connection = PostgreSQLConnection(
        '127.0.0.1',
      5432,
      'pestsurveillance',
      username: 'ndegwaofficial',
      password: 'ndegwaofficial',
      );
      await connection.open();

      // Insert the new moderator into the database
      await connection.query('''
        INSERT INTO users (name, email, password, role) 
        VALUES (@name, @email, @password, @role)
      ''', substitutionValues: {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text, // In real cases, hash this!
        'role': 'Moderator',
      });

      await connection.close();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Moderator added successfully'),
      ));

      Navigator.pop(context); // Return to Super Admin Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Moderator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Moderator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

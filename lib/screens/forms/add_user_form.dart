import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'FSO'; // Default role

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

      // Insert the new user into the database
      await connection.query('''
        INSERT INTO users (name, email, password, role) 
        VALUES (@name, @email, @password, @role)
      ''', substitutionValues: {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text, // TODO: In production, hash this password
        'role': _selectedRole,
      });

      await connection.close();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$_selectedRole account created successfully'),
      ));

      Navigator.pop(context); // Return to the previous screen after adding the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add FSO/Farmer'),
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
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'FSO', child: Text('FSO')),
                  DropdownMenuItem(value: 'Farmer', child: Text('Farmer')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

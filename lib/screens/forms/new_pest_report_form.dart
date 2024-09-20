import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // For GPS coordinates
import 'package:pest_survey_app/services/submit_pest_report.dart';

class NewPestReportForm extends StatefulWidget {
  @override
  _NewPestReportFormState createState() => _NewPestReportFormState();
}

class _NewPestReportFormState extends State<NewPestReportForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pestNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker();

  Position? _currentPosition; // To store the current GPS position

  // Pick an image from the camera or gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera); // Change to gallery if needed

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Get the current GPS position
  Future<void> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    // Get the position if permissions are granted
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  // Submit the pest report
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload an image.')),
        );
        return;
      }

      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enable GPS to capture location.')),
        );
        return;
      }

      final pestName = _pestNameController.text;
      final description = _descriptionController.text;

      // Submit the pest report with all the details
      await submitPestForApproval(
        _image!,
        pestName,
        description,
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        context,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pest report submitted for moderator approval!')),
      );

      // Clear the form after submission
      _formKey.currentState?.reset();
      setState(() {
        _image = null;
        _currentPosition = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Pest Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Pest Name field
              TextFormField(
                controller: _pestNameController,
                decoration: InputDecoration(labelText: 'Pest Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pest name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Upload Image Button
              ElevatedButton(
                onPressed: _pickImage, // Pick an image when the button is pressed
                child: Text(_image == null ? 'Upload Image' : 'Change Image'),
              ),

              // Show selected image preview
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.file(_image!),
                ),

              SizedBox(height: 20),

              // GPS Coordinates (Capture GPS)
              ElevatedButton(
                onPressed: _getPosition,
                child: Text(_currentPosition == null
                    ? 'Capture GPS Coordinates'
                    : 'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
              ),

              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm, // Submit the form when pressed
                child: Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

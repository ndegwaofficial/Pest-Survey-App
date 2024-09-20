import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/forms/new_pest_report_form.dart';
import 'package:pest_survey_app/screens/forms/pest_scanner.dart';
import 'package:pest_survey_app/services/submit_pest_report.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'dart:io'; // For handling file
import 'package:path/path.dart' as path; // To work with file paths

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Navigate to Pest Scanner and capture image
                final Map<String, dynamic>? scanResult = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestScanner()),
                );

                if (scanResult != null) {
                  final String imagePath = scanResult['imagePath']; // Image file path
                  final String pestName = scanResult['pestName']; // Pest name from model

                  // Ask for pest details (pest description)
                  final pestDetails = await _askForPestDetails(context, pestName);

                  if (pestDetails != null) {
                    // Capture the location of the pest using GPS
                    final position = await _determinePosition(context);

                    if (position != null) {
                      // Submit the pest report with additional metadata (image, pest name, location)
                      await submitPestForApproval(
                        File(imagePath), // Submit the image as a File
                        pestDetails['pest_name']!,
                        pestDetails['description']!,
                        position.latitude,
                        position.longitude,
                        context
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pest submitted for moderator approval!')),
                      );
                    }
                  }
                }
              },
              child: const Text('Scan Pest'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewPestReportForm()), // Navigate to pest report form
                );
              },
              child: const Text('Report New Pest'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to ask for pest description
  Future<Map<String, String>?> _askForPestDetails(BuildContext context, String pestName) async {
    TextEditingController pestDescriptionController = TextEditingController();

    return await showDialog<Map<String, String>?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Pest Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: pestName, // Display the pest name returned by the model
                readOnly: true, // Make it non-editable since it's model-determined
                decoration: const InputDecoration(labelText: 'Pest Name'),
              ),
              TextFormField(
                controller: pestDescriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop({
                  'pest_name': pestName,
                  'description': pestDescriptionController.text,
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Function to get the current GPS position
  Future<Position?> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return null;
    }

    // When we reach here, permissions are granted and we can get the position.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

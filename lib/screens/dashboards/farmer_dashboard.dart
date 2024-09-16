import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/forms/new_pest_report_form.dart';
import 'package:pest_survey_app/screens/forms/pest_scanner.dart';
import 'package:pest_survey_app/services/submit_pest_report.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator

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
                final imagePath = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestScanner()),
                );

                if (imagePath != null) {
                  // Ask for pest details (pest name and description)
                  final pestDetails = await _askForPestDetails(context);

                  if (pestDetails != null) {
                    // Capture the location of the pest using GPS
                    final position = await _determinePosition(context); // context passed to handle GPS

                    if (position != null) {
                      // Submit the pest report with additional metadata
                      await submitPestForApproval(
                        imagePath,
                        pestDetails['pest_name']!,
                        pestDetails['description']!,
                        position.latitude,
                        position.longitude,
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

  // Function to ask for pest name and description
  Future<Map<String, String>?> _askForPestDetails(BuildContext context) async {
    TextEditingController pestNameController = TextEditingController();
    TextEditingController pestDescriptionController = TextEditingController();

    return await showDialog<Map<String, String>?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Pest Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pestNameController,
                decoration: const InputDecoration(hintText: 'Pest Name'),
              ),
              TextField(
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
                  'pest_name': pestNameController.text,
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
      // Location services are not enabled, return null.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return null.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, return null.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return null;
    }

    // When we reach here, permissions are granted and we can get the position.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

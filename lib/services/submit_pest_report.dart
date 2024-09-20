import 'dart:io';
import 'package:flutter/material.dart';  // To show SnackBars for error feedback
import 'package:postgres/postgres.dart';

Future<void> submitPestForApproval(
    File imageFile, String pestName, String description, double latitude, double longitude, BuildContext context) async {
  final connection = PostgreSQLConnection(
    '10.100.1.147', 5432, 'pestsurveillance',
    username: 'ndegwaofficial',
    password: 'ndegwaofficial',
  );

  try {
    await connection.open();

    // Simulate image upload - here you would actually handle the image upload and get the URL
    final String imageUrl = await _uploadImage(imageFile);

    // Inserting into database
    await connection.query('''
      INSERT INTO pest_reports (image_url, pest_name, description, location, status, created_at)
      VALUES (@image_url, @pest_name, @description, POINT(@latitude, @longitude), 'pending', NOW())
    ''', substitutionValues: {
      'image_url': imageUrl,  // Changed from image path to image URL
      'pest_name': pestName,
      'description': description,  // Included the description from form
      'latitude': latitude,
      'longitude': longitude,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pest submitted for approval successfully.')),
    );
  } catch (e) {
    print('Error submitting pest: $e');  // Logging the detailed error message

    // Show user-friendly error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to submit pest. Please try again. Error: $e')),
    );
  } finally {
    await connection.close();
  }
}

// Dummy image upload function
Future<String> _uploadImage(File imageFile) async {
  // Simulate image upload and return URL - replace this with actual image upload logic
  var path;
  return 'https://example.com/uploaded_images/${path.basename(imageFile.path)}';
}

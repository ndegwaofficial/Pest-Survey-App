import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../services/pest_detection_service.dart'; // Import the pest detection service

class PestScanner extends StatefulWidget {
  @override
  _PestScannerState createState() => _PestScannerState();
}

class _PestScannerState extends State<PestScanner> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late PestDetectionService _pestDetectionService; // Add pest detection service

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _pestDetectionService = PestDetectionService(); // Initialize the pest detection service
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

Future<void> _captureAndDetect() async {
  try {
    await _initializeControllerFuture; // Wait for the camera to initialize

    // Take the picture and get the XFile object
    final XFile image = await _controller.takePicture();

    // Save the image to the temporary directory
    final tempDir = await getTemporaryDirectory();
    final imagePath = '${tempDir.path}/${DateTime.now()}.jpg';
    final File imageFile = File(image.path); // Convert XFile to File
    await imageFile.copy(imagePath); // Copy the image to the desired location

    // Pass the image path and continue with pest identification
    String pestName = await _pestDetectionService.identifyPest(File(imagePath));
    Navigator.pop(context, {
      'imagePath': imagePath,
      'pestName': pestName,
    });
    
  } catch (e) {
    print('Error during capture and detection: $e');
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Pest')),
      // FutureBuilder will only display the camera preview after the camera is fully initialized
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the future is complete, display the camera preview
            return CameraPreview(_controller);
          } else if (snapshot.hasError) {
            // If an error occurred, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Otherwise, display a loading spinner
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: _captureAndDetect, // Capture image and run the pest detection
      ),
    );
  }
}

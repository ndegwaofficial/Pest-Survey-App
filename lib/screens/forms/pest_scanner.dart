import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PestScanner extends StatefulWidget {
  @override
  _PestScannerState createState() => _PestScannerState();
}

class _PestScannerState extends State<PestScanner> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();
      setState(() {}); // Rebuild the widget after initializing the controller
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture; // Wait for the camera to initialize

      final image = await _controller.takePicture(); // Capture the image

      // Save image to temporary directory
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/${DateTime.now()}.jpg';
      final File imageFile = File(image.path);
      await imageFile.copy(imagePath);

      Navigator.pop(context, imagePath); // Return image path to the previous screen

    } catch (e) {
      print(e);
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
      // FutureBuilder will only display the camera preview only after camera is fully initialized
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
        onPressed: _takePicture, // Capture image when button is pressed
      ),
    );
  }
}

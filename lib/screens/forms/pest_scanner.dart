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
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
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
      appBar: AppBar(title: Text('Scan Pest')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller); // Display the camera preview
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: _takePicture, // Take picture when button is pressed
      ),
    );
  }
}

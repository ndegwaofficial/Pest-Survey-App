import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pest_survey_app/screens/forms/survey_form.dart';
import 'package:pest_survey_app/services/pest_detection_service.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';
import '../../services/pest_detection_service.dart';

class PestScanner extends StatefulWidget {
  @override
  _PestScannerState createState() => _PestScannerState();
}

class _PestScannerState extends State<PestScanner> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late PestDetectionService _pestDetectionService;
  bool _isProcessing = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _pestDetectionService = PestDetectionService();
  }

  Future<void> _initializeCamera() async {
     // Request camera permission
  var status = await Permission.camera.request();

  if (status.isGranted) {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    setState(() {});
  } else {
    setState(() {
      _result = 'Camera permission denied';
    });
  }
  }



  Future<void> _fetchPestDetails(String pestName) async {
  final connection = PostgreSQLConnection(
    'localhost',
    5432,
    'pestsurveillance',
    username: 'postgres',
    password: '',
  );

  await connection.open();

  var result = await connection.query('''
    SELECT * FROM pests WHERE name = @pestName
  ''', substitutionValues: {
    'pestName': pestName,
  });

  if (result.isNotEmpty) {
    var pestDetails = result.first.toColumnMap();
    setState(() {
      _result = 'Pest: ${pestDetails['name']}, Category: ${pestDetails['category']}';
    });
  } else {
    setState(() {
      _result = 'Pest not found in database. Would you like to submit a detection survey?';
    });
    _showSurveyDialog(pestName);
  }

  await connection.close();
}

Future<void> _showSurveyDialog(String pestName) async {
  bool submitSurvey = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Pest Not Found'),
        content: Text('The pest "$pestName" was not found in the database. Would you like to submit a detection survey?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel
            },
          ),
          TextButton(
            child: Text('Submit Survey'),
            onPressed: () {
              Navigator.of(context).pop(true); // Proceed to survey
            },
          ),
        ],
      );
    },
  ) ?? false;

  if (submitSurvey) {
    _navigateToDetectionSurvey(pestName);
  }
}

void _navigateToDetectionSurvey(String pestName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SurveyForm(
        'detection',
        surveyType: 'detection',
        initialPestName: pestName, // Pre-fill the pest name
      ),
    ),
  );
}


Future<void> _captureAndDetect() async {
  if (!_controller.value.isInitialized) {
    return;
  }

  try {
    final tempDir = await getTemporaryDirectory();
    print("Temporary Directory: ${tempDir.path}"); // Debugging
    final imagePath = '${tempDir.path}/${DateTime.now()}.jpg';
    await _controller.takePicture(imagePath);

    setState(() {
      _isProcessing = true;
    });

    // Run pest detection
    String pestName = await _pestDetectionService.identifyPest(File(imagePath));

    // Fetch pest details from the database
    await _fetchPestDetails(pestName);

    setState(() {
      _isProcessing = false;
    });

  } catch (e) {
    setState(() {
      _result = 'Error occurred: $e';
      _isProcessing = false;
    });
  }
}

//Dispose camera controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pest Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CameraPreview(_controller),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isProcessing
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _captureAndDetect,
                        child: Text('Capture Pest'),
                      ),
                SizedBox(height: 20),
                Text(_result, style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

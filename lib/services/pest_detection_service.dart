// import 'dart:io';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:image/image.dart' as img;

// class PestDetectionService {
//   late Interpreter _interpreter;
  
//   PestDetectionService() {
//     _loadModel();
//   }

//   // Load the TFLite model
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('pest_model.tflite'); // Put your TFLite model in assets folder
//       print("Model loaded successfully");
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//   }

//   // Process the image and run the model to identify the pest
//   Future<String> identifyPest(File imageFile) async {
//     final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
//     if (image == null) return "Unknown Pest";

//     // Preprocess the image (resize, normalize, etc.)
//     var input = _preprocessImage(image);

//     // Prepare output tensor (adjust size based on your model's output)
//     var output = List.filled(1 * 1, 0).reshape([1, 1]);

//     _interpreter.run(input, output);

//     return _getPestNameFromOutput(output[0][0]);
//   }

//   // Preprocess the image to the size required by your model (resize, normalize, etc.)
//   List<List<List<double>>> _preprocessImage(img.Image image) {
//     img.Image resizedImage = img.copyResize(image, width: 224, height: 224); // Example size

//     List<List<List<double>>> processedImage = List.generate(
//       224, // Image width
//       (x) => List.generate(
//         224, // Image height
//         (y) => [ // Image channels (RGB)
//           resizedImage.getPixel(x, y).toDouble(),
//         ],
//       ),
//     );

//     return processedImage;
//   }

//   // Convert the model's output to a pest name
//   String _getPestNameFromOutput(int output) {
//     // Map the model's output to a pest name
//     switch (output) {
//       case 0:
//         return 'Pest A';
//       case 1:
//         return 'Pest B';
//       // Add more cases for each class on country pest data
//       default:
//         return 'Unknown Pest';
//     }
//   }
// }

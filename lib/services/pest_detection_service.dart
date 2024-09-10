import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class PestDetectionService {
  late Interpreter interpreter;
  late List<String> labels;
  late ImageProcessor imageProcessor;

  PestDetectionService() {
    _initialize();
  }

  // Load the TensorFlow Lite model and labels
  Future<void> _initialize() async {
    interpreter = await Interpreter.fromAsset('pest_model.tflite'); // Add your .tflite model in assets
    labels = await _loadLabels();
    
    // Create image processor for resizing, normalization etc.
    imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();
  }

  Future<List<String>> _loadLabels() async {
    final labelData = await File('assets/labels.txt').readAsLines(); // Add labels file in assets
    return labelData;
  }

  // Run inference on an image
  Future<String> identifyPest(File imageFile) async {
    img.Image imageInput = img.decodeImage(imageFile.readAsBytesSync())!;
    TensorImage inputImage = TensorImage.fromImage(imageInput);

    // Process image (resize, normalize, etc.)
    inputImage = imageProcessor.process(inputImage);

    // Define input/output tensors
    var outputBuffer = TensorBuffer.createFixedSize([1, labels.length], TfLiteType.float32);

    // Run inference
    interpreter.run(inputImage.buffer, outputBuffer.buffer);

    // Get the label with the highest confidence score
    var output = outputBuffer.getDoubleList();
    var predictedIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));

    return labels[predictedIndex];
  }
}

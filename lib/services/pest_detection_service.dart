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

  Future<void> _initialize() async {
    try {
      interpreter = await Interpreter.fromAsset('pest_model.tflite');
      labels = await _loadLabels();
      
      imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
          .add(NormalizeOp(0, 255))
          .build();
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  Future<List<String>> _loadLabels() async {
    try {
      final labelData = await File('assets/labels.txt').readAsLines();
      return labelData;
    } catch (e) {
      throw Exception('Failed to load labels: $e');
    }
  }

  Future<String> identifyPest(File imageFile) async {
    try {
      img.Image imageInput = img.decodeImage(imageFile.readAsBytesSync())!;
      TensorImage inputImage = TensorImage.fromImage(imageInput);

      inputImage = imageProcessor.process(inputImage);

      var outputBuffer = TensorBuffer.createFixedSize([1, labels.length], TfLiteType.float32);
      interpreter.run(inputImage.buffer, outputBuffer.buffer);

      var output = outputBuffer.getDoubleList();
      var predictedIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));

      return labels[predictedIndex];
    } catch (e) {
      throw Exception('Pest detection failed: $e');
    }
  }
}

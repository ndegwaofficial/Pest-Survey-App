import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';
import 'dart:typed_data';

class ExcelService {
  final String filePath; // Keep the filePath variable

  ExcelService(this.filePath);

  // Load and parse Excel file from assets
  Future<Map<String, List<String>>> loadSurveyFields() async {
    // Load the file from assets using rootBundle
    ByteData data = await rootBundle.load('assets/$filePath');
    List<int> fileBytes = data.buffer.asUint8List();

    // Decode the bytes into an Excel object
    var excel = Excel.decodeBytes(fileBytes);

    // Store fields from different survey types
    Map<String, List<String>> surveys = {
      'delimiting': [],
      'monitoring': [],
      'detection': []
    };

    // Iterate through the sheets
    for (var sheet in excel.tables.keys) {
      if (sheet.toLowerCase() == 'delimiting') {
        surveys['delimiting'] = _getFieldsFromSheet(excel.tables[sheet]!);
      } else if (sheet.toLowerCase() == 'monitoring') {
        surveys['monitoring'] = _getFieldsFromSheet(excel.tables[sheet]!);
      } else if (sheet.toLowerCase() == 'detection') {
        surveys['detection'] = _getFieldsFromSheet(excel.tables[sheet]!);
      }
    }

    return surveys;
  }

  // Extract fields from a sheet
  List<String> _getFieldsFromSheet(Sheet sheet) {
    List<String> fields = [];

    for (var row in sheet.rows) {
      if (row.isNotEmpty && row.first != null) {
        fields.add(row.first!.toString());
      }
    }

    return fields;
  }
}

import 'package:excel/excel.dart';
import 'dart:io';

class ExcelService {
   String filePath = 'surveillance_form.xlsx';

  ExcelService(this.filePath);

  // Load and parse Excel file
  Future<Map<String, List<String>>> loadSurveyFields() async {
    var fileBytes = File(filePath).readAsBytesSync(); //get the file as bytes
    var excel = Excel.decodeBytes(fileBytes); //decode the bytes into an excel object

    //Store fields from different survey types
    Map<String, List<String>> surveys = {
      'delimiting': [],
      'monitoring': [],
      'detection': []
    };

    //iterate through the sheet
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

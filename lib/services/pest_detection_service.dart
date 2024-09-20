import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PestDetectionService {
  Future<String> identifyPest(File imageFile) async {
    try {
      // Replace with your deployed Streamlit server URL
      final uri = Uri.parse('https://your-streamlit-server-url/predict');

      // Prepare the request
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Send the request and get the response
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        return data['pest_name']; // Assuming the server returns a 'pest_name' field
      } else {
        throw Exception('Failed to identify pest: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during pest identification: $e');
    }
  }
}

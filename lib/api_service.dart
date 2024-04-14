import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> query(Map<String, dynamic> payload) async {
  // Your API endpoint
  const String apiUrl =
      'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2';

  // Headers required for the API request
  final Map<String, String> headers = {
    'Authorization': 'Bearer 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',
    'Content-Type': 'application/json',
  };

  // Making the API request
  final http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to query model: ${response.statusCode}');
  }
}

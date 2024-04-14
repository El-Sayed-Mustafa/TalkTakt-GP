import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrammarHint extends StatefulWidget {
  final String userMessage;

  const GrammarHint({
    Key? key,
    required this.userMessage,
  }) : super(key: key);

  @override
  _GrammarHintState createState() => _GrammarHintState();
}

class _GrammarHintState extends State<GrammarHint> {
  String apiResponse = ''; // Store API response
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchApiResponse();
  }

  Future<void> fetchApiResponse() async {
    try {
      // Your API endpoint
      const String apiUrl =
          'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2';

      // Headers required for the API request
      final Map<String, String> headers = {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
      };
      String inputPrompt =
          "<s>[INST]Correct any grammar errors in the following sentence and provide a brief explanation in one sentence: \"${widget.userMessage}\" If there are no errors, please write 'NONE'.[/INST]";

      // Making the API request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          "inputs": inputPrompt,
          "parameters": {
            "max_new_tokens": 50,
            "temperature": 0.7,
            "top_k": 10,
            "top_p": 0.9,
            "min_length": 20,
            "repetition_penalty": 1,
            "stop": ["EOS"]
          }
        }),
      );

      if (response.statusCode == 200) {
        // Extract the generated text from the response
        String generatedText = json.decode(response.body)[0]['generated_text'];

        // Remove the input prompt from the generated text
        generatedText = generatedText.replaceFirst(inputPrompt, '').trim();

        setState(() {
          // Store the filtered generated text
          apiResponse = generatedText;
        });
      } else {
        throw Exception('Failed to query model: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the response contains 'NONE' (case-insensitive)
    bool containsNone = apiResponse.toLowerCase().contains('none');

    // Show the GrammarHint widget only if response does not contain 'NONE'
    if (!containsNone) {
      return Center(
        child: Container(
          height: 30,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.tips_and_updates,
                  color: Color.fromARGB(255, 246, 246, 129),
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                  if (isExpanded && apiResponse.length > 50) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Grammer Correction'),
                          content: Text(apiResponse),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              Expanded(
                child: Text(
                  apiResponse.isEmpty
                      ? 'Check Grammar ...' // Display loading message if response is not fetched yet
                      : apiResponse.length > 50 && !isExpanded
                          ? '${apiResponse.substring(0, 50)}...' // Truncate text if longer than 50 characters and not expanded
                          : apiResponse, // Display full text if less than or equal to 50 characters or expanded
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox(); // Return an empty SizedBox if response contains 'NONE'
    }
  }
}

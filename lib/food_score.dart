import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IngredientSafetyChecker extends StatefulWidget {
  String scannedText;
  IngredientSafetyChecker({super.key,required this.scannedText});

  @override
  _IngredientSafetyCheckerState createState() => _IngredientSafetyCheckerState();
}

class _IngredientSafetyCheckerState extends State<IngredientSafetyChecker> {
  final List<String> ingredients = ['sugar', 'salt', 'artificial colorings','abeSaale','Banana'];
  String result = '';

  Future<void> checkIngredientSafety() async {
    const apiKey = "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";
    const endpoint = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a assistant kind of - to the point"},
          // {"role": "user", "content": "I want to know if the ingredients in my food are safe - sugar, banana, artificial colourings, hathat "},
          // {"role": "system", "content": "salt, sugar and aritificial colourings are not healthy ingredients. hathat is not recognised as an ingredient."},
          {"role": "user", "content": "Write down only the names of unhealhty and healhty ingredients from the list- ${widget.scannedText}, also give the foodScore out of 100 based on the ingredients"},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        result = data['choices'][0]['message']['content'];
      });
    } else {
      setState(() {
        result = 'Error ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.scannedText);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Safety Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                checkIngredientSafety();
              },
              child: const Text('Check Ingredient Safety'),
            ),
            const SizedBox(height: 20),
            Text('Result: $result'),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class Gemini extends StatefulWidget {
  const Gemini({super.key});

  @override
  State<Gemini> createState() => _GeminiState();
}

class _GeminiState extends State<Gemini> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GeminiProApi {
  final String _baseUrl = 'https://api.geminipro.io/v1';

  Future<GeminiProApiResponse> getNutritionInfoForIngredients(
      List<String> ingredients) async {
    final _url = '$_baseUrl/nutrition/';
    final _body = json.encode({"ingredients": ingredients});

    final _response =
    await http.post(_url as Uri, headers: {"Content-Type": "application/json"}, body: _body);

    if (_response.statusCode == 200) {
      return GeminiProApiResponse.fromJson(json.decode(_response.body));
    } else {
      throw Exception('Failed to get nutrition info: ${_response.statusCode}');
    }
  }
}

class GeminiProApiResponse {
  final bool isHealthy;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;

  GeminiProApiResponse(this.isHealthy, this.calories, this.protein, this.carbohydrates, this.fat);

  factory GeminiProApiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiProApiResponse(
      json['isHealthy'],
      json['calories'],
      json['protein'],
      json['carbohydrates'],
      json['fat'],
    );
  }
}

void main() async {
  // Create an instance of the API client
  final geminiProApi = GeminiProApi();

  // Get a list of ingredients from the user
  final ingredients = ['apple', 'banana', 'spinach', 'chicken breast'];

  // Call the API to get nutrition information for the ingredients
  final apiResponse = await geminiProApi.getNutritionInfoForIngredients(ingredients);

  // Display the results to the user
  print('Is healthy: ${apiResponse.isHealthy}');
  print('Calories: ${apiResponse.calories}');
  print('Protein: ${apiResponse.protein}');
  print('Carbohydrates: ${apiResponse.carbohydrates}');
  print('Fat: ${apiResponse.fat}');
}
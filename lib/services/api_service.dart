import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<MealCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categories = data['categories'];
      return categories
          .map((json) => MealCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'];
      return meals
          .map((json) => MealSummary.fromFilterJson(json, category))
          .toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<List<MealSummary>> searchMeals(String query) async {
    final response =
    await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List? meals = data['meals'];
      if (meals == null) return [];
      return meals
          .map((json) => MealSummary.fromSearchJson(json))
          .toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  static Future<MealDetail> fetchMealDetail(String id) async {
    final response =
    await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0];
      return MealDetail.fromJson(meal);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  static Future<MealDetail> fetchRandomMeal() async {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0];
      return MealDetail.fromJson(meal);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}

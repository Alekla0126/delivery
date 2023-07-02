import 'package:http/http.dart' as http;
import 'category.dart';
import 'dart:convert';
import 'dart:async';

class CategoryProvider {
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://run.mocky.io/v3/058729bd-1402-4578-88de-265481fd7d54'),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('The connection has timed out!');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final categoriesData = jsonData['сategories'] as List<dynamic>;
        return categoriesData
            .map((categoryData) => Category.fromJson(categoryData))
            .toList();
      } else {
        throw Exception('Failed to load categories!');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
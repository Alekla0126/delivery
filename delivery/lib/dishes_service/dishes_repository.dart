import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dishes.dart';

class DishesRepository {
  Future<List<Dish>> fetchDishes() async {
    final response = await http.get(Uri.parse('https://run.mocky.io/v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['dishes'];
      return jsonResponse.map((dish) => Dish.fromJson(dish)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}

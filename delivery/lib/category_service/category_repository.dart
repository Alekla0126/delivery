import 'category_provider.dart';
import 'category.dart';

class CategoryRepository {
  final CategoryProvider categoryDataProvider;

  CategoryRepository({required this.categoryDataProvider});

  Future<List<Category>> fetchCategories() async {
    try {
      return await categoryDataProvider.fetchCategories();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
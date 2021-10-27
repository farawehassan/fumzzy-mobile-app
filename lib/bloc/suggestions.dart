import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/product.dart';

/// This class loads all products while entering data in the sales record
class Suggestions {

  /// This method checks whether the [query] matches any available product
  /// It returns a list of product names it matches [matches]
  static Future<List<Product>> getSuggestions(String query, List<Product> products) async {
    if(products.isEmpty) await Future.delayed(Duration(seconds: 1));

    List<Product> matches = [];
    matches.addAll(products);

    matches.retainWhere((s) => s.productName!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  /// This method checks whether the [query] matches any available category
  /// It returns a list of category names it matches [matches]
  static Future<List<Category>> getCategorySuggestions(String query, List<Category> category) async {
    if(category.isEmpty) await Future.delayed(Duration(seconds: 1));

    List<Category> matches = [];
    matches.addAll(category);

    matches.retainWhere((s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
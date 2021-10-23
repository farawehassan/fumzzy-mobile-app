import 'dart:async';
import 'package:fumzy/database/user-db-helper.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/networking/product-datasource.dart';

class FutureValues{

  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class
  Future<User> getCurrentUser() async{
    var dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    return user;
  }

  /// A function that fetches all products in the database with the help of
  /// [ProductDataSource]
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllProducts({bool? refresh, int? page, limit}) async{
    var data = ProductDataSource();
    Future<Map<String, dynamic>> products = data.getAllProducts(refresh: refresh, page: page, limit: limit);
    return products;
  }

  /// A function that fetches all products in the database with the help of
  /// [ProductDataSource]
  /// It returns list of model [Category]
  Future<List<Category>> getAllCategories() async{
    var data = ProductDataSource();
    Future<List<Category>> categories = data.getAllCategories();
    return categories;
  }

}
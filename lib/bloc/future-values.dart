import 'dart:async';
import 'package:fumzy/database/user-db-helper.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/customer-names.dart';
import 'package:fumzy/model/expense.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/networking/customer-datasource.dart';
import 'package:fumzy/networking/expense-datasource.dart';
import 'package:fumzy/networking/product-datasource.dart';
import 'package:fumzy/networking/user-datasource.dart';

class FutureValues{

  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class
  Future<User> getCurrentUser() async{
    var dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    return user;
  }

  /// Method to get the current user and update the details in the database using the
  /// value [DatabaseHelper] class and update in the sqlite table
  Future<void> updateUser() async {
    var data = UserDataSource();
    var db = DatabaseHelper();
    await data.getCurrentUser().then((value) async {
      await db.updateUser(value);
    }).catchError((error) {
      print(error);
    });
  }

  /// A function that fetches all purchases in the database with the help of
  /// [ProductDataSource] - paginated
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllPurchasesPaginated({bool? refresh, int? page, limit}) async{
    var data = ProductDataSource();
    Future<Map<String, dynamic>> purchases = data.getAllPurchasesPaginated(refresh: refresh, page: page, limit: limit);
    return purchases;
  }

  /// A function that fetches all products in the database with the help of
  /// [ProductDataSource]
  /// It returns list of model [Product]
  Future<List<Product>> getAllProducts({bool? refresh}) async{
    var data = ProductDataSource();
    Future<List<Product>> products = data.getAllProducts(refresh: refresh);
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

  /// A function that fetches all customers name in the database with the help of
  /// [CustomerDataSource]
  /// It returns list of model [CustomerName]
  Future<List<CustomerName>> getAllCustomerNames() async{
    var data = CustomerDataSource();
    Future<List<CustomerName>> names = data.getAllCustomerNames();
    return names;
  }

  ///A function that fetches all expenses in the database with the help of
  ///[ExpenseDataSource]
  ///It returns a list of model[Expense]
  Future<Map<String, dynamic>> getAllExpense({bool? refresh}) async{
    var data = ExpenseDataSource();
    Future<Map<String, dynamic>> expenses = data.getAllExpenses(refresh: refresh);
    return expenses;
  }
}
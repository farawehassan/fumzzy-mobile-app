import 'dart:async';
import 'package:fumzy/database/user-db-helper.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/model/customer-names.dart';
import 'package:fumzy/model/expense.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/model/repayment-history.dart';
import 'package:fumzy/model/store-charts.dart';
import 'package:fumzy/model/store.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/model/staffs.dart';
import 'package:fumzy/networking/creditor-datasource.dart';
import 'package:fumzy/networking/customer-datasource.dart';
import 'package:fumzy/networking/expense-datasource.dart';
import 'package:fumzy/networking/product-datasource.dart';
import 'package:fumzy/networking/sales-datasource.dart';
import 'package:fumzy/networking/store-datasource.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/networking/staff-datasource.dart';

class FutureValues{

  /// Method to get the current [report] in the database using the
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

  /// A function that fetches all staff in the database with the help of
  /// [StaffDataSource]
  /// It returns list of model [Staffs]
  Future<List<Staffs>> getAllStaff({bool? refresh}) async{
    var data = StaffDataSource();
    Future<List<Staffs>> staffs = data.getAllStaff(refresh: refresh);
    return staffs;
  }

  /// A function that fetches all sales in the database with the help of
  /// [SalesDataSource] - paginated
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllSalesPaginated({bool? refresh, String? searchWord, int? page, limit}) async{
    var data = SalesDataSource();
    Future<Map<String, dynamic>> sales = data.getAllSales(refresh: refresh, searchWord: searchWord, page: page, limit: limit);
    return sales;
  }

  /// A function that fetches all sales in the database with the help of
  /// [SalesDataSource] - paginated
  /// It returns a Map of [<String, dynamic>]
  /*Future<Map<String, dynamic>> getAllSalesDate({String? startDate, String? endDate}) async{
    var data = SalesDataSource();
    Future<Map<String, dynamic>> sales = data.getAllSalesDate(startDate: startDate, endDate: endDate);
    return sales;
  }*/

  /// A function that fetches all purchases in the database with the help of
  /// [ProductDataSource] - paginated
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllPurchasesPaginated({bool? refresh, String? searchWord, int? page, limit}) async{
    var data = ProductDataSource();
    Future<Map<String, dynamic>> purchases = data.getAllPurchasesPaginated(refresh: refresh, searchWord: searchWord, page: page, limit: limit);
    return purchases;
  }

  /// A function that fetches all product purchases in the database with the help of
  /// [ProductDataSource] - paginated
  /// It returns a [Map]
  Future<Map<String, dynamic>> getProductPurchases(String productId, {String? searchWord, int? page, limit}) async{
    var data = ProductDataSource();
    Future<Map<String, dynamic>> purchases = data.getProductPurchases(productId, searchWord: searchWord, page: page, limit: limit);
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
  Future<Map<String, dynamic>> getAllExpense({bool? refresh, String? searchWord, int? page, limit}) async{
    var data = ExpenseDataSource();
    Future<Map<String, dynamic>> expenses = data.getAllExpenses(refresh: refresh, searchWord: searchWord, page: page, limit: limit);
    return expenses;
  }

  /// A function that fetches all customers in the database with the help of
  /// [ProductDataSource] - paginated
  /// It returns a [Map]
  Future<Map<String, dynamic>> getAllCustomersPaginated({bool? refresh, String? searchWord, int? page, limit}) async{
    var data = CustomerDataSource();
    Future<Map<String, dynamic>> customers = data.getAllCustomersPaginated(refresh: refresh, searchWord: searchWord, page: page, limit: limit);
    return customers;
  }

  /// A function that fetches all debtors in the database with the help of
  /// [ProductDataSource] - paginated
  /// It returns a [Map]
  Future<Map<String, dynamic>> getAllDebtorsPaginated({bool? refresh, String? searchWord, int? page, limit}) async{
    var data = CustomerDataSource();
    Future<Map<String, dynamic>> customers = data.getAllDebtorsPaginated(refresh: refresh, searchWord: searchWord, page: page, limit: limit);
    return customers;
  }

  /// A function that fetches all creditors in the database with the help of
  /// [CreditorDataSource] - paginated
  /// It returns a [Map]
  Future<Map<String, dynamic>> getAllCreditorsPaginated({bool? refresh, String? searchWord, int? page, limit}) async{
    var data = CreditorDataSource();
    Future<Map<String, dynamic>> creditors = data.getAllCreditorsPaginated(refresh: refresh, searchWord: searchWord, page: page, limit: limit);
    return creditors;
  }

  /// A function that fetches all customers name in the database with the help of
  /// [CreditorDataSource]
  /// It returns list of model [Creditor]
  Future<List<Creditor>> getAllCreditors() async{
    var data = CreditorDataSource();
    Future<List<Creditor>> creditors = data.getAllCreditors();
    return creditors;
  }

  /// A function that fetches customer repayment history in the database with
  /// the help of [CustomerDataSource]
  /// It returns list of model [RepaymentHistory]
  Future<List<RepaymentHistory>> getRepaymentHistory(String customer, String reportId) async{
    var data = CustomerDataSource();
    Future<List<RepaymentHistory>> history = data.getRepaymentHistory(customer, reportId);
    return history;
  }

  /// A function that fetches all customers name in the database with the help of
  /// [StoreDataSource]
  /// It returns model [Store]
  Future<Store> getStoreInformation({bool? refresh}) async{
    var data = StoreDataSource();
    Future<Store> store = data.getAllStoreInformation(refresh: refresh);
    return store;
  }

  /// A function that fetches all customers name in the database with the help of
  /// [StoreDataSource]
  /// It returns model [StoreCharts]
  Future<StoreCharts> getStoreChartsInformation({bool? refresh}) async{
    var data = StoreDataSource();
    Future<StoreCharts> store = data.getAllStoreChartsInformation(refresh: refresh);
    return store;
  }

}
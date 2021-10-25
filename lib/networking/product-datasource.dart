import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/model/purchases.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class ProductDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  /// A function that fetches all purchases in the database GET
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllPurchasesPaginated({bool? refresh, int? page, int? limit}) async {
    Map<String, dynamic> result = {};
    String fileName = 'purchases.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      List<Purchase> allPurchases = [];
      var rest = res['data']['items'] as List;
      allPurchases = rest.map<Purchase>((json) => Purchase.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = allPurchases;
      return result;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      String GET_ALL_PURCHASES_URL = GET_ALL_PURCHASES_PAGINATED + '?page=$page&limit=$limit';
      return _netUtil.get(GET_ALL_PURCHASES_URL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        List<Purchase> allPurchases = [];
        var rest = res['data']['items'] as List;
        allPurchases = rest.map<Purchase>((json) => Purchase.fromJson(json)).toList();
        result['totalCount'] = res['data']['totalCount'];
        result['page'] = res['data']['page'];
        result['items'] = allPurchases;
        return result;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /// A function that fetches all products in the database GET
  /// It returns a list of [Product]
  Future<List<Product>> getAllProducts({bool? refresh}) async {
    List<Product> products = [];
    String fileName = 'products.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      var rest = res['data'] as List;
      products = rest.map<Product>((json) => Product.fromJson(json)).toList();
      return products;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      return _netUtil.get(GET_ALL_PRODUCTS, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        var rest = res['data'] as List;
        products = rest.map<Product>((json) => Product.fromJson(json)).toList();
        return products;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /// A function that fetches all categories in the database GET
  /// It returns a list of mode [Category]
  Future<List<Category>> getAllCategories() async {
    List<Category> categories = [];
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.get(GET_ALL_CATEGORIES, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      var rest = res['data'] as List;
      categories = rest.map<Category>((json) => Category.fromJson(json)).toList();
      return categories;
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a category with [body] as details
  /// A post request to use the [ADD_CATEGORY] endpoint
  /// It returns a [String]
  Future<dynamic> createCategory(Map<String, String> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(CREATE_CATEGORY, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/product.dart';
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

  /// A function that fetches all products in the database GET
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllProducts({bool? refresh, int? page, int? limit}) async {
    Map<String, dynamic> result = {};
    String fileName = 'products.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      List<Product> allProducts = [];
      var rest = res['data']['items'] as List;
      allProducts = rest.map<Product>((json) => Product.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = allProducts;
      return result;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      String GET_ALL_PRODUCTS_URL = GET_ALL_PRODUCTS + '?page=$page&limit=$limit';
      return _netUtil.get(GET_ALL_PRODUCTS_URL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        List<Product> allProducts = [];
        var rest = res['data']['items'] as List;
        allProducts = rest.map<Product>((json) => Product.fromJson(json)).toList();
        result['totalCount'] = res['data']['totalCount'];
        result['page'] = res['data']['page'];
        result['items'] = allProducts;
        return result;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /// A function that fetches all products in the database GET
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

}
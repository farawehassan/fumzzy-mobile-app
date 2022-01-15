import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/sales.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class SalesDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  /// A function that fetches all sales in the database GET
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllSales({bool? refresh, String? searchWord, int? page, int? limit}) async {
    Map<String, dynamic> result = {};
    String fileName = 'sales.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      List<Sale> sales = [];
      var rest = res['data']['items'] as List;
      sales = rest.map<Sale>((json) => Sale.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = sales;
      return result;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      String GET_ALL_SALES_URL = GET_ALL_SALES + '?page=$page&limit=$limit';
      if(searchWord != null) GET_ALL_SALES_URL = GET_ALL_SALES_URL + '&searchWord=$searchWord';
      return _netUtil.get(GET_ALL_SALES_URL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        List<Sale> sales = [];
        var rest = res['data']['items'] as List;
        sales = rest.map<Sale>((json) => Sale.fromJson(json)).toList();
        result['totalCount'] = res['data']['totalCount'];
        result['page'] = res['data']['page'];
        result['items'] = sales;
        return result;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /*/// A function that fetches all sales in the database GET
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllSalesDate({String? startDate, String? endDate}) async {
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String GET_ALL_SALES_URL = GET_ALL_SALES + '?page=$page&limit=$limit';
    return _netUtil.get(GET_ALL_SALES_URL, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      List<Sale> sales = [];
      var rest = res['data']['items'] as List;
      sales = rest.map<Sale>((json) => Sale.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = sales;
      return result;
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }*/

  /// A function that sends request for adding a sale with [body] as details
  /// A post request to use the [ADD_SALES] endpoint
  /// It returns a [String]
  Future<dynamic> addSales(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_SALES, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a sale with [body] as details
  /// A post request to use the [ADD_SALES] endpoint
  /// It returns a [String]
  Future<dynamic> deleteSales(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.delete(DELETE_SALE, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
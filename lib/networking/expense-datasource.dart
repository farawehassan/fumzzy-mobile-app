import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/expense.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class ExpenseDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  ///A function that fetches all expenses in the database GET
  ///It returns a list of [Expense]
  Future<Map<String, dynamic>> getAllExpenses({bool? refresh, String? searchWord, int? page, int? limit}) async {
    Map<String, dynamic> result = {};
    String fileName = 'expenses.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      List<Expense> expenses = [];
      var rest = res['data']['items'] as List;
      expenses = rest.map<Expense>((json) => Expense.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = expenses;
      return result;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      String GET_ALL_EXPENSES_URL = GET_ALL_EXPENSES + '?page=$page&limit=$limit';
      if(searchWord != null) GET_ALL_EXPENSES_URL = GET_ALL_EXPENSES_URL + '&searchWord=$searchWord';
      return _netUtil.get(GET_ALL_EXPENSES_URL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        List<Expense> expenses = [];
        var rest = res['data']['items'] as List;
        expenses = rest.map<Expense>((json) => Expense.fromJson(json)).toList();
        result['totalCount'] = res['data']['totalCount'];
        result['page'] = res['data']['page'];
        result['items'] = expenses;
        return result;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /// A function that sends request for creating an expense with [body] as details
  /// A post request to use the [CREATE_EXPENSES]
  /// It returns a [Message]
  Future<dynamic> createExpense(Map<String, dynamic> body) async {
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(CREATE_EXPENSES, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for delete an expense with [id] as details
  /// A delete request to use the [CREATE_EXPENSES]
  /// It returns a [Message]
  Future<dynamic> deleteExpense(String id) async {
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String DELETE_EXPENSES_URL = DELETE_EXPENSES + '/$id';
    return _netUtil.delete(DELETE_EXPENSES_URL, headers: header, body: {}).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
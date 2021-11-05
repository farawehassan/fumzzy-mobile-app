import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class CreditorDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  /// A function that fetches all creditors in the database GET
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllCreditorsPaginated({bool? refresh, int? page, int? limit}) async {
    Map<String, dynamic> result = {};
    String fileName = 'creditors-p.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      List<Creditor> allCreditors = [];
      var rest = res['data']['items'] as List;
      allCreditors = rest.map<Creditor>((json) => Creditor.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = allCreditors;
      return result;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      String GET_ALL_CREDITORS_URL = GET_ALL_CREDITORS_PAGINATED + '?page=$page&limit=$limit';
      return _netUtil.get(GET_ALL_CREDITORS_URL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        List<Creditor> allCreditors = [];
        var rest = res['data']['items'] as List;
        allCreditors = rest.map<Creditor>((json) => Creditor.fromJson(json)).toList();
        result['totalCount'] = res['data']['totalCount'];
        result['page'] = res['data']['page'];
        result['items'] = allCreditors;
        return result;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /// A function that fetches all creditors in the database GET
  /// It returns a list of [Creditor]
  Future<List<Creditor>> getAllCreditors() async {
    List<Creditor> creditors = [];
    Map<String, String> header = {};
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.get(GET_ALL_CUSTOMERS_NAME, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      var rest = res['data'] as List;
      creditors = rest.map<Creditor>((json) => Creditor.fromJson(json)).toList();
      return creditors;
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a new creditor with [body] as details
  /// A post request to use the [ADD_CREDITOR] endpoint
  /// It returns a [String]
  Future<dynamic> addNewCreditor(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_CREDITOR, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding credit with [body] as details
  /// A post request to use the [ADD_CREDIT] endpoint
  /// It returns a [String]
  Future<dynamic> addCredit(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_CREDIT, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for updating creditor reports with [body]
  ///  as details
  /// A post request to use the [UPDATE_CREDITOR] endpoint
  /// It returns a [String]
  Future<dynamic> updateCreditor(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.put(UPDATE_CREDITOR, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to remove report from a creditor's list of
  /// reports with [body] as details
  /// A put request to use the [REMOVE_CREDITS] endpoint
  /// It returns a [String]
  Future<dynamic> removeCreditor(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.put(REMOVE_CREDITS, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that deletes a creditor in the database PUT
  /// It returns a [String]
  Future<dynamic> deleteCreditor(String id) async {
    Map<String, String> header = {};
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String DELETE_CREDITOR_URL = DELETE_CREDITOR + '/$id';
    return _netUtil.delete(DELETE_CREDITOR_URL, body: {}, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
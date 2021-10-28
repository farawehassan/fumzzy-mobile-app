import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/all-customers.dart';
import 'package:fumzy/model/customer-names.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class CustomerDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  /// A function that fetches all customers in the database GET
  /// It returns a Map of [<String, dynamic>]
  Future<Map<String, dynamic>> getAllCustomersPaginated({bool? refresh, int? page, int? limit}) async {
    Map<String, dynamic> result = {};
    String fileName = 'customers.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      List<AllCustomers> allCustomers = [];
      var rest = res['data']['items'] as List;
      allCustomers = rest.map<AllCustomers>((json) => AllCustomers.fromJson(json)).toList();
      result['totalCount'] = res['data']['totalCount'];
      result['page'] = res['data']['page'];
      result['items'] = allCustomers;
      return result;
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      String GET_ALL_CUSTOMERS_URL = GET_ALL_CUSTOMERS + '?page=$page&limit=$limit';
      return _netUtil.get(GET_ALL_CUSTOMERS_URL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        List<AllCustomers> allCustomers = [];
        var rest = res['data']['items'] as List;
        allCustomers = rest.map<AllCustomers>((json) => AllCustomers.fromJson(json)).toList();
        result['totalCount'] = res['data']['totalCount'];
        result['page'] = res['data']['page'];
        result['items'] = allCustomers;
        return result;
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  /// A function that fetches all customer names in the database GET
  /// It returns a list of [CustomerName]
  Future<List<CustomerName>> getAllCustomerNames() async {
    List<CustomerName> names = [];
    Map<String, String> header = {};
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.get(GET_ALL_CUSTOMERS_NAME, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      var rest = res['data'] as List;
      names = rest.map<CustomerName>((json) => CustomerName.fromJson(json)).toList();
      return names;
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches a customer details in the database GET
  /// It returns a model of [CustomerName]
  Future<List<AllCustomers>> getCustomer(String id) async {
    List<AllCustomers> customer = [];
    Map<String, String> header = {};
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String GET_A_CUSTOMER_URL = GET_A_CUSTOMER + '/$id';
    return _netUtil.get(GET_A_CUSTOMER_URL + '/$id', headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      var rest = res['data'] as List;
      customer = rest.map<AllCustomers>((json) => AllCustomers.fromJson(json)).toList();
      return customer;
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that deletes a customer details in the database GET
  /// It returns a model of [String]
  Future<dynamic> deleteCustomer(String id) async {
    Map<String, String> header = {};
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String DELETE_CUSTOMER_URL = DELETE_CUSTOMER + '/$id';
    return _netUtil.get(DELETE_CUSTOMER_URL + '/$id', headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a new customer with [body] as details
  /// A post request to use the [ADD_NEW_CUSTOMER] endpoint
  /// It returns a [String]
  Future<dynamic> addNewCustomer(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_NEW_CUSTOMER, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a previous customer with [body] as details
  /// A post request to use the [ADD_PREVIOUS_CUSTOMER] endpoint
  /// It returns a [String]
  Future<dynamic> addPreviousCustomer(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_PREVIOUS_CUSTOMER, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a new reports to customer with
  /// [body] as details
  /// A post request to use the [ADD_NEW_REPORTS_TO_CUSTOMER] endpoint
  /// It returns a [String]
  Future<dynamic> addNewReportsCustomer(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_NEW_REPORTS_TO_CUSTOMER, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for adding a previous customer reports with
  /// [body] as details
  /// A post request to use the [ADD_PREVIOUS_CUSTOMER_REPORTS] endpoint
  /// It returns a [String]
  Future<dynamic> addPreviousCustomerReports(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(ADD_PREVIOUS_CUSTOMER_REPORTS, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to update a customer's reports with
  /// [body] as details
  /// A post request to use the [UPDATE_CUSTOMER_REPORT] endpoint
  /// It returns a [String]
  Future<dynamic> updateCustomerReports(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(UPDATE_CUSTOMER_REPORT, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to update the payment made with
  /// [body] as details
  /// A post request to use the [UPDATE_PAYMENT_MADE_REPORT] endpoint
  /// It returns a [String]
  Future<dynamic> updatePaymentMade(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(UPDATE_PAYMENT_MADE_REPORT, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to settle the payment of a customer's reports
  /// with [body] as details
  /// A post request to use the [SETTLE_PAYMENT] endpoint
  /// It returns a [String]
  Future<dynamic> settlePayment(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(SETTLE_PAYMENT, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to remove report from a customer's list of
  /// reports with [body] as details
  /// A post request to use the [REMOVE_CUSTOMER_REPORT] endpoint
  /// It returns a [String]
  Future<dynamic> removeReport(Map<String, dynamic> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.post(REMOVE_CUSTOMER_REPORT, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
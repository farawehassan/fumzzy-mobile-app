import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/staff.dart';
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
  ///
  Future<Map<String, dynamic>> getAllExpenses({bool? refresh}) async {
    Map<String, dynamic> result;
    String fileName = 'expense.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      return result;
    }
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.get(GET_ALL_EXPENSES, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      //file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
      List<Staff> allstaff = [];
      var rest = res['data']['staff'] as List;
      allstaff = rest.map<Staff>((json) => Staff.fromJson(json)).toList();
    })
  }

  /// A function that sends request for creating an expense with [body] as details
  /// A post request to use the [CREATE_EXPENSES]
  /// It returns a [Message]
  Future<dynamic> createExpense(Map<String, String> body) async {
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
}
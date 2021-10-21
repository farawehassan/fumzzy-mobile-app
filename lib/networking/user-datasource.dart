import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/user.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class UserDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  /// A function that sends request for sign in with [body] as details
  /// A post request to use the [LOGIN]
  /// It returns a [User] model
  Future<User> signIn(Map<String, String> body) async {
    Map<String, String> header = { 'Content-Type': 'application/json' };
    return _netUtil.post(LOGIN, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return User.fromJson(res['data']);
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for signing up user with [body] as details
  /// A post request to use the [SIGN_UP]
  /// It returns a [Message]
  Future<dynamic> signUP(Map<String, String> body) async {
    Map<String, String> header = { 'Content-Type': 'application/json' };
    return _netUtil.post(SIGN_UP, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for creating an expense with [body] as details
  /// A post request to use the [CREATE_EXPENSES]
  /// It returns an [Expense] model
  Future<dynamic> createExpense(Map<String, String> body) async {
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw("You're not authorized, log out and log in back and try again!");
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.post(CREATE_EXPENSES, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }
}
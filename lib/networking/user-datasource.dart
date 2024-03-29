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
    return _netUtil.post(LOGIN, headers: {}, body: body).then((dynamic res) {
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
    return _netUtil.post(SIGN_UP, headers: {}, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request for editing a user with [body] as details
  /// A post request to use the [EDIT_USER]
  /// It returns a [Message]
  Future<dynamic> editUser(Map<String, String> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.put(EDIT_USER, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function to get current user details from the database
  /// into a model of [User] GET.
  Future<User> getCurrentUser() async {
    Map<String, String>? header;
    String? token;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      token = value.token!;
      header = {'Authorization': 'Bearer $token'};
    });
    return _netUtil.get(GET_CURRENT_USER, headers: header).then((dynamic res) {
      if(res['error']) throw res['message'];
      User user = User.fromJson(res['data']);
      user.token = token;
      return user;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to change user pin with [body] as details
  /// A post request to use the [CHANGE_PIN]
  /// It returns a [Message]
  Future<dynamic> changePin(Map<String, String> body) async {
    Map<String, String>? header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.put(CHANGE_PIN, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to reset staff
  /// It returns a [Message]
  Future<dynamic> resetStaffPin(String usersId) async {
    Map<String, String>? header;
    String? userId = usersId;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String RESET_PIN_URL = RESET_PIN + '/$userId';
    return _netUtil.put(RESET_PIN_URL, headers: header, body: {}).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to block staff
  /// It returns a [Message]
  Future<dynamic> blockStaff(String usersId) async {
    Map<String, String>? header;
    String? userId = usersId;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String BLOCK_STAFF = USER_ACTION + '/$userId/block';
    return _netUtil.put(BLOCK_STAFF, headers: header, body: {}).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to activate staff
  /// It returns a [Message]
  Future<dynamic> activateStaff(String usersId) async {
    Map<String, String>? header;
    String? userId = usersId;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String ACTIVATE_STAFF = USER_ACTION + '/$userId/active';
    return _netUtil.put(ACTIVATE_STAFF, headers: header, body: {}).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

  /// A function that sends request to delete staff
  /// It returns a [Message]
  Future<dynamic> deleteStaff(String usersId) async {
    Map<String, String>? header;
    String? userId = usersId;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    String DELETE_STAFF = USER_ACTION + '/$userId/delete';
    return _netUtil.put(DELETE_STAFF, headers: header, body: {}).then((dynamic res) {
      if (res['error']) throw res['message'];
      return res['message'];
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }
}
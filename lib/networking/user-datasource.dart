import 'package:fumzy/model/user.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class UserDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// A function that sends request for sign i with [body] as details
  /// A post request to use the [LOGIN]
  /// It returns a [User] model
  Future<User> signIn(Map<String, String> body) async {
    Map<String, String> header = { 'Content-Type': 'application/json' };
    return _netUtil.post(LOGIN, headers: header, body: body).then((dynamic res) {
      if (res['error'] == 'true') throw res['message'];
      return User.fromJson(res['data']);
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
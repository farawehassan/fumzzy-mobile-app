import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class UserDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// A function that sends request for sign up with [body] as details
  /// A post request to use the [SIGN_UP_URL]
  /// It returns a [User] model
  /*Future<User> signUp(Map<String, String> body) async {
    Map<String, String> header = {};
    return _netUtil.post(SIGN_UP_URL, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['msg'];
      res['data']['user']['token'] = res['data']['token'];
      return User.fromJson(res['data']['user']);
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }  */

}
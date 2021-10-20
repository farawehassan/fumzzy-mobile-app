import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class UserDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// A function that sends request for log in with [body] as password
  /// A post request to use the [LOGIN]
  /// It returns a [User] model
  Future<User> login(Map<String, String> body) async {
    Map<String, String> header = {};
    return _netUtil.post(LOGIN, headers: header, body: body).then((dynamic res) {
      if (res['error']) throw res['msg'];
      res['data']['user']['token'] = res['data']['token'];
      return User.fromJson(res['data']['user']);
    }).catchError((e) {
      errorHandler.handleError(e);
    });
  }

}
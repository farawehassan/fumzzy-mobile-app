import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/staffs.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class StaffDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  ///A function that fetches all users in the database GET
  ///It returns a model of [Staffs]
  Future<List<Staffs>> getAllStaff({bool? refresh}) async {
    List<Staffs> result = [] ;
    String fileName = 'staff.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      var rest = res['data'];
      result = rest.map<Staffs>((json) => Staffs.fromJson(json)).toList();
      return result;
    }
    late Map<String, String> header;
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
      header = {'Authorization': 'Bearer ${value.token}'};
    });
    return _netUtil.get(GET_ALL_USERS, headers: header).then((dynamic res) {
      if (res['error']) throw res['message'];
      file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
      var rest = res['data'];
      result = rest.map<Staffs>((json) => Staffs.fromJson(json)).toList();
      return result;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

}
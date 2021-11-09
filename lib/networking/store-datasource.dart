import 'dart:convert';
import 'dart:io';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/model/store-charts.dart';
import 'package:fumzy/model/store.dart';
import 'package:fumzy/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'endpoints.dart';
import 'error-handler.dart';
import 'network-util.dart';

class StoreDataSource{

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  var _netUtil = NetworkHelper();

  /// Instantiating a class of the [FutureValues]
  var _futureValue = FutureValues();

  ///A function that fetches all information in the database GET
  ///It returns a model of [Store]
  Future<Store> getAllStoreInformation({bool? refresh}) async {
    String fileName = 'store.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      return Store.fromJson(res['data']);
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      return _netUtil.get(GET_STORE_DETAIL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        return Store.fromJson(res['data']);
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

  ///A function that fetches all information in the database GET
  ///It returns a model of [StoreCharts]
  Future<StoreCharts> getAllStoreChartsInformation({bool? refresh}) async {
    String fileName = 'store-charts.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      return StoreCharts.fromJson(res['data']);
    }
    else {
      late Map<String, String> header;
      Future<User> user = _futureValue.getCurrentUser();
      await user.then((value) {
        if(value.token == null) throw('You\'re not authorized, log out and log in back and try again!');
        header = {'Authorization': 'Bearer ${value.token}'};
      });
      return _netUtil.get(GET_STORE_CHARTS_DETAIL, headers: header).then((dynamic res) {
        if (res['error']) throw res['message'];
        file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
        return StoreCharts.fromJson(res['data']);
      }).catchError((e) {
        errorHandler.handleError(e);
      });
    }
  }

}

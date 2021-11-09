import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// A network helper class to do all the back end request
class NetworkHelper {

  /// next three lines makes this class a Singleton
  static NetworkHelper _instance = NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;

  /// An object for decoding json values
  final JsonDecoder _decoder = JsonDecoder();

  /// A function to do any get request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      headers!['Content-Type'] = 'application/json';
      return
        http
            .get(Uri.parse(url), headers: headers)
            .then((http.Response response) {
          final String res = response.body;
          final int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode > 400) throw ('Error occurred');
          return _decoder.convert(res);
        });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any post request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> post(String url, {Map<String, String>? headers, body, encoding}) {
    try {
      headers!['Content-Type'] = 'application/json';
      return http
          .post(Uri.parse(url), body: jsonEncode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) throw result['message'];
        return result;
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any post request of form data with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> postForm(String url, List<http.MultipartFile>? files, {Map<String, String>? header, body, encoding}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      if(header != null) request.headers.addAll(header);
      if(body != null) request.fields.addAll(body);
      if(files != null) request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final dynamic res = json.decode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) throw res['message'];
      return res;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any put request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> put(String url, {Map<String, String>? headers, body, encoding}) {
    try {
      headers!['Content-Type'] = 'application/json';
      return http
          .put(Uri.parse(url), body: jsonEncode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) throw result['message'];
        return result;
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any put request of form data with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> putForm(String url, List<http.MultipartFile>? files,
      {Map<String, String>? header, body, encoding}) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      if(header != null) request.headers.addAll(header);
      if(body != null) request.fields.addAll(body);
      if(files != null) request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final dynamic res = json.decode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) throw res['message'];
      return res;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any delete request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> delete(String url, {Map<String, String>? headers, body}) {
    try {
      headers!['Content-Type'] = 'application/json';
      return http
          .delete(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) throw result['message'];
        return result;
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

}


import 'dart:async';
import 'dart:io';

class ErrorHandler {

  /// Function to handle error messages from the server
  void handleError(dynamic e) {
    print(e);
    if (e is HandshakeException || e.toString().contains('HandshakeException')) {
      throw ('Error occurred, please try again');
    }
    else if(e is SocketException || e.toString().contains('SocketException')){
      throw ('No internet connection');
    }
    if(e is TimeoutException || e.toString().contains('TimeoutException')){
      throw ('Request timeout, try again');
    }
    if(e is FormatException || e.toString().contains('FormatException')){
      throw ('Error occurred, please try again');
    }
    throw (e);
  }

}
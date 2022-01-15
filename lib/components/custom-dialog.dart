import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog{

  /// This function builds and return a dialog to the user telling them a
  /// [message] in the current [context]
  static Future<void> buildDialog(BuildContext context, String message){
    return showDialog(
      context: context,
      builder: (_) => Platform.isIOS
          ? CupertinoAlertDialog(
        title: const Text('NOTE'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: const Text('OK'),
          )
        ],
      )
          : AlertDialog(
        title: const Text('NOTE'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

}
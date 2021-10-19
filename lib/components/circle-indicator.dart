import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(radius: 16)
        : CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
    );
  }
}
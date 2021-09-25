import 'package:flutter/material.dart';

AppBar buildAppBar(BoxConstraints constraints, String title) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Color(0xFF004E92),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
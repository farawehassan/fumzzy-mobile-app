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

AppBar buildAppBarWithBackButton(BuildContext context, String title) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Color(0xFF004E92),
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        size: 22,
        color: Colors.black,
      ),
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
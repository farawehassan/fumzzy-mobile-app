import 'package:flutter/material.dart';

Color mainColor = Color(0xFF004E92);

/// Text style for the tab bar view
final TextStyle kTabBarTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

/// Setting a constant [kTextFieldBorderDecoration] for [InputDecoration] styles
final kTextFieldBorderDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(3.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF7BBBE5), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(3.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF7BBBE5), width: 1.5, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(3.0),
  ),
);

/// Decoration for the white container that contains the table
final BoxDecoration kTableContainer = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.0),
  border: Border.all(
    width: 1,
    color: Color(0xFFE2E2EA),
  ),
);

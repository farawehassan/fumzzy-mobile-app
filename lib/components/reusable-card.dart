import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {

  ReusableCard({
    @required this.child,
    this.elevation
  });

  final Widget? child;

  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: elevation ?? 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      shadowColor: Color(0xFFF7F8F9),
      child: child,
    );
  }
}
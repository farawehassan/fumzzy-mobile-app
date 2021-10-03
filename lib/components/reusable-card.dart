import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {

  ReusableCard({
    @required this.child
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      shadowColor: Color(0xFFF7F8F9),
      child: child,
    );
  }
}
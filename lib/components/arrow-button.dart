import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class TableArrowButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Icon(
        IconlyBold.arrowRightCircle,
        size: 14.5,
        color: Color(0xFF004E92).withOpacity(0.5),
      ),
    );
  }

}
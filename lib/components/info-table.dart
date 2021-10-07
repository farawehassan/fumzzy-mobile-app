import 'package:flutter/material.dart';

class ReusableCustomerInfoFields extends StatelessWidget {

  ReusableCustomerInfoFields({
    Key? key,
    @required this.tableTitle,
    this.widget,
  }) : super(key: key);

  final String? tableTitle;

  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tableTitle!,
          style: TextStyle(
            color: Color(0xFF75759E),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 15),
        widget ?? Text('-',style: TextStyle(color: Colors.black)),
      ],
    );
  }
}
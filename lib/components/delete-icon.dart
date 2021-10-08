import 'package:flutter/material.dart';

class ReusableDeleteText extends StatelessWidget {

  const ReusableDeleteText({@required this.textSize});

  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Delete ',
          style: TextStyle(
            color: Color(0xFFF64932),
            fontSize: textSize ?? 14,
          ),
        ),
        Icon(
          Icons.delete,
          color: Color(0xFFF64932),
          size: 15,
        ),
      ],
    );
  }
}

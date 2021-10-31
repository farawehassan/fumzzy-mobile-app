import 'package:flutter/material.dart';

class ReusableDownloadPdf extends StatelessWidget {

  ReusableDownloadPdf({required this.invoiceNo});

  final String invoiceNo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pdf-image.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          invoiceNo,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Color(0xFF75759E),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

}
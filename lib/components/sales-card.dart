import 'package:flutter/material.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:fumzy/utils/size-config.dart';
import 'reusable-card.dart';

class TotalSalesCard extends StatelessWidget {

  TotalSalesCard({
    @required this.cardName,
    @required this.totalPrice
  });

  final String? cardName;

  final double? totalPrice;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ReusableCard(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardName!,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF75759E),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12),
            Text(
              Functions.money(totalPrice!, 'N'),
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF171725),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
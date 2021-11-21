import 'package:flutter/material.dart';
import 'package:fumzy/components/fade-animation.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:fumzy/utils/size-config.dart';
import 'reusable-card.dart';

class TotalSalesCard extends StatelessWidget {

  TotalSalesCard({
    @required this.cardName,
    @required this.totalPrice
  });

  final String? cardName;

  final dynamic totalPrice;

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardName!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF75759E),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            FadeAnimation(
              delay: 1.3,
              child: Text(
                totalPrice == null
                    ? '#.##'
                    : Functions.money(double.parse(totalPrice!.toString()), 'N'),
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF171725),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
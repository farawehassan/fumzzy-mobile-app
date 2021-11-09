import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/fade-animation.dart';
import 'package:fumzy/utils/functions.dart';

class InventoryCard extends StatelessWidget {

  InventoryCard({
    @required this.cardName,
    @required this.totalPrice,
    @required this.cardColor
  });

  final String? cardName;

  final double? totalPrice;

  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          width: 2,
          color: Colors.white,
          style: BorderStyle.solid,
        ),
      ),
      shadowColor: const Color(0xFFF7F8F9),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 33, horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cardName!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  IconlyBold.graph,
                  color: Colors.white,
                  size: 17,
                ),
              ],
            ),
            const SizedBox(height: 14),
            FadeAnimation(
              delay: 1.3,
              child: Text(
                totalPrice == null
                    ? '#.##'
                    : Functions.money(totalPrice!, 'N'),
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
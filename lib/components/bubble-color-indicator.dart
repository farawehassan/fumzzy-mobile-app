import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {

  Indicator({required this.indicatorColor});

  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.7,
      height: 6.7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: indicatorColor,
      ),
    );
  }
}

class GreenIndicator extends StatelessWidget {
  const GreenIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Indicator(
      indicatorColor: Color(0xFF00AF27),
    );
  }
}

class CreditIndicator extends StatelessWidget {
  const CreditIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Indicator(
      indicatorColor: Color(0xFFF64932),
    );
  }
}

class PartPaidIndicator extends StatelessWidget {
  const PartPaidIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Indicator(
      indicatorColor: Color(0xFFF28301),
    );
  }
}

import 'package:flutter/material.dart';

class MobileNotificationScreen extends StatelessWidget {

  static const String id = 'mobileNotificationContent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'NOTIFICATIONS',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: MessageContent(),
    );
  }
}

class MessageContent extends StatelessWidget {

  const MessageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 15, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1 Hour Ago',
                style: TextStyle(
                    color: Color(0xFF767676),
                    fontSize: 12
                ),
              ),
              SizedBox(height: 22),
              Text(
                'Notifications are for delete, discounts, expenses, Inventory out of stock and so on. You also get a notification when'
                'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. '
                ' Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. ',
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 15,
                  wordSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

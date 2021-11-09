import 'package:flutter/material.dart';
import 'package:fumzy/screens/transactions/add-sale.dart';
import 'button.dart';

AppBar buildAppBar(BoxConstraints constraints, String title, {BuildContext? context}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Color(0xFF004E92),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    actions: [
      title == 'DASHBOARD'
          ? Container(
        margin: EdgeInsets.only(right: 16, bottom: 10),
        child: Button(
          onTap: (){
            Navigator.pushNamed(context!, AddSale.id);
          },
          buttonColor: Color(0xFF004E92),
          width: 80,
          child: Center(
            child: Text(
              'Add Sale',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      )
          : Container()
    ],
  );
}

AppBar buildAppBarWithBackButton(BuildContext context, String title) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Color(0xFF004E92),
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        size: 22,
        color: Colors.black,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
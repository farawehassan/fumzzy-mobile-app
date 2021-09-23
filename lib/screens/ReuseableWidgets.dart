import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';


final TextStyle kTabBarTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);//text style for the tab bar view

final BoxDecoration kTableContainer = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.0),
  border: Border.all(
    width: 1,
    color: Color(0xFFE2E2EA),
  ),
);//decoration for the white container that contains the table

AppBar buildAppBar(BoxConstraints constraints, String title) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Color(0xFF004E92),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    ),
    actions: [
      // Search box
      Container(
        padding: EdgeInsets.only(left: constraints.maxWidth * 0.019),
        margin: EdgeInsets.only(
            top: constraints.maxWidth * 0.009,
            bottom: constraints.maxWidth * 0.009,
            right: constraints.maxWidth* 0.045
        ),
        width: constraints.maxWidth * 0.25,
        decoration: BoxDecoration(
          color: Color(0xFFE6E9EE),
          borderRadius: BorderRadius.circular(27.5),
        ),
        child: TextField(
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            suffixIcon: Icon(
              IconlyLight.search,
              color: Colors.black,
              size: 17,
            ),
            hintText: 'Search',
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              color: Colors.black
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: constraints.maxWidth * 0.04),
        width: constraints.maxWidth * 0.082,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              IconlyBold.message,
              color: Color(0xFF004E92),
              size: 24,
            ),
            Icon(
              IconlyBold.notification,
              color: Color(0xFF004E92).withOpacity(0.6),
              size: 24,
            ),
          ],
        ),
      ),//icons
      GestureDetector(
        onTap: () {
          print("admin was tapped");
        },
        child: Container(
          margin: EdgeInsets.only(right: constraints.maxWidth*0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Admin',
                style: TextStyle(
                  textBaseline: TextBaseline.ideographic,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Image.asset('assets/images/imageAdmin.png'),
              Icon(
                IconlyBold.arrowDown2,
                color: Color(0xFF696974),
                size: 12,
              ),
            ],
          ),
        ),
      ),//admin
    ],
  );
}//app bar present in all the screens. Any screen calling the app bar passes their name too

class ReusableTableArrowButton extends StatelessWidget {
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
}// arrows present in the table

//table decoration will come in here
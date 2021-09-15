import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'drawer.dart';

class Dashboard extends StatefulWidget {

  static const String id = 'dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFF004E92),
        ),
        title: Text(
          'Dashboard',
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
      ),
      drawer: RefactoredDrawer(),
      body: Container(

      ),
    ));
  }

}

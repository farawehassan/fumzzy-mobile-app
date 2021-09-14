import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/screens/settings/settings.dart';
import 'package:fumzy/screens/creditors/creditors.dart';
import 'package:fumzy/screens/staff/staff.dart';

class RefactoredDrawer extends StatefulWidget {

  @override
  _RefactoredDrawerState createState() => _RefactoredDrawerState();
}

class _RefactoredDrawerState extends State<RefactoredDrawer> {
  Color _inactiveColor = Colors.white.withOpacity(0.7);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF00509A),
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              height: 80,
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.rotate(
                      angle: 0.8,
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Color(0xFF00509A),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.8,
                            child: Text(
                              'FGV',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 17,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FUMZZY',
                            style: TextStyle(
                                color: Color(0xFF023C72),
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            'Global Ventures',
                            style: TextStyle(
                                color: Color(0xFF023C72),
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),//fgv logo
            Container(
              padding: EdgeInsets.only(left: 7.2),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    child: ListTile(
                      leading: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        print("clicked dashboard");
                      },
                    ),
                  ),//menu
                  ListTile(
                    leading: Icon(
                      IconlyBold.category,
                      color: Colors.white,
                      size: 20,
                    ),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Dashboard
                  ListTile(
                    leading: Icon(
                      IconlyBold.chart,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Transactions',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Transactions
                  ListTile(
                    leading: Icon(
                      IconlyBold.buy,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Inventory',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Inventory
                  ListTile(
                    leading: Icon(
                      IconlyBold.document,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Invoices',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Invoices
                  ListTile(
                    leading: Icon(
                      IconlyBold.user3,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Customers',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Customers
                  ListTile(
                    leading: Icon(
                      IconlyBold.wallet,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Creditors',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Creditors(),));
                    },
                  ),//Creditors
                  ListTile(
                    leading: Icon(
                      IconlyBold.user3,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Wallet',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Wallet
                  ListTile(
                    leading: Icon(
                      IconlyBold.notification,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      print("clicked dashboard");
                    },
                  ),//Notifications
                  ListTile(
                    leading: Icon(
                      IconlyBold.user2,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Staffs',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Staff(),));
                    },
                  ),//Staffs
                  ListTile(
                    leading: Icon(
                      IconlyBold.setting,
                      color: _inactiveColor,
                      size: 20,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        color: _inactiveColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(),));
                    },
                  ),//Settings
                  Padding(
                    padding: const EdgeInsets.only(top: 34.0),
                    child: ListTile(
                      leading: Icon(
                        IconlyBold.arrowLeft,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: Text(
                        'Collapse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),//collapse
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class ReusableAppBar{
//   static getsAppBar( String title) {
//     return AppBar(
//       iconTheme: IconThemeData(
//         color: Color(0xFF004E92),
//       ),
//       backgroundColor: Colors.white,
//       title: Text(
//         'Dashboard',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 17,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       actions: [
//         Container(
//           padding: EdgeInsets.only(left: constraints.maxWidth*0.019),
//           margin: EdgeInsets.only(top: constraints.maxWidth*0.009, bottom: constraints.maxWidth*0.009, right: constraints.maxWidth*0.045),
//           width: constraints.maxWidth*0.25,
//           decoration: BoxDecoration(
//             color: Color(0xFFE6E9EE),
//             borderRadius: BorderRadius.circular(27.5),
//           ),
//           child: TextField(
//             textAlign: TextAlign.start,
//             decoration: InputDecoration(
//               suffixIcon: Icon(
//                 IconlyLight.search,
//                 color: Colors.black,
//                 size: 17,
//               ),
//               hintText: 'Search',
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//             ),
//             style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16.0,
//                 color: Colors.black
//             ),
//           ),
//         ),//searchbox
//         Container(
//           margin: EdgeInsets.only(right: constraints.maxWidth*0.04),
//           width: constraints.maxWidth*0.082,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(
//                 IconlyBold.message,
//                 color: Color(0xFF004E92),
//                 size: 24,
//               ),
//               Icon(
//                 IconlyBold.notification,
//                 color: Color(0xFF004E92).withOpacity(0.6),
//                 size: 24,
//               ),
//             ],
//           ),
//         ),//icons
//         GestureDetector(
//           onTap: () {
//             print("admin was tapped");
//           },
//           child: Container(
//             margin: EdgeInsets.only(right: constraints.maxWidth*0.03),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Admin',
//                   style: TextStyle(
//                     textBaseline: TextBaseline.ideographic,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Image.asset('images/imageAdmin.png'),
//                 Icon(
//                   IconlyBold.arrowDown2,
//                   color: Color(0xFF696974),
//                   size: 12,
//                 ),
//               ],
//             ),
//           ),
//         ),//admin
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/database/user-db-helper.dart';
import 'package:fumzy/screens/notification/notifications.dart';
import 'package:fumzy/screens/settings/settings.dart';
import 'package:fumzy/screens/creditors/creditors.dart';
import 'package:fumzy/screens/staff/staff.dart';
import 'package:fumzy/screens/inventory/inventory.dart';
import 'package:fumzy/screens/invoices/invoices.dart';
import 'package:fumzy/screens/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splash-screen.dart';
import 'dashboard.dart';
import 'package:fumzy/screens/customers/customers.dart';

class RefactoredDrawer extends StatefulWidget {

  final String? title;

  const RefactoredDrawer({
    Key? key,
    this.title
  }) : super(key: key);

  @override
  _RefactoredDrawerState createState() => _RefactoredDrawerState();
}

class _RefactoredDrawerState extends State<RefactoredDrawer> {

  Color _getColor (String title){
    if(widget.title == title){
      return Colors.white;
    } else {
      return Colors.white.withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF00509A),
        child: Column(
          children: [
            Container(
              color: Color(0xFFFFFFFF),
              height: 100,
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 20),
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
                      margin: EdgeInsets.only(left: 17),
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 7.2),
                  color: Color(0xFF00509A),
                  child: Column(
                    children: [
                      // Menu
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
                          onTap: () { },
                        ),
                      ),
                      // Dashboard
                      ListTile(
                        leading: Icon(
                          IconlyBold.category,
                          color: _getColor('DASHBOARD'),
                          size: 20,
                        ),
                        title: Text(
                          'Dashboard',
                          style: TextStyle(
                            color: _getColor('DASHBOARD'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'DASHBOARD'){
                            Navigator.pushReplacementNamed(context, Dashboard.id);
                          }
                        },
                      ),
                      // Transactions
                      ListTile(
                        leading: Icon(
                          IconlyBold.chart,
                          color: _getColor('TRANSACTIONS'),
                          size: 20,
                        ),
                        title: Text(
                          'Transactions',
                          style: TextStyle(
                            color: _getColor('TRANSACTIONS'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'TRANSACTIONS'){
                            Navigator.pushReplacementNamed(context, Transactions.id);
                          }
                        },
                      ),
                      // Inventory
                      ListTile(
                        leading: Icon(
                          IconlyBold.buy,
                          color: _getColor('INVENTORY'),
                          size: 20,
                        ),
                        title: Text(
                          'Inventory',
                          style: TextStyle(
                            color: _getColor('INVENTORY'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'INVENTORY'){
                            Navigator.pushReplacementNamed(context, Inventory.id);
                          }
                        },
                      ),
                      // Invoices
                      ListTile(
                        leading: Icon(
                          IconlyBold.document,
                          color: _getColor('INVOICES'),
                          size: 20,
                        ),
                        title: Text(
                          'Invoices',
                          style: TextStyle(
                            color: _getColor('INVOICES'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'INVOICES'){
                            Navigator.pushReplacementNamed(context, Invoices.id);
                          }
                        },
                      ),
                      // Customers
                      ListTile(
                        leading: Icon(
                          IconlyBold.user3,
                          color: _getColor('CUSTOMERS'),
                          size: 20,
                        ),
                        title: Text(
                          'Customers',
                          style: TextStyle(
                            color: _getColor('CUSTOMERS'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if (widget.title != 'CUSTOMERS'){
                            Navigator.pushReplacementNamed(context, Customers.id);
                          }
                        },
                      ),
                      // Creditor
                      ListTile(
                        leading: Icon(
                          IconlyBold.wallet,
                          color: _getColor('CREDITORS'),
                          size: 20,
                        ),
                        title: Text(
                          'Creditors',
                          style: TextStyle(
                            color: _getColor('CREDITORS'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'CREDITORS'){
                            Navigator.pushReplacementNamed(context, Creditors.id);
                          }
                        },
                      ),
                      // Notifications
                      ListTile(
                        leading: Icon(
                          IconlyBold.notification,
                          color: _getColor('NOTIFICATIONS'),
                          size: 20,
                        ),
                        title: Text(
                          'Notifications',
                          style: TextStyle(
                            color: _getColor('NOTIFICATIONS'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'NOTIFICATIONS'){
                            Navigator.pushReplacementNamed(context, Notifications.id);
                          }
                        },
                      ),
                      // Staffs
                      ListTile(
                        leading: Icon(
                          IconlyBold.user2,
                          color: _getColor('STAFFS'),
                          size: 20,
                        ),
                        title: Text(
                          'Staffs',
                          style: TextStyle(
                            color: _getColor('STAFFS'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'STAFFS'){
                            Navigator.pushReplacementNamed(context, Staff.id);
                          }
                        },
                      ),
                      // Settings
                      ListTile(
                        leading: Icon(
                          IconlyBold.setting,
                          color: _getColor('SETTINGS'),
                          size: 20,
                        ),
                        title: Text(
                          'Settings',
                          style: TextStyle(
                            color: _getColor('SETTINGS'),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if(widget.title != 'SETTINGS'){
                            Navigator.pushReplacementNamed(context, Settings.id);
                          }
                        },
                      ),
                      // Logout
                      Padding(
                        padding: const EdgeInsets.only(top: 34.0, bottom: 40),
                        child: ListTile(
                          leading: Icon(
                            IconlyBold.logout,
                            color: Colors.white,
                            size: 20,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            _logOut();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to log user out
  void _logOut() async{
    var db = DatabaseHelper();
    await db.deleteUsers();
    _getBoolValuesSF();
  }

  /// Function to get the 'LoggedIn' in your SharedPreference
  _getBoolValuesSF() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loggedIn');
    if(loggedIn == true){
      addBoolToSF();
    }
  }

  /// Function to set the 'LoggedIn' in your SharedPreference to false
  addBoolToSF() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.pushReplacementNamed(context, SplashScreen.id);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/screens/settings/settings.dart';
import 'package:fumzy/screens/creditors/creditors.dart';
import 'package:fumzy/screens/staff/staff.dart';
import 'package:fumzy/screens/inventory/inventory.dart';
import 'package:fumzy/screens/invoices/invoices.dart';
import 'package:fumzy/screens/transactions/transactions.dart';
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

  Color _inactiveColor = Colors.white.withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color:  Color(0xFF00509A),
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
                      //menu
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
                      ),
                      //Dashboard
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
                          Navigator.pop(context);
                          if(widget.title != 'DASHBOARD'){
                            Navigator.pushNamed(context, Dashboard.id);
                          }
                        },
                      ),
                      //Transactions
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
                          Navigator.pop(context);
                          if(widget.title != 'TRANSACTIONS'){
                            Navigator.pushNamed(context, Transactions.id);
                          }
                        },
                      ),
                      //Inventory
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
                          Navigator.pop(context);
                          if(widget.title != 'INVENTORY'){
                            Navigator.pushNamed(context, Inventory.id);
                          }
                        },
                      ),
                      //Invoices
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
                          Navigator.pop(context);
                          if(widget.title != 'INVOICES'){
                            Navigator.pushNamed(context, Invoices.id);
                          }
                        },
                      ),
                      //Customers
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
                          Navigator.pop(context);
                          if (widget.title != 'CUSTOMERS'){
                            Navigator.pushNamed(context, Customers.id);
                          }
                        },
                      ),
                      //Creditor
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
                          if(widget.title != 'CREDITORS'){
                            Navigator.pushNamed(context, Creditors.id);
                          }
                        },
                      ),
                      //Notifications
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
                      ),
                      //Staffs
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
                          if(widget.title != 'STAFFS'){
                            Navigator.pushNamed(context, Staff.id);
                          }
                        },
                      ),
                      //Settings
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
                          if(widget.title != 'SETTINGS'){
                            Navigator.pushNamed(context, Settings.id);
                          }
                        },
                      ),
                      //collapse
                      Padding(
                        padding: const EdgeInsets.only(top: 34.0, bottom: 40),
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

}
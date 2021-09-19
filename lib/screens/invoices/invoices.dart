import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/screens/ReuseableWidgets.dart';

class Invoices extends StatefulWidget {
  static const String id = 'invoices';

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: RefactoredDrawer(),
      body: LayoutBuilder(builder: (context, constraints) => ListView(
          children: [
            Container(
              child: Container(
                padding: EdgeInsets.only(
                    top: constraints.maxHeight  *  0.07,
                    left: constraints.maxWidth  *  0.026,
                    right: constraints.maxWidth  *  0.026
                ),
                color: Color(0xFFF7F8F9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                      child: Text(
                        'All Invoices',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),//all inventory, add new category and add new product
                    Container(
                      margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: constraints.maxHeight * 0.155,
                            width: constraints.maxWidth * 0.34,
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                  fontSize: 15.0,
                                  color: Colors.black
                              ),
                            ),
                          ),//search
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("export table");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: constraints.maxHeight * 0.044),
                                  padding: EdgeInsets.all(15),
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.file_download_outlined,
                                        color: Color(0xFF75759E),
                                        size: 17,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          'Export table',
                                          style: TextStyle(
                                            color: Color(0xFF75759E),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("filter");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: constraints.maxHeight * 0.044),
                                  padding: EdgeInsets.all(15),
                                  height: constraints.maxHeight * 0.163,
                                  width: constraints.maxWidth * 0.131,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFFE2E2EA),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Icon(
                                        Icons.tune,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),//filter
                            ],
                          ),//export table and filter
                        ],
                      ),
                    ),//search, export and filter
                    DefaultTabController(
                      length: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 370.0,
                            child: TabBar(
                              tabs: [
                                Tab(child: Text(
                                  'Products',
                                  style: kTabBarTextStyle,
                                ),),//account tab name
                                Tab(child: Text(
                                  'Fully Paid',
                                  style: kTabBarTextStyle,
                                ),),//security tab name
                                Tab(child: Text(
                                  'Part-paid',
                                  style: kTabBarTextStyle,
                                ),),//security tab name
                                Tab(child: Text(
                                  'Credit',
                                  style: kTabBarTextStyle,
                                ),),//security tab name
                              ],
                            ),
                          ),//tabBar
                          Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            margin: EdgeInsets.only(top: constraints.maxHeight * 0.05),
                            child: TabBarView(
                              children: [
                                Container(
                                  decoration: kTableContainer,
                                ),//tabView for all details
                                Container(
                                  decoration: kTableContainer,
                                ),//tabView for the fully paid details
                                Container(
                                  decoration: kTableContainer,
                                ),//tabView for the part paid details
                                Container(
                                  decoration: kTableContainer,
                                ),//tabView for the credit details
                              ],
                            ),
                          ),// tabView
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
      ),
    );
  }
}
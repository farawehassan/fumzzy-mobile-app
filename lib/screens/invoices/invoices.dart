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
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'Invoices'),
        drawer: RefactoredDrawer(),
        body: ListView(children: [
          Container(
            child: Container(
              padding: EdgeInsets.only(
                  top: constraints.maxHeight * 0.07,
                  left: constraints.maxWidth * 0.026,
                  right: constraints.maxWidth * 0.026),
              color: Color(0xFFF7F8F9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                    child: Text(
                      'All Invoices',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ), //all inventory, add new category and add new product
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.125,
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
                                color: Colors.black),
                          ),
                        ), //search
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("export table");
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
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
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
                                padding: EdgeInsets.all(15),
                                height: constraints.maxHeight * 0.133,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            ), //filter
                          ],
                        ), //export table and filter
                      ],
                    ),
                  ), //search, export and filter
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 370.0,
                          child: TabBar(
                            tabs: [
                              Tab(
                                child: Text(
                                  'Products',
                                  style: kTabBarTextStyle,
                                ),
                              ), //account tab name
                              Tab(
                                child: Text(
                                  'Fully Paid',
                                  style: kTabBarTextStyle,
                                ),
                              ), //security tab name
                              Tab(
                                child: Text(
                                  'Part-paid',
                                  style: kTabBarTextStyle,
                                ),
                              ), //security tab name
                              Tab(
                                child: Text(
                                  'Credit',
                                  style: kTabBarTextStyle,
                                ),
                              ), //security tab name
                            ],
                          ),
                        ), //tabBar
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.05),
                          child: TabBarView(
                            children: [
                              Container(
                                decoration: kTableContainer,
                                child: allInvoicesDetail(),
                              ), //tabView for all details
                              Container(
                                decoration: kTableContainer,
                              ), //tabView for the fully paid details
                              Container(
                                decoration: kTableContainer,
                              ), //tabView for the part paid details
                              Container(
                                decoration: kTableContainer,
                              ), //tabView for the credit details
                            ],
                          ),
                        ), // tabView
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      )),
    );
  }
}

class allInvoicesDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: TextStyle(
        color: Color(0xFF75759E),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      dataTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 13,
        //fontWeight: FontWeight.w400,
      ),
      columnSpacing: 5.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text('Invoice No')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Customer')),
        DataColumn(label: Text('Balance')),
        DataColumn(label: Text('Due')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(ReusableDownloadPdf()),
          DataCell(Text('Fully Paid')),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text('Obi Cubana and Sons Limited')),
          DataCell(Text('-')),
          DataCell(Text('-')),
        ]),
        DataRow(cells: [
          DataCell(ReusableDownloadPdf()),
          DataCell(Text('Part-Paid')),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text('Obi Cubana and Sons Limited')),
          DataCell(Text('N20,000')),
          DataCell(
              Text('23, May 2021', style: TextStyle(color: Color(0xFFF64932)))),
        ]),
        DataRow(cells: [
          DataCell(ReusableDownloadPdf()),
          DataCell(Text('Credit')),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text('Obi Cubana and Sons Limited')),
          DataCell(Text('N100,000')),
          DataCell(
              Text('23, May 2021', style: TextStyle(color: Color(0xFFF64932)))),
        ]),
      ],
    );
  }
}

class ReusableDownloadPdf extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pdf-image.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text('022341' + ' '),
          Text(
            'Download',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xFF75759E),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
  }
}

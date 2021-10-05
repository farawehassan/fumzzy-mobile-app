import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/components/invoice-pdf-download.dart';

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
        appBar: buildAppBar(constraints, 'INVOICES'),
        drawer: RefactoredDrawer(title: 'INVOICES'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Invoices',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      margin: EdgeInsets.only(right: 50),
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
                    ), //search
                    InkWell(
                      onTap: () {
                        print("filter");
                      },
                      child: Container(
                        width: 110,
                        height: 50,
                        padding: EdgeInsets.all(15),
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
                                color: Color(0xFF171725),
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
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
                    ),
                  ],
                ),
                Container(
                  width: constraints.maxWidth > 370
                      ? 370 : constraints.maxWidth,
                  child: TabBar(
                    labelStyle: kTabBarTextStyle,
                    labelColor: Color(0xFF004E92),
                    unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                    indicatorColor: Color(0xFF004E92),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        child: Text(
                          'Products',
                          style: kTabBarTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Fully Paid',
                          style: kTabBarTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Part-paid',
                          style: kTabBarTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Credit',
                          style: kTabBarTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          decoration: kTableContainer,
                          child: AllInvoicesDetail(),
                        ),
                      ),
                      Container(
                        decoration: kTableContainer,
                      ),
                      Container(
                        decoration: kTableContainer,
                      ),
                      Container(
                        decoration: kTableContainer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class AllInvoicesDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: TextStyle(
          color: Color(0xFF75759E),
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        dataTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        columnSpacing: 15.0,
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
            DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
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
            DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
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
            DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
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
      ),
    );
  }
}


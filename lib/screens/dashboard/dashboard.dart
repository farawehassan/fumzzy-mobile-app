import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'drawer.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: buildAppBar(constraints, 'DASHBOARD'),
        drawer: RefactoredDrawer(title: 'DASHBOARD'),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 23, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 13.5, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFE2E2EA),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'This week',
                        style: TextStyle(
                            color: Color(0xFF171725),
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                      Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                ),//this week dropdown
                SizedBox(height: 20),
                Wrap(
                  children: [
                    ReusableTotalCard(
                      cardName: 'Total Sales',
                      totalPrice: '800,000,000',
                    ),
                    ReusableTotalCard(
                      cardName: 'Total Purchases',
                      totalPrice: '5,000,000',
                    ),
                    ReusableTotalCard(
                      cardName: 'Total Expenses',
                      totalPrice: '150,900',
                    ),
                    ReusableTotalCard(
                      cardName: 'Total Profit',
                      totalPrice: '2,849,100',
                    ),
                    ReusableTotalCard(
                      cardName: 'Total Discounts',
                      totalPrice: '85,115',
                    ),
                  ],
                ),//total sales cards
                SizedBox(height: 30),
                Wrap(
                  children: [
                    ReusableInventoryCard(
                      cardName: 'Inventory Cost Price',
                      totalPrice: '89,981,900',
                      cardColor: Color(0xFFF64932),
                    ),
                    ReusableInventoryCard(
                      cardName: 'Inventory Selling Price',
                      totalPrice: '150,981,900',
                      cardColor: Color(0xFF00AF27),
                    ),
                    ReusableInventoryCard(
                      cardName: 'Inventory Profit',
                      totalPrice: '600,981,900,000.0',
                      cardColor: Color(0xFF00509A),
                    ),
                  ],
                ),//inventory cards
                SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              'Outstanding',
                              style: TextStyle(
                                color: Color(0xFF171725),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),//outstanding text
                          Container(
                            height: 160,
                            width: constraints.maxWidth,
                            child: ReusableCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Sales  ',
                                                  style: TextStyle(
                                                    color: Color(0xFF75759E),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                GreenIndicator(),
                                              ],
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              'N' + '110,000',
                                              style: TextStyle(
                                                color: Color(0xFF171725),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 75,
                                          margin: EdgeInsets.symmetric(horizontal: 26),
                                          child: VerticalDivider(
                                            color: Colors.grey,
                                            thickness: 0.6,
                                            width: 1,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Volume',
                                              style: TextStyle(
                                                color: Color(0xFF75759E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              '20',
                                              style: TextStyle(
                                                color: Color(0xFF171725),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("see details");
                                      },
                                      child: Wrap(
                                        children: [
                                          Text(
                                            'See Details  ',
                                            style: TextStyle(
                                              color: Color(0xFF00509A),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Icon(
                                            IconlyBold.arrowRightCircle,
                                            size: 16.5,
                                            color: Color(0xFF004E92)
                                                .withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),//see details button
                                  ],
                                ),
                              ),
                            ),
                          ),//sales card
                          SizedBox(height: 29.4),
                          Container(
                            height: 160,
                            width: constraints.maxWidth,
                            child: ReusableCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Purchase  ',
                                                  style: TextStyle(
                                                    color: Color(0xFF75759E),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                PartPaidIndicator(),
                                              ],
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              'N' + '75,000',
                                              style: TextStyle(
                                                color: Color(0xFF171725),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),//purchase
                                        Container(
                                          height: 75,
                                          margin: EdgeInsets.symmetric(horizontal: 26),
                                          child: VerticalDivider(
                                            color: Colors.grey,
                                            thickness: 0.6,
                                            width: 1,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Volume',
                                              style: TextStyle(
                                                color: Color(0xFF75759E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              '12',
                                              style: TextStyle(
                                                color: Color(0xFF171725),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),//volume
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("see details");
                                      },
                                      child: Wrap(
                                        children: [
                                          Text(
                                            'See Details  ',
                                            style: TextStyle(
                                              color: Color(0xFF00509A),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Icon(
                                            IconlyBold.arrowRightCircle,
                                            size: 16.5,
                                            color: Color(0xFF004E92)
                                                .withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),//see details button
                                  ],
                                ),
                              ),
                            ),
                          ),//purchase card
                        ],
                      ),
                    ),//outstanding cards
                    SizedBox(width: 13),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Purchases',
                                style: TextStyle(
                                  color: Color(0xFF171725),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  print("see all");
                                },
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          ReusableCard(
                            child: Container(
                              height: 340,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: RecentPurchaseTable(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),//recent purchases
                  ],
                ),//outstanding cards, recent purchases
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Sales',
                            style: TextStyle(
                              color: Color(0xFF171725),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print("see all");
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFF00509A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 340,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFE2E2EA),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: RecentSalesTable(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecentPurchaseTable extends StatelessWidget {
  const RecentPurchaseTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: TextStyle(
        color: Color(0xFF75759E),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      dataTextStyle: TextStyle(
        color: Color(0xFF1F1F1F),
        fontSize: 14,
        //fontWeight: FontWeight.w400,
      ),
      columnSpacing: 15.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text('Sumec Generator 35”')),
          DataCell(Text('Appliances')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Indomie super pack 60cl')),
          DataCell(Text('Foods')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-acholic drink 500cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
      ],
    );
  }
}

class RecentSalesTable extends StatelessWidget {
  const RecentSalesTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: TextStyle(
        color: Color(0xFF75759E),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      dataTextStyle: TextStyle(
        color: Color(0xFF1F1F1F),
        fontSize: 14,
        //fontWeight: FontWeight.w400,
      ),
      columnSpacing: 15.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text('Invoice')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Payment Status')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Balance')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('022341'),
              Text(
                '23, May 2021- ' + '12:13pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('100')),
          DataCell(Text('Fully Paid')),
          DataCell(Text('N' + '50,000')),
          DataCell(Text('-')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('022341'),
              Text(
                '23, May 2021- ' + '12:13pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('100')),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Credit'+'  '),
              CreditIndicator(),
            ],
          )),
          DataCell(Text('N' + '50,000')),
          DataCell(Text('N' + '50,000')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('022341'),
              Text(
                '23, May 2021- ' + '12:13pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('100')),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Part-Paid'+'  '),
              PartPaidIndicator(),
            ],
          )),
          DataCell(Text('N' + '12,000')),
          DataCell(Text('N' + '2,000')),
          DataCell(TableArrowButton()),
        ]),
      ],
    );
  }
}

class ReusableTotalCard extends StatelessWidget {
  ReusableTotalCard({required this.cardName, required this.totalPrice});

  final String cardName;
  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Container(
        height: 99,
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 13),
        child: Wrap(
          runSpacing: 11,
          children: [
            Text(
              cardName,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF75759E),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'N' + totalPrice,
              style: TextStyle(
                fontSize: 21,
                color: Color(0xFF171725),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableInventoryCard extends StatelessWidget {
  ReusableInventoryCard(
      {required this.cardName,
      required this.totalPrice,
      required this.cardColor});

  final String cardName;
  final String totalPrice;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          width: 2,
          color: Colors.white,
          style: BorderStyle.solid,
        ),
      ),
      shadowColor: Color(0xFFF7F8F9),
      child: Container(
        height: 129,
        width: 230,
        padding: EdgeInsets.symmetric(vertical: 31, horizontal: 20),
        child: Wrap(
          runSpacing: 26.4,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardName,//name of the inventory card
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Icon(
                  IconlyBold.graph,
                  color: Colors.white,
                  size: 17,
                ),
              ],
            ),
            Text(
              'N' + totalPrice,//price of the inventory card
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  ReusableCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      shadowColor: Color(0xFFF7F8F9),
      child: child,
    );
  }
}

///TODO: 1. comment the code
///4. fix the total expenses and purchase that requires a divider
///5. this week dropdown

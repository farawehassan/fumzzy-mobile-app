import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/fade-animation.dart';
import 'package:fumzy/components/inventory-card.dart';
import 'package:fumzy/components/reusable-card.dart';
import 'package:fumzy/components/sales-card.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'drawer.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';
import 'recent-purchase.dart';
import 'recent-sales.dart';

class Dashboard extends StatefulWidget {

  static const String id = 'dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> _view = [
    "This Week",
    "Yesterday",
    "Today",
    "This Month",
    "6 Months",
    "All Time"
  ];

  String? _selectedView = "This Week";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: buildAppBar(constraints, 'DASHBOARD'),
        drawer: RefactoredDrawer(title: 'DASHBOARD'),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 23, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: _selectedView,
                    onChanged: (value) {
                      setState(() {
                        _selectedView = value;
                      });
                    },
                    style: TextStyle(
                        color: Color(0xFF171725),
                        fontWeight: FontWeight.normal,
                        fontSize: 14
                    ),
                    iconEnabledColor: Color(0xFF000000),
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.black,
                      size: 20,
                    ),
                    decoration: kTextFieldBorderDecoration.copyWith(
                      contentPadding: EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E2EA), width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E2EA), width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    items: _view.map((value) {
                      return DropdownMenuItem(
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Color(0xFF171725),
                              fontWeight: FontWeight.normal,
                              fontSize: 14
                          ),
                        ),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  children: [
                    TotalSalesCard(
                      cardName: 'Total Sales',
                      totalPrice: 800000000,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Purchases',
                      totalPrice: 5000000,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Expenses',
                      totalPrice: 150900,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Profit',
                      totalPrice: 2849100,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Discounts',
                      totalPrice: 85115,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Wrap(
                  children: [
                    InventoryCard(
                      cardName: 'Inventory Cost Price',
                      totalPrice: 89981900,
                      cardColor: Color(0xFFF64932),
                    ),
                    InventoryCard(
                      cardName: 'Inventory Selling Price',
                      totalPrice: 150981900,
                      cardColor: Color(0xFF00AF27),
                    ),
                    InventoryCard(
                      cardName: 'Inventory Profit',
                      totalPrice: 600981900000,
                      cardColor: Color(0xFF00509A),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                //outstanding cards, recent purchases
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Outstanding',
                            style: TextStyle(
                              color: Color(0xFF171725),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            child: ReusableCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                Functions.money(110000, 'N'),
                                                style: TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 75,
                                          margin: EdgeInsets.symmetric(horizontal: 13),
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
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                '20',
                                                style: TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
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
                                            color: Color(0xFF004E92).withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),//see details button
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 23),
                          Container(
                            child: ReusableCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                Functions.money(75000, 'N'),
                                                style: TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),//purchase
                                        Container(
                                          height: 75,
                                          margin: EdgeInsets.symmetric(horizontal: 13),
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
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                '12',
                                                style: TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),//volume
                                      ],
                                    ),
                                    SizedBox(height: 10),
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
                          ),
                        ],
                      ),
                      SizedBox(width: 13),
                      Column(
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
                              SizedBox(width: 450),
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
                    ],
                  ),
                ),
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
                      //width: constraints.maxWidth,
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

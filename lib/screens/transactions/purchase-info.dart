import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/delete-icon.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

class PurchaseInfo extends StatefulWidget {

  static const String id = 'purchaseInfo';

  @override
  _PurchaseInfoState createState() => _PurchaseInfoState();
}

class _PurchaseInfoState extends State<PurchaseInfo> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'TRANSACTIONS'),
        drawer: RefactoredDrawer(title: 'TRANSACTIONS'),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //transaction detail
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    IconlyBold.arrowLeftCircle,
                                    size: 19,
                                    color: Color(0xFF004E92).withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  ' Transactions’s Details',
                                  style: TextStyle(
                                    color: Color(0xFF75759E),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.7,
                                  ),
                                ),
                              ],
                            ),
                            //delete
                            ReusableDeleteText(
                              textSize: 16,
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
                        //purchase info
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: constraints.maxWidth,
                            decoration: kTableContainer,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Purchase Info',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF004E92),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15.0),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                                Wrap(
                                  runSpacing: 14,
                                  spacing: 60,
                                  children: [
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Amount',
                                      widget: Text(
                                        Functions.money(25000, 'N'),
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Product Name',
                                      widget: Text('Carton of Smirnoff non-acholic drink 300cl'),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Product Category',
                                      widget: Text('Drinks'),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Quantity',
                                      widget: Text(30.toString()),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Wrap(
                                  runSpacing: 15,
                                  spacing: 60,
                                  children: [
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Unit Cost Price',
                                      widget: Text(
                                        Functions.money(20000, 'N'),
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Unit Selling Price',
                                      widget: Text(
                                        Functions.money(25000, 'N'),
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Date',
                                      widget: Text(
                                        '23, May 2021 - 12:13pm',
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Seller Name',
                                      widget: Text('Obi Cubana and Sons Limited'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      )),
    );
  }

}

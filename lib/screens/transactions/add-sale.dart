import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

class AddSale extends StatefulWidget {

  static const String id = 'addSale';

  @override
  _AddSaleState createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {

  TextEditingController quantity = TextEditingController();

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
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                ' Add a new Sale',
                                style: TextStyle(
                                  color: Color(0xFF75759E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
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
                                  'Invoice Number - ' + 022341.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF004E92),
                                  ),
                                ),
                                //product field
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0, bottom: 20.0),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      Wrap(
                                        runSpacing: 10,
                                        spacing: 60,
                                        children: [
                                          ReusableCustomerInfoFields(
                                            tableTitle: 'Product Name',
                                          ),
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
                                            tableTitle: 'Quantity',
                                            widget: Container(
                                              height: 40,
                                              width: 55,
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                ],
                                                controller: quantity,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter quantity';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration,
                                              ),
                                            ),
                                          ),
                                          ReusableCustomerInfoFields(
                                            tableTitle: 'Amount',
                                            widget: Text(
                                              Functions.money(250000, 'N'),
                                            ),
                                          ),
                                          Container(
                                            width: 45,
                                            height: 45,
                                            child: TextButton(
                                              onPressed: () {
                                                print("Delete");
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(0xFFF64932),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0, bottom: 20.0),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      Wrap(
                                        runSpacing: 10,
                                        spacing: 60,
                                        children: [
                                          ReusableCustomerInfoFields(
                                            tableTitle: 'Product Name',
                                          ),
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
                                            tableTitle: 'Quantity',
                                          ),
                                          ReusableCustomerInfoFields(
                                            tableTitle: 'Amount',
                                            widget: Text(
                                              Functions.money(250000, 'N'),
                                            ),
                                          ),
                                          Container(
                                            width: 45,
                                            height: 45,
                                            child: TextButton(
                                              onPressed: () {
                                                print("Delete");
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(0xFFF64932),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                                //add another product
                                Container(
                                  child: TextButton(
                                    onPressed: () {
                                      print("");
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Add another product ',
                                          style: TextStyle(
                                            color: Color(0xFF00509A),
                                          ),
                                        ),
                                        Icon(
                                          Icons.add_circle_rounded,
                                          size: 19,
                                          color: Color(0xFF00509A),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 60),
                                //check out
                                Button(
                                  onTap: (){
                                    print("Continue to Checkout");
                                  },
                                  buttonColor: Color(0xFF00509A),
                                  child: Center(
                                    child: Text(
                                      'Continue to Checkout',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
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

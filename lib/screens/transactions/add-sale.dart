import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/components/reusable-card.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

class AddSale extends StatefulWidget {

  static const String id = 'addSale';

  @override
  _AddSaleState createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {

  List<String> _productName = [
    "Carton of Smirnoff non-acholic drink 100cl",
    "Carton of Smirnoff non-acholic drink 200cl",
    "Carton of Smirnoff non-acholic drink 300cl",
    "Carton of Smirnoff non-acholic drink 400cl",
    "Carton of Smirnoff non-acholic drink 500cl",
    "Carton of Smirnoff non-acholic drink 600cl",
  ];

  String? _selectedProduct = "Carton of Smirnoff non-acholic drink 300cl";

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
                            padding: EdgeInsets.fromLTRB(30, 24, 20, 24),
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
                                        runSpacing: 20,
                                        spacing: 15,
                                        children: [
                                          ReusableCustomerInfoFields(
                                            tableTitle: 'Product Name',
                                            widget: Container(
                                              width: 320,
                                              child: DropdownButtonFormField<String>(
                                                value: _selectedProduct,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedProduct = value;
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
                                                items: _productName.map((value) {
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
                                              height: 44,
                                              width: 67,
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textInputAction: TextInputAction.done,
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
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: '00',
                                                  contentPadding: EdgeInsets.all(12.0),
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
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
                                            width: 35,
                                            height: 43,
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
                                        runSpacing: 20,
                                        spacing: 15,
                                        children: [
                                          ReusableCustomerInfoFields(
                                            tableTitle: 'Product Name',
                                            widget: Container(
                                              width: 320,
                                              child: DropdownButtonFormField<String>(
                                                value: _selectedProduct,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedProduct = value;
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
                                                items: _productName.map((value) {
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
                                              height: 44,
                                              width: 67,
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textInputAction: TextInputAction.done,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                ],
                                                //controller: quantity,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter quantity';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: '0',
                                                  contentPadding: EdgeInsets.all(12.0),
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
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
                                            width: 35,
                                            height: 43,
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
                                    _checkout(constraints);
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

  List<String> paymentStatus = [
    "Fully Paid",
    "Part Paid",
    "Credit",
  ];

  Future<void> _checkout (BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController discount = TextEditingController();
    TextEditingController customer = TextEditingController();
    TextEditingController amountPaid = TextEditingController();
    TextEditingController dueDate = TextEditingController();

    String? selectedPaymentStatus = "Fully Paid";

    bool radioValue = true;

    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFFFFF),
        ),
        margin: EdgeInsets.all(40),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 27),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F8FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CHECKOUT',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        IconlyBold.closeSquare,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 42),
                        child: Text(
                          'Checkout Invoice #' + 022341.toString(),
                          style: TextStyle(
                            color: Color(0xFF00509A),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
                        child: Text(
                          'Congratulations, You have made a new sale. Please fill the fields to record your sales.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF000428).withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //total amount
                              Column(
                                children: [
                                  Text(
                                    'Total Amount',
                                  ),
                                  SizedBox(height: 11),
                                  Text(
                                    Functions.money(500000, 'N'),
                                    style: TextStyle(
                                      color: Color(0xFF1F1F1F),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              // Discount
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Discount',
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: constraints.maxWidth,
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
                                      controller: discount,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter discount amount';
                                        }
                                        return null;
                                      },
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        hintText: 'N Enter discount amount',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              //total amount payable
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Amount Payable',
                                  ),
                                  SizedBox(height: 11),
                                  Text(
                                    Functions.money(500000, 'N'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              //customer
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Customer',
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: constraints.maxWidth,
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      controller: customer,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter customer name';
                                        }
                                        return null;
                                      },
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        hintText: 'Enter customer name',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              //payment status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Status',
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: constraints.maxWidth,
                                    child: DropdownButtonFormField<String>(
                                      value: selectedPaymentStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPaymentStatus = value;
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
                                      hint: Text(
                                        'Enter customer name',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        contentPadding: EdgeInsets.all(15),
                                      ),
                                      items: paymentStatus.map((value) {
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
                                ],
                              ),
                              SizedBox(height: 20),
                              //amount paid
                              Row(
                                  children: [
                                    // amount paid
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Amount Paid',
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: constraints.maxWidth,
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
                                              controller: amountPaid,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Enter amount paid';
                                                }
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'N 00,000',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Balance',
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              Functions.money(50000, 'N'),
                                              style: TextStyle(
                                                color: Color(0xFF1F1F1F),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                              SizedBox(height: 20),
                              // Balance due date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balance Due Date',
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: constraints.maxWidth,
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                        controller: dueDate,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter due date';
                                        }
                                        return null;
                                      },
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        hintText: 'Enter due date',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              //mode of payment
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Amount',
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //cash
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Radio(
                                            value: radioValue,
                                            groupValue: false,
                                            activeColor: Color(0xFF00509A),
                                            visualDensity: VisualDensity(
                                              horizontal: -4,
                                            ),
                                            onChanged: (value) {
                                              setState (() {
                                                radioValue = false;
                                              });
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2.0, left: 2.0),
                                            child: Text(
                                              'Cash',
                                              style: TextStyle(
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 15),
                                      //card
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Radio(
                                            value: false,
                                            groupValue: true,
                                            activeColor: Color(0xFF00509A),
                                            visualDensity: VisualDensity(
                                              horizontal: -4,
                                            ),
                                            onChanged: (value) {
                                              setState (() {
                                                value = false;
                                              });
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2.0, left: 2.0),
                                            child: Text(
                                              'Card',
                                              style: TextStyle(
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Button(
                        onTap: (){
                          Navigator.pop(context);
                          _generateInvoice();
                        },
                        buttonColor: Color(0xFF00509A),
                        child: Center(
                          child: Text(
                            'Generate Invoice',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 130,
                          child: Center(
                            child: Text(
                              'No, Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateInvoice() {
    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFFFFF),
        ),
        margin: EdgeInsets.all(50),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 27),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F8FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DOWNLOAD AND SHARE INVOICE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        IconlyBold.closeSquare,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 27),
                        Container(
                          width: 67,
                          height: 67,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00CFA0).withOpacity(0.15),
                          ),
                          child: Icon(
                            Icons.done_rounded,
                            color: Color(0xFF00CFA0),
                            size: 45,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 22),
                          child: Text(
                            'Transaction Invoice Generated Successfully',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF00509A),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 19.0),
                          child: Text(
                            'Your transaction invoice has been generated. You can download or share with customers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF000428).withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 45),
                        ReusableCard(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(12, 17, 21, 27),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 62,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/pdf-image.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Invoice' + 023345.toString() + '.pdf',
                                      style: TextStyle(
                                        color: Color(0xFF002338),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '34MB',
                                      style: TextStyle(
                                        color: Color(0xFF002338).withOpacity(0.3),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        Button(
                          onTap: (){
                            print("Download");
                          },
                          buttonColor: Color(0xFF00509A),
                          child: Center(
                            child: Text(
                              'Download',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            print("share");
                          },
                          child: Container(
                            width: 130,
                            child: Center(
                              child: Text(
                                'Share',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

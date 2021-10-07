import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/components/delete-icon.dart';
import 'package:fumzy/utils/functions.dart';

class InventoryDetail extends StatefulWidget {
  static const String id = 'inventoryDetail';

  @override
  _InventoryDetailState createState() => _InventoryDetailState();
}

class _InventoryDetailState extends State<InventoryDetail> {
  final Color shortStockColor = Color(0xFFF28301);

  final Color inStockColor = Color(0xFF00AF27);

  final Color outOfStockColor = Color(0xFFF64932);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'INVENTORY'),
        drawer: RefactoredDrawer(title: 'INVENTORY'),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: constraints.maxWidth / 1.95,
                          runSpacing: 18.0,
                          children: [
                            //inventory detail
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
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
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ' Inventory Detail',
                                      style: TextStyle(
                                        color: Color(0xFF75759E),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //delete, re-stock
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ReusableDeleteText(
                                  textSize: 16,
                                ),
                                SizedBox(width: 20),
                                Button(
                                  onTap: () {
                                    print('add new product');
                                  },
                                  buttonColor: Color(0xFF00509A),
                                  width: 100,
                                  child: Center(
                                    child: Text(
                                      'Re-stock',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
                        //product info
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
                                  'Product Info',
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
                                  runSpacing: 20,
                                  spacing: 55,
                                  children: [
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Product Name',
                                      widget: Text(
                                        'Carton of Smirnoff non-acholic drink 300cl',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Category',
                                      widget: Text(
                                        'Drinks',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Quantity',
                                      widget: Text(
                                        500.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Status',
                                      widget: Text(
                                        'InStock',
                                        style: TextStyle(
                                          color: inStockColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Unit Selling Price',
                                      widget: Text(Functions.money(20000, 'N')),
                                    ),
                                    SizedBox(width: 40),
                                    ReusableCustomerInfoFields(
                                      tableTitle: 'Last Re-payment Date',
                                      widget: Text(Functions.money(25000, 'N')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(height: 35),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restock History',
                        style: TextStyle(
                          color: Color(0xFF00509A),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 19),
                      Expanded(
                        child: RecentHistoryTable(),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      )),
    );
  }

  Future<void> _addDebt(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateController = TextEditingController();
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
                      'NEW DEBT',
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
              ), //new category header with cancel icon
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 42),
                        child: Text(
                          'Add Debt',
                          style: TextStyle(
                            color: Color(0xFF00509A),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15.0),
                        child: Text(
                          'You have made additional purchase on credit. Please fill the fields to record your credit purchase.',
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
                              ///text field for customer
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Obi Cubana and Sons Limited',
                                style: TextStyle(
                                  color: Color(0xFF1F1F1F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 30),

                              ///field for amount
                              Text(
                                'Amount',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
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
                                  keyboardType: TextInputType.name,
                                  controller: amountController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter amount';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              ///field for description
                              Text(
                                'Description',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
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
                                  keyboardType: TextInputType.name,
                                  controller: descriptionController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter reference or description';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter description',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              ///field for date
                              Text(
                                'Due Date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
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
                                  keyboardType: TextInputType.name,
                                  controller: dateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter due date';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      kTextFieldBorderDecoration.copyWith(
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
                        ),
                      ),
                      SizedBox(height: 40),
                      Button(
                        onTap: () {
                          print("Add Category");
                        },
                        buttonColor: Color(0xFF00509A),
                        child: Center(
                          child: Text(
                            'Record Debt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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

  Future<void> _recordRepayment(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
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
                      'DEBT REPAYMENT',
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
              ), //new category header with cancel icon
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 42),
                        child: Text(
                          'Debt repayment',
                          style: TextStyle(
                            color: Color(0xFF00509A),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15.0),
                        child: Text(
                          'You have made additional purchase on credit. Please fill the fields to repay your debt.',
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
                              ///text field for customer
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Obi Cubana and Sons Limited',
                                style: TextStyle(
                                  color: Color(0xFF1F1F1F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 30),

                              ///field for amount
                              Text(
                                'Amount',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
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
                                  keyboardType: TextInputType.name,
                                  controller: amountController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter amount';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              ///field for reference
                              Text(
                                'Due Date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
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
                                  keyboardType: TextInputType.name,
                                  controller: referenceController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter due date';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      kTextFieldBorderDecoration.copyWith(
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
                        ),
                      ),
                      SizedBox(height: 40),
                      Button(
                        onTap: () {
                          print("Add Category");
                        },
                        buttonColor: Color(0xFF00509A),
                        child: Center(
                          child: Text(
                            'Record Repayment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
}

class RecentHistoryTable extends StatelessWidget {

  const RecentHistoryTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          decoration: kTableContainer,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
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
                DataColumn(label: Text('Seller')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Unit Cost Price')),
                DataColumn(label: Text('Unit Selling Price')),
                DataColumn(label: Text('Amount')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('23, May 2021 - 12:13pm')),
                    DataCell(
                        Text('Obi Cubana and Sons Limited')),
                    DataCell(Text(500.toString())),
                    DataCell(
                        Text(Functions.money(50000, 'N'))),
                    DataCell(
                        Text(Functions.money(55000, 'N'))),
                    DataCell(Text(
                      Functions.money(1086000, 'N'),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('23, May 2021 - 12:13pm')),
                    DataCell(
                        Text('Obi Cubana and Sons Limited')),
                    DataCell(Text(500.toString())),
                    DataCell(
                        Text(Functions.money(50000, 'N'))),
                    DataCell(
                        Text(Functions.money(55000, 'N'))),
                    DataCell(Text(
                      Functions.money(1086000, 'N'),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('23, May 2021 - 12:13pm')),
                    DataCell(
                        Text('Obi Cubana and Sons Limited')),
                    DataCell(Text(500.toString())),
                    DataCell(
                        Text(Functions.money(50000, 'N'))),
                    DataCell(
                        Text(Functions.money(55000, 'N'))),
                    DataCell(Text(
                      Functions.money(1086000, 'N'),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('23, May 2021 - 12:13pm')),
                    DataCell(
                        Text('Obi Cubana and Sons Limited')),
                    DataCell(Text(500.toString())),
                    DataCell(
                        Text(Functions.money(50000, 'N'))),
                    DataCell(
                        Text(Functions.money(55000, 'N'))),
                    DataCell(Text(
                      Functions.money(1086000, 'N'),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class ReusableCustomerInfoFields extends StatelessWidget {
  ReusableCustomerInfoFields({
    Key? key,
    @required this.tableTitle,
    this.widget,
  }) : super(key: key);

  final String? tableTitle;

  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tableTitle!,
          style: TextStyle(
            color: Color(0xFF75759E),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 15),
        widget ?? Text('-', style: TextStyle(color: Colors.black)),
      ],
    );
  }
}

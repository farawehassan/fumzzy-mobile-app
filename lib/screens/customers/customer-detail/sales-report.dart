import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/model/all-customers.dart';
import 'package:fumzy/model/customer-reports.dart';
import 'package:fumzy/networking/customer-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SalesReport extends StatefulWidget {

  static const String id = 'sales-report';

  final AllCustomers? customer;

  final AllCustomerReport? reports;

  const SalesReport({
    Key? key,
    @required this.customer,
    @required this.reports
  }) : super(key: key);

  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {

  bool _showSpinner = false;

  Widget _buildTotalReports(){
    if(widget.reports!.report!.length > 0){
      List<DataRow> itemRow = [];
      for (int i = 0; i < widget.reports!.report!.length; i++){
        Report report = widget.reports!.report![i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(report.productName!)),
            DataCell(Text(report.quantity!.toString())),
            DataCell(Text(Functions.money(report.costPrice!, 'N'))),
            DataCell(Text(Functions.money(report.unitPrice!, 'N'))),
            DataCell(Text(Functions.money(report.totalPrice!, 'N'))),
          ]),
        );
      }
      return SingleChildScrollView(
        child: Container(
          decoration: kTableContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
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
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Cost Price')),
                      DataColumn(label: Text('Selling Price')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: itemRow,
                  )
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      );
    }
    else return Container();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBarWithBackButton(context, 'CUSTOMERS'),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Customer detail
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            ' Customer Detail',
                            style: TextStyle(
                              color: Color(0xFF75759E),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.7,
                            ),
                          ),
                        ],
                      ),
                      !widget.reports!.paid!
                          ? PopupMenuButton(
                        offset: Offset(110, 40),
                        icon: Icon(
                          Icons.more_horiz,
                          color: Color(0xFF00509A),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 0: { _recordRepayment();  } break;
                            case 1: { _markAsSettled(); } break;
                            case 2: { _deleteReport(); } break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Container(width: 135, child: Text('Record Payment')),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('Mark as settled'),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Color(0xFFF64932),
                                  size: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 1.5),
                                  child: Text(
                                    'Delete Sales',
                                    style: TextStyle(color: Color(0xFFF64932)),
                                  ),
                                ),
                              ],
                            ),
                            value: 2,
                          ),
                        ],
                      )
                          : PopupMenuButton(
                        offset: Offset(110, 40),
                        icon: Icon(
                          Icons.more_horiz,
                          color: Color(0xFF00509A),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 0: { _deleteReport(); } break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Color(0xFFF64932),
                                  size: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 1.5),
                                  child: Text(
                                    'Delete Sales',
                                    style: TextStyle(color: Color(0xFFF64932)),
                                  ),
                                ),
                              ],
                            ),
                            value: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  // Customers info
                  Container(
                    width: constraints.maxWidth,
                    decoration: kTableContainer,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer’s Info',
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
                              tableTitle: 'Name',
                              widget: Text(widget.customer!.name!),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Total Amount',
                              widget: Text(
                                Functions.money(widget.reports!.totalAmount!, 'N'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            !widget.reports!.paid!
                                ? ReusableCustomerInfoFields(
                              tableTitle: 'Amount Paid',
                              widget: Text(
                                Functions.money(widget.reports!.paymentMade!, 'N'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                                : Container(),
                            !widget.reports!.paid!
                                ? ReusableCustomerInfoFields(
                              tableTitle: 'Balance',
                              widget: Text(
                                Functions.money((widget.reports!.totalAmount! - widget.reports!.paymentMade!), 'N'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                                : Container(),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Sales Volume',
                              widget: Text(
                                  widget.reports!.report!.length.toString()
                              ),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Date',
                              widget: Text(
                                Functions.getFormattedDateTimeN(widget.reports!.soldAt!),
                              ),
                            ),
                            !widget.reports!.paid!
                                ? ReusableCustomerInfoFields(
                              tableTitle: 'Due Date',
                              widget: Text(
                                Functions.getFormattedDate(widget.reports!.dueDate!),
                              ),
                            )
                                : Container(),
                            widget.reports!.description!.isNotEmpty
                                ? ReusableCustomerInfoFields(
                              tableTitle: 'Reference',
                              widget: Text(widget.reports!.description!),
                              )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  _buildTotalReports(),
                ],
              ),
            )
        ),
      )),
    );
  }

  Future<void> _recordRepayment() {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = widget.reports!.description!.isNotEmpty
        ? widget.reports!.description!
        : 'Invoice ' + widget.reports!.id!.substring(0, 8);

    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      barrierDismissible: false,
      builder: (context) => GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AbsorbPointer(
                absorbing: _showSpinner,
                child: Container(
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
                        ),
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
                                        /// Customer name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Customer Name'),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.customer!.name!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Color(0xFF1F1F1F)
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Amount
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Payment Made'),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.number,
                                              controller: amountController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter amount';
                                                if ((double.parse(value) + widget.reports!.paymentMade!) > widget.reports!.totalAmount!){
                                                  return 'Invalid amount';
                                                }
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter amount',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Description
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Description'),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              controller: referenceController,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter description';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter description',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Button(
                                  onTap: () {
                                    if(formKey.currentState!.validate()){
                                      Map<String, dynamic> body = {
                                        'id': widget.customer!.id,
                                        'reportId': widget.reports!.id,
                                        'payment': amountController.text
                                      };
                                      _updatePayment(body, setDialogState);
                                    }
                                  },
                                  buttonColor: Color(0xFF00509A),
                                  child: Center(
                                    child: _showSpinner
                                        ? CircleProgressIndicator()
                                        : Text(
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
                                SizedBox(height: 10),
                                Container(
                                  width: 100,
                                  child: TextButton(
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
                                ),
                                SizedBox(height: 50),
                                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
        ),
      ),
    );
  }

  Future<void> _markAsSettled() {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    amountController.text = widget.reports!.totalAmount!.toString();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = widget.reports!.description!.isNotEmpty
        ? widget.reports!.description!
        : 'Invoice ' + widget.reports!.id!.substring(0, 8);

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AbsorbPointer(
                absorbing: _showSpinner,
                child: Container(
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
                                'MARK AS SETTLED',
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
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(top: 42),
                                child: Text(
                                  'Are you sure you want to mark this Debt as settled?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15.0),
                                child: Text(
                                  'This will mean that this person no longer owes you and you wont find them under the debtor\'s list.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF000428).withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// Customer name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Creditor Name'),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.customer!.name!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Color(0xFF1F1F1F)
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Amount
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Payment Made'),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.number,
                                              controller: amountController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                              ],
                                              readOnly: true,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter amount';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter amount',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Description
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Description'),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              controller: referenceController,
                                              readOnly: true,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter description';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter description',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                      ]
                                  ),
                                ),
                              ),
                              Button(
                                onTap: () {
                                  if(formKey.currentState!.validate()){
                                    Map<String, dynamic> body = {
                                      'id': widget.customer!.id,
                                      'reportId': widget.reports!.id,
                                      'payment': widget.reports!.totalAmount,
                                      'paymentReceivedAt': DateTime.now().toIso8601String()
                                    };
                                    _settlePayment(body, setDialogState);
                                  }
                                },
                                buttonColor: Color(0xFFF64932),
                                child: Center(
                                  child:  _showSpinner
                                      ? CircleProgressIndicator()
                                      : Text(
                                    'Yes, Mark as settled',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 100,
                                child: TextButton(
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
                              ),
                              SizedBox(height: 50),
                              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
        ),
      ),
    );
  }

  Future<void> _deleteReport() {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountPaidController = TextEditingController();
    amountPaidController.text = widget.reports!.totalAmount!.toString();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = widget.reports!.description!.isNotEmpty
        ? widget.reports!.description!
        : 'Invoice ' + widget.reports!.id!.substring(0, 8);

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AbsorbPointer(
                absorbing: _showSpinner,
                child: Container(
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
                                'DELETE REPORT',
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
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(top: 42),
                                child: Text(
                                  'Are you sure you want to delete this report?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15.0),
                                child: Text(
                                  'This will mean that this person no longer owes you for this and you wont find them under the debtor\'s list.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF000428).withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// Customer name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Creditor Name'),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.customer!.name!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Color(0xFF1F1F1F)
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Total amount
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Total Amount'),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.number,
                                              controller: amountPaidController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                              ],
                                              readOnly: true,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter amount';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter amount',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Description
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Description'),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              controller: referenceController,
                                              readOnly: true,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter description';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter description',
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                      ]
                                  ),
                                ),
                              ),
                              Button(
                                onTap: () {
                                  if(formKey.currentState!.validate()){
                                    Map<String, dynamic> body = {
                                      'customerId': widget.customer!.id,
                                      'reportId': widget.reports!.id,
                                    };
                                    _removeReport(body, setDialogState);
                                  }
                                },
                                buttonColor: Color(0xFFF64932),
                                child: Center(
                                  child:  _showSpinner
                                      ? CircleProgressIndicator()
                                      : Text(
                                    'Yes, Mark as settled',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 100,
                                child: TextButton(
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
                              ),
                              SizedBox(height: 50),
                              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
        ),
      ),
    );
  }

  /// function to make api call to [updatePaymentMade] with the help of
  /// [CustomerDataSource]
  void _updatePayment(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.updatePaymentMade(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

  /// function to make api call to [settlePayment] with the help of
  /// [CustomerDataSource]
  void _settlePayment(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.settlePayment(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

  /// function to make api call to [removeReport] with the help of
  /// [CustomerDataSource]
  void _removeReport(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.removeReport(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}

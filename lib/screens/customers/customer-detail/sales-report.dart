import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/model/all-customers.dart';
import 'package:fumzy/model/customer-reports.dart';
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

  Widget _buildTotalReports(){
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
                      //delete, mark as settled
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 15,
                            width: 30,
                            child: Checkbox(
                              value: widget.reports!.paid,
                              onChanged: (onChanged) {
                                if (!widget.reports!.paid!){
                                  _markAsSettled();
                                }
                              },
                              activeColor: Color(0xFF00AF27),
                              checkColor: Colors.white,
                              shape: CircleBorder(),
                              splashRadius: 23,
                            ),
                          ),
                          Text(
                            'Mark as Settled',
                            style: TextStyle(
                              color: Color(0xFF052121),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
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
                              ),
                            ),
                            !widget.reports!.paid!
                                ? ReusableCustomerInfoFields(
                              tableTitle: 'Amount Paid',
                              widget: Text(
                                Functions.money(widget.reports!.paymentMade!, 'N'),
                              ),
                            )
                                : Container(),
                            !widget.reports!.paid!
                                ? ReusableCustomerInfoFields(
                              tableTitle: 'Balance',
                              widget: Text(
                                Functions.money((widget.reports!.totalAmount! - widget.reports!.paymentMade!), 'N'),
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
                                Functions.getFormattedDateTime(widget.reports!.soldAt!),
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

  Future<void> _markAsSettled() {
    final formKey = GlobalKey<FormState>();
    String newPin = '';
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
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Enter your PIN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 13),
                                    Container(
                                      width: 280,
                                      child: PinCodeTextField(
                                          appContext: context,
                                          length: 4,
                                          animationType: AnimationType.fade,
                                          enablePinAutofill: false,
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF004E92),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderWidth: 1,
                                            fieldHeight: 60,
                                            fieldWidth: 60,
                                            activeColor: Color(0xFF7BBBE5),
                                            selectedColor: Color(0xFF7BBBE5),
                                            borderRadius: BorderRadius.all(Radius.circular(3)),
                                          ),
                                          onChanged: (value) {
                                            if (!mounted) return;
                                            setState(() {
                                              newPin = value;
                                            });
                                          }),
                                    ),
                                    SizedBox(height: 36),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Button(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {

                        });
                      },
                      buttonColor: Color(0xFFF64932),
                      child: Center(
                        child: Text(
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
      ),
    );
  }

}

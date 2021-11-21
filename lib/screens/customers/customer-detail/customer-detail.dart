import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/components/invoice-pdf-download.dart';
import 'package:fumzy/model/all-customers.dart';
import 'package:fumzy/model/customer-reports.dart';
import 'package:fumzy/networking/customer-datasource.dart';
import 'package:fumzy/screens/transactions/print-receipt.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'sales-report.dart';
import 'package:fumzy/components/info-table.dart';

class CustomersDetail extends StatefulWidget {

  static const String id = 'customerDetail';

  final AllCustomers? customer;

  const CustomersDetail({
    Key? key,
    @required this.customer,
  }) : super(key: key);

  @override
  _CustomersDetailState createState() => _CustomersDetailState();
}

class _CustomersDetailState extends State<CustomersDetail> {

  bool checkBoxValue = false;

  bool _showSpinner = false;

  Map<String, Color> _statusColor = {
    'Part Paid': Color(0xFFF28301),
    'Fully Paid': Color(0xFF00AF27),
    'Credit': Color(0xFFF64932),
    '': Colors.transparent
  };

  double _totalSales = 0;

  double _totalDebts = 0;

  DateTime? _lastRepaymentDate;

  void _calculateTotalSales(){
    if(!mounted)return;
    setState(() {
      widget.customer!.reports!.forEach((element) {
        _totalSales += element.totalAmount!;
        if(!element.paid!){
          _totalDebts += element.totalAmount! - element.paymentMade!;
          if(_lastRepaymentDate == null) _lastRepaymentDate = element.dueDate!;
        }
      });
    });
  }

  Widget _buildTotalSales(){
    List<DataRow> itemRow = [];
    for (int i = 0; i < widget.customer!.reports!.length; i++){
      AllCustomerReport report = widget.customer!.reports![i];
      String paymentStatus = '';
      if(report.paid!) paymentStatus = 'Fully Paid';
      else {
        if(report.paymentMade == 0) paymentStatus = 'Credit';
        else paymentStatus = 'Part Paid';
      }
      itemRow.add(
        DataRow(cells: [
          DataCell(InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrintReceipt(
                      reports: report.toJson(),
                      paymentMode: 'Cash',
                      name: widget.customer!.name!
                  ),
                ),
              );
            },
            child: ReusableDownloadPdf(invoiceNo: report.id!.substring(0, 8)))
          ),
          DataCell(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Indicator(
                indicatorColor: _statusColor[paymentStatus]!,
              ),
              SizedBox(width: 4),
              Text(paymentStatus, style: TextStyle(color: _statusColor[paymentStatus])),
            ],
          )),
          DataCell(Text(Functions.money(report.totalAmount!, 'N'))),
          DataCell(Text(Functions.getFormattedDateTime(report.soldAt!))),
        ],
        onSelectChanged: (value){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesReport(
                customer: widget.customer,
                reports: report,
              ),
            ),
          );
        }),
      );
    }
    List<DataRow> items = [];
    items.addAll(itemRow.reversed);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(bottom: 80),
        decoration: kTableContainer,
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
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date')),
          ],
          rows: items,
        ),
      )
    );
  }

  Widget _buildDebtHistory(){
    List<DataRow> itemRow = [];
    for (int i = 0; i < widget.customer!.reports!.length; i++){
      if(!widget.customer!.reports![i].paid!){
        AllCustomerReport report = widget.customer!.reports![i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(Functions.money((report.totalAmount! - report.paymentMade!), 'N'))),
            DataCell(InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrintReceipt(
                        reports: report.toJson(),
                        paymentMode: 'Cash',
                        name: widget.customer!.name!
                    ),
                  ),
                );
              },
              child: ReusableDownloadPdf(invoiceNo: report.id!.substring(0, 8)))
            ),
            DataCell(Text(Functions.getFormattedDateTime(report.soldAt!))),
            DataCell(Text(
              Functions.getFormattedDateTime(report.dueDate!),
              style: TextStyle(
                color: Color(0xFFF64932),
              ),
            )),
            DataCell(PopupMenuButton(
              offset: Offset(110, 40),
              icon: Icon(Icons.more_horiz, color: Color(0xFF00509A)),
              onSelected: (value) {
                switch (value) {
                  case 0: { _recordRepayment(report); } break;
                  case 1: { _markAsSettled(report); } break;
                  case 2: { _deleteReport(report); } break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Container(width: 135, child: Text('Record Payment')),
                  value: 0,
                ),
                PopupMenuItem(child: Text('Mark as settled'), value: 1),
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
                          'Delete Credit',
                          style: TextStyle(color: Color(0xFFF64932)),
                        ),
                      ),
                    ],
                  ),
                  value: 2,
                ),
              ],
            )),
          ],
          onSelectChanged: (value){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesReport(
                  customer: widget.customer,
                  reports: report,
                ),
              ),
            );
          }),
        );
      }
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 80),
          decoration: kTableContainer,
          child: DataTable(
            headingTextStyle: TextStyle(
              color: Color(0xFF75759E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            dataTextStyle: TextStyle(
              color: Color(0xFF1F1F1F),
              fontSize: 14,
            ),
            columnSpacing: 15.0,
            dataRowHeight: 65.0,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Total Sales')),
              DataColumn(label: Text('Invoice/Reference')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Due Date')),
              DataColumn(label: Text('')),
            ],
            rows: itemRow,
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.customer != null) _calculateTotalSales();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBarWithBackButton(context, 'CUSTOMERS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
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
                           Container(),
                          ],
                        ),
                        SizedBox(height: 35),
                        // customers info
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
                                    tableTitle: 'Total Sales',
                                    widget: Text(
                                      Functions.money(_totalSales, 'N'),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Sales Volume',
                                    widget: Text(
                                      widget.customer!.reports!.length.toString()
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'On-board Date',
                                    widget: Text(
                                      Functions.getFormattedDateTimeN(widget.customer!.createdAt!),
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Total Debts',
                                    widget: Text(
                                      Functions.money(_totalDebts, 'N'),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Last Re-payment Date',
                                    widget: Text(
                                      _lastRepaymentDate == null
                                          ? ''
                                          : Functions.getFormattedDateTimeN(_lastRepaymentDate!),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 300,
                      child: TabBar(
                        labelStyle: kTabBarTextStyle,
                        labelColor: Color(0xFF004E92),
                        unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                        indicatorColor: Color(0xFF004E92),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(child: Text('Total Sales', style: kTabBarTextStyle)),
                          Tab(child: Text('Debt History', style: kTabBarTextStyle)),
                          // Tab(child: Text('Re-payment History', style: kTabBarTextStyle)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.end,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              _addDebt(constraints);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                              ),
                              side: BorderSide(color: Color(0xFF004E92)),
                            ),
                            child: Container(
                              width: 120,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Add Debt',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF004E92),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*Button(
                            onTap: () {
                              _recordRepayment(constraints);
                            },
                            buttonColor: Color(0xFF00509A),
                            width: 120,
                            child: Center(
                              child: Text(
                                'Record Payment',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTotalSales(),
                      _buildDebtHistory(),
                      //RepaymentHistory(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      )),
    );
  }

  Future<void> _addDebt(BoxConstraints constraints) {

    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
    TextEditingController dueDate = TextEditingController();
    DateTime? dueDateTime;

    return showDialog(
      context: context,
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
                                    'You have made additional sales on credit. Please fill the fields to record your credit sales.',
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
                                          children: [
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
                                              widget.customer!.name!,
                                              style: TextStyle(
                                                color: Color(0xFF1F1F1F),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        /// Amount
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Amount'),
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
                                                controller: amountController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter amount';
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
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        /// Reference
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Reference'),
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
                                                    return 'Enter reference or description';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: 'Enter reference or description',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  contentPadding: EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        /// Due date
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Due Date'),
                                            SizedBox(height: 10),
                                            Container(
                                              width: constraints.maxWidth,
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                keyboardType: TextInputType.text,
                                                controller: dueDate,
                                                readOnly: true,
                                                onTap: () async {
                                                  DateTime now = DateTime.now();
                                                  final DateTime? picked = await showDatePicker(
                                                      context: context,
                                                      initialDate: now,
                                                      firstDate: now,
                                                      lastDate: DateTime(2030),
                                                      builder: (BuildContext context, Widget? child) {
                                                        return Theme(
                                                          data: ThemeData.light().copyWith(
                                                            colorScheme: ColorScheme.light().copyWith(
                                                              primary: Color(0xFF00509A),
                                                            ),
                                                          ),
                                                          child: child!,
                                                        );
                                                      }
                                                  );
                                                  if (picked != null && picked != now) {
                                                    if (!mounted) return;
                                                    setDialogState(() {
                                                      dueDateTime = picked;
                                                      dueDate.text = Functions.getFormattedDate(picked);
                                                    });
                                                  }
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter due date';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: 'Select due date',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  contentPadding: EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Button(
                                  onTap: () {
                                    if(formKey.currentState!.validate()){
                                      Map<String, dynamic> body = {
                                        'id': widget.customer!.id!,
                                        'totalAmount': amountController.text,
                                        'soldAt': DateTime.now().toIso8601String(),
                                        'dueDate': dueDateTime!.toIso8601String(),
                                        'description': referenceController.text
                                      };
                                      _addDebtorReports(body, setDialogState);
                                    }
                                  },
                                  buttonColor: Color(0xFF00509A),
                                  child: Center(
                                    child: _showSpinner
                                        ? CircleProgressIndicator()
                                        : Text(
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

  /// function to make api call to [addPreviousCustomerReports] with the help of
  /// [CustomerDataSource]
  Future<void> _addDebtorReports(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.addPreviousCustomerReports(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      Navigator.pop(context);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

  Future<void> _recordRepayment(AllCustomerReport reports) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = reports.description!.isNotEmpty
        ? reports.description!
        : 'Invoice ' + reports.id!.substring(0, 8);

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
                                                if ((double.parse(value) + reports.paymentMade!) > reports.totalAmount!){
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
                                        'reportId': reports.id,
                                        'payment': double.parse(amountController.text),
                                        'totalPaid': reports.paymentMade! + double.parse(amountController.text)
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

  Future<void> _markAsSettled(AllCustomerReport reports) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    amountController.text = reports.totalAmount!.toString();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = reports.description!.isNotEmpty
        ? reports.description!
        : 'Invoice ' + reports.id!.substring(0, 8);

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
                                      'reportId': reports.id,
                                      'payment': reports.totalAmount! - reports.paymentMade!,
                                      'totalPayment': reports.totalAmount,
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

  Future<void> _deleteReport(AllCustomerReport reports) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountPaidController = TextEditingController();
    amountPaidController.text = reports.totalAmount!.toString();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = reports.description!.isNotEmpty
        ? reports.description!
        : 'Invoice ' + reports.id!.substring(0, 8);

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
                                      'reportId': reports.id,
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
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}

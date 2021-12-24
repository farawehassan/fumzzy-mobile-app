import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/model/creditor-report.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/networking/creditor-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:fumzy/components/info-table.dart';
import 'repayment-history.dart';

enum PaymentMode { cash, transfer }

PaymentMode? _paymentMode = PaymentMode.cash;

class CreditorsDetail extends StatefulWidget {

  static const String id = 'creditorDetail';

  final Creditor? creditor;

  const CreditorsDetail({
    Key? key,
    @required this.creditor,
  }) : super(key: key);

  @override
  _CreditorsDetailState createState() => _CreditorsDetailState();
}

class _CreditorsDetailState extends State<CreditorsDetail> {

  bool checkBoxValue = false;

  bool _showSpinner = false;

  double _totalCredits = 0;

  DateTime? _lastRepaymentDate;

  void _calculateTotalCredits(){
    if(!mounted)return;
    setState(() {
      _lastRepaymentDate = widget.creditor!.updatedAt!;
      widget.creditor!.reports!.forEach((element) {
        _totalCredits += element.amount!;
      });
    });
  }

  Widget _buildCreditHistory(){
    List<DataRow> itemRow = [];
    for (int i = 0; i < widget.creditor!.reports!.length; i++){
      CreditorReport report = widget.creditor!.reports![i];
      itemRow.add(
        DataRow(cells: [
          DataCell(Text(Functions.money(report.amount!, 'N'))),
          DataCell(Text(report.description!)),
          DataCell(Text(Functions.money(report.paymentMade!, 'N'))),
          DataCell(Text(Functions.money(report.amount! - report.paymentMade!, 'N'))),
          DataCell(PopupMenuButton(
            offset: Offset(110, 40),
            icon: Icon(
              Icons.more_horiz,
              color: Color(0xFF00509A),
            ),
            onSelected: (value) {
              switch (value) {
                case 0: { _recordRepayment(report); } break;
                case 1: { _markAsSettled(report); } break;
                case 2: { _delete(report); } break;
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
              builder: (context) => CreditorRepaymentHistory(
                creditor: widget.creditor,
                report: report,
              ),
            ),
          );
        }),
      );
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Container(
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
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Payment Made')),
              DataColumn(label: Text('Balance')),
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
    _calculateTotalCredits();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBarWithBackButton(context, 'CREDITORS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: DefaultTabController(
            length: 1,
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
                            // Creditor detail
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
                                  ' Credit Details',
                                  style: TextStyle(
                                    color: Color(0xFF75759E),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.7,
                                  ),
                                ),
                              ],
                            ),
                            Container()
                          ],
                        ),
                        SizedBox(height: 35),
                        // creditors info
                        Container(
                          width: constraints.maxWidth,
                          decoration: kTableContainer,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Creditors’s Info',
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
                                    widget: Text(widget.creditor!.name!),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Total Credits',
                                    widget: Text(
                                      Functions.money(_totalCredits, 'N'),
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Last Re-payment Date',
                                    widget: Text(
                                      _lastRepaymentDate == null
                                          ? ''
                                          : Functions.getFormattedDateTime(_lastRepaymentDate!),
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
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        labelStyle: kTabBarTextStyle,
                        labelColor: Color(0xFF004E92),
                        unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                        indicatorColor: Color(0xFF004E92),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(child: Text('Credit History', style: kTabBarTextStyle)),
                          //Tab(child: Text('Re-payment History', style: kTabBarTextStyle)),
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
                              _addCredit(constraints);
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
                                  'Add Credit',
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildCreditHistory(),
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

  Future<void> _addCredit(BoxConstraints constraints) {

    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();

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
                                'NEW CREDIT',
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
                                    'Add Credit',
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
                                        /// Creditor name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Creditor Name'),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.creditor!.name!,
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
                                        'creditorId': widget.creditor!.id!,
                                        'amount': amountController.text,
                                        'paymentMade': 0,
                                        'description': referenceController.text
                                      };
                                      _addNewCredit(body, setDialogState);
                                    }
                                  },
                                  buttonColor: Color(0xFF00509A),
                                  child: Center(
                                    child: _showSpinner
                                        ? CircleProgressIndicator()
                                        : Text(
                                      'Record Credit',
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

  /// function to make api call to [addCredit] with the help of
  /// [CreditorsDataSource]
  Future<void> _addNewCredit(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.addCredit(body).then((message) async{
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

  Future<void> _recordRepayment(CreditorReport reports) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = reports.description!;

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
                                        /// Creditor name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Creditor Name'),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.creditor!.name!,
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
                                                if ((double.parse(value) + reports.paymentMade!) > reports.amount!){
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
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Cash
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Radio<PaymentMode>(
                                                  value: PaymentMode.cash,
                                                  activeColor: Color(0xFF00509A),
                                                  groupValue: _paymentMode,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                  ),
                                                  onChanged: (PaymentMode? value) {
                                                    setDialogState(() { _paymentMode = value; });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    'Cash',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 15),
                                            // Transfer
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Radio<PaymentMode>(
                                                  value: PaymentMode.transfer,
                                                  activeColor: Color(0xFF00509A),
                                                  groupValue: _paymentMode,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                  ),
                                                  onChanged: (PaymentMode? value) {
                                                    setDialogState(() { _paymentMode = value; });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    'Transfer',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
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
                                        'creditorId': widget.creditor!.id,
                                        'reportId': reports.id,
                                        'amount': reports.amount,
                                        'payment': double.parse(amountController.text),
                                        'paymentMade': reports.paymentMade!
                                            + double.parse(amountController.text),
                                        'paymentMode': _paymentMode == PaymentMode.cash ? 'Cash' : 'Transfer',
                                        'description': referenceController.text
                                      };
                                      _updateCredit(body, setDialogState);
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

  Future<void> _markAsSettled(CreditorReport reports) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    amountController.text = reports.amount!.toString();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = reports.description!;

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
                                        /// Creditor name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Creditor Name'),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.creditor!.name!,
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
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Cash
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Radio<PaymentMode>(
                                                  value: PaymentMode.cash,
                                                  activeColor: Color(0xFF00509A),
                                                  groupValue: _paymentMode,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                  ),
                                                  onChanged: (PaymentMode? value) {
                                                    setDialogState(() { _paymentMode = value; });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    'Cash',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 15),
                                            // Transfer
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Radio<PaymentMode>(
                                                  value: PaymentMode.transfer,
                                                  activeColor: Color(0xFF00509A),
                                                  groupValue: _paymentMode,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                  ),
                                                  onChanged: (PaymentMode? value) {
                                                    setDialogState(() { _paymentMode = value; });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    'Transfer',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
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
                                      'creditorId': widget.creditor!.id,
                                      'reportId': reports.id,
                                      'amount': reports.amount,
                                      'payment': reports.amount! - reports.paymentMade!,
                                      'paymentMade': reports.amount,
                                      'paymentMode': _paymentMode == PaymentMode.cash ? 'Cash' : 'Transfer',
                                      'description': referenceController.text
                                    };
                                    _updateCredit(body, setDialogState);
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

  Future<void> _delete(CreditorReport reports) {
    TextEditingController amountController = TextEditingController();
    amountController.text = reports.amount!.toString();
    TextEditingController referenceController = TextEditingController();
    referenceController.text = reports.description!;

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
            return  AbsorbPointer(
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
                              'DELETE CREDIT',
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
                              child: const Text(
                                'Are you sure you want to delete this credit?',
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
                                'This means that this credit is settled and is wished not to be found on the creditors list',
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
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Creditor name
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Creditor Name'),
                                        SizedBox(height: 10),
                                        Text(
                                          widget.creditor!.name!,
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
                            Button(
                              onTap: () {
                                if(!_showSpinner){
                                  Map<String, String> body = {
                                    'creditorId': widget.creditor!.id!,
                                    'reportId': reports.id!
                                  };
                                  _deleteCredit(body, setDialogState);
                                }
                              },
                              buttonColor: Color(0xFFF64932),
                              child: Center(
                                child: _showSpinner
                                    ? CircleProgressIndicator()
                                    : const Text(
                                  'Yes, delete',
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
          },
        ),
      ),
    );
  }

  /// function to make api call to [updateCreditor] with the help of
  /// [CreditorsDataSource]
  void _updateCredit(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.updateCreditor(body).then((message) async{
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

  /// function to make api call to [removeCredit] with the help of
  /// [CreditorsDataSource]
  void _deleteCredit(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.removeCredit(body).then((message) async{
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

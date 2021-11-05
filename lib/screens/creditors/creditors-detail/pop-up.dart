import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/model/creditor-report.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/networking/creditor-datasource.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ReusablePopMenu extends StatefulWidget {

  final CreditorReport? report;
  final Creditor? creditor;

  ReusablePopMenu({
    required this.report,
    required this.creditor
  });

  @override
  State<ReusablePopMenu> createState() => _ReusablePopMenuState();
}

class _ReusablePopMenuState extends State<ReusablePopMenu> {

  var _futureValue = FutureValues();

  bool _showSpinner = false;

  bool checkBoxValue = false;

  String _adminPin = '';

  Future<void> _getAdminPin() async{
    Future<User> user = _futureValue.getCurrentUser();
    await user.then((value) {
      setState(() => _adminPin = value.name!);
    });
  }

  @override
  void initState() {
    super.initState();
    // _getAdminPin();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(110, 40),
      icon: Icon(
        Icons.more_horiz,
        color: Color(0xFF00509A),
      ),
      onSelected: (value) {
        switch (value) {
          case 0:
            {
              _creditRepayment();
            }
            break;
          case 1:
            {
              _markAsSettled();
            }
            break;
          case 2:
            {
              _deleteCredit();
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Container(width: 135, child: Text('Credit Repayment')),
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
    );
  }

  Future<void> _creditRepayment() {

    final _formKey = GlobalKey<FormState>();
    TextEditingController _amountController = TextEditingController();
    TextEditingController _paymentMadeController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    _amountController.text = widget.report!.amount!.toString();
    _descriptionController.text = widget.report!.description!;

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
                              'CREDIT REPAYMENT',
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
                                  'Credit repayment',
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
                                child: Text(
                                  'You have made additional purchase on credit. Please fill the fields to record your creedit purchase.',
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
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///text field for customer
                                      Text(
                                        'Creditor\'s Name',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        widget.creditor!.name!,
                                        style: TextStyle(
                                          color: Color(0xFF1F1F1F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      ///field for amount
                                      Text('Amount'),
                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          readOnly: true,
                                          controller: _amountController,
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ///field for payment made
                                      Text('Payment Made'),
                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          controller: _paymentMadeController,
                                          validator: (value) {
                                            if (value!.isEmpty) return 'Enter payment amount';
                                            return null;
                                          },
                                          decoration: kTextFieldBorderDecoration.copyWith(
                                            hintText: 'Enter payment amount',
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
                                      Text('Description'),
                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          controller: _descriptionController,
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
                                  if(!_showSpinner){
                                    if(_formKey.currentState!.validate()){
                                      Map<String, dynamic> body = {
                                        "creditorId": widget.creditor!.id!,
                                        "reportId": widget.report!.id!,
                                        "amount": widget.report!.amount!,
                                        "paymentMade": _paymentMadeController.text,
                                        "description": widget.report!.description!
                                      };
                                      _updateCredit(body, setDialogState);
                                    }
                                  }
                                },
                                buttonColor: Color(0xFF00509A),
                                child: Center(
                                  child: _showSpinner ?
                                  CircleProgressIndicator() :
                                  const Text(
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
              ),
            );
          },
        ),
      ),
    );
  }

  /// Function to call api [UPDATE_CREDIT]
  void _updateCredit(Map<String, dynamic> body,StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.updateCreditor(body).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'CREDIT REPAYMENT',
          'Credit payed Successfully',
          'Credit has been payed successfully. Go back to review other credits',
          Color(0xFF00CFA0),
        );
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }

  Future<void> _markAsSettled() {

    final _formKey = GlobalKey<FormState>();

    TextEditingController reasonController = TextEditingController();

    String _confirmPin = '';

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
                                'Are you sure you want to mark this Credit as settled?',
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
                                'This will mean that you no longer owe this person and you wont find them under the creditors\'s list.',
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
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Reason'),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              controller: reasonController,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter reason';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter reason',
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
                                      SizedBox(height: 30),
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
                                                  validator: (value) {
                                                    if (value!.isEmpty) return 'Enter 4 digit PIN';
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    if (!mounted) return;
                                                    setState(() => _confirmPin = value);
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
                                if(!_showSpinner){
                                  if(_formKey.currentState!.validate()){
                                    if(_confirmPin.length == 4){
                                      if (checkBoxValue == false) {
                                        checkBoxValue = true;
                                        _markSettled(setDialogState);
                                      } else {
                                        checkBoxValue = true;
                                      }// if(_confirmPin == _adminPin)
                                      // Functions.showErrorMessage('Reconfirm your pin and try again!');
                                    }
                                    else {
                                      Functions.showErrorMessage('Enter a valid 4 digit Pin!');
                                    }
                                  }
                                }
                              },
                              buttonColor: Color(0xFF00509A),
                              child: Center(
                                child:  _showSpinner ?
                                CircleProgressIndicator() :
                                const Text(
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
          },
        ),
      ),
    );
  }

  /// Function to call api [MARK_SETTLED]
  void _markSettled(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.getAllCreditors().then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'SETTLE CREDIT',
          'Credit Settled Successfully',
          'Credit has been settled successfully. Go back to review other credits',
          Color(0xFF00CFA0),
        );
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }

  Future<void> _deleteCredit() {

    final _formKey = GlobalKey<FormState>();

    TextEditingController reasonController = TextEditingController();

    String _confirmPin = '';

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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Reason'),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              controller: reasonController,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter reason';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter reason',
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
                                      SizedBox(height: 30),
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
                                                  validator: (value) {
                                                    if (value!.isEmpty) return 'Enter your 4 digit PIN!';
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    if (!mounted) return;
                                                    setState(() => _confirmPin = value);
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
                                if(!_showSpinner){
                                  if(_formKey.currentState!.validate()){
                                    if(_confirmPin.length == 4){
                                      Map<String, String> body = {
                                        "creditorId": widget.creditor!.id!,
                                        "reportId": widget.report!.id!
                                      };
                                      _creditDelete(body, setDialogState); // if(_confirmPin == _adminPin)
                                      // Functions.showErrorMessage('Reconfirm your pin and try again!');
                                    }
                                    else {
                                      Functions.showErrorMessage('Enter a valid 4 digit Pin!');
                                    }
                                  }
                                }
                              },
                              buttonColor: Color(0xFFF64932),
                              child: Center(
                                child: _showSpinner ?
                                CircleProgressIndicator() :
                                const Text(
                                  'Yes, delete',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
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

  /// Function to call api [DELETE_CREDIT]
  void _creditDelete(Map<String, String> body,StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.removeCreditor(body).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'DELETE CREDIT',
          'Credit Deleted Successfully',
          'Credit has been deleted successfully. Go back to review other credits',
          Color(0xFF00CFA0),
        );
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }

  Future<void> _popUpMessage(

      String title,
      String heading,
      String subheading,
      Color doneColor

      ) {
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
                      title,
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
                            color: doneColor.withOpacity(0.15),
                          ),
                          child: Icon(
                            Icons.done_rounded,
                            color: doneColor,
                            size: 45,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 22),
                          child: Text(
                            heading,
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
                            subheading,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF000428).withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Button(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          buttonColor: Color(0xFF00509A),
                          child: Center(
                            child: Text(
                              'Go back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
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

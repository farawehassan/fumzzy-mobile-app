import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ReusablePopMenu extends StatefulWidget {

  final String userId;

  ReusablePopMenu({required this.userId});

  @override
  State<ReusablePopMenu> createState() => _ReusablePopMenuState();
}

class _ReusablePopMenuState extends State<ReusablePopMenu> {

  var _futureValue = FutureValues();

  bool _showSpinner = false;

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
              _resetPin();
            }
            break;
          case 1:
            {
              _block();
            }
            break;
          case 2:
            {
              _activate();
            }
            break;
          case 3:
            {
              _deletePermanently();
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Container(width: 135, child: Text('Reset Pin')),
          value: 0,
        ),
        PopupMenuItem(
          child: Text('Block'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('Activate'),
          value: 2,
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
                  'Delete Permanently',
                  style: TextStyle(color: Color(0xFFF64932)),
                ),
              ),
            ],
          ),
          value: 3,
        ),
      ],
    );
  }

  Future<void> _resetPin() {

    final _formKey = GlobalKey<FormState>();

    String _newPin = '';

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
                              'NEW STAFF',
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
                                'Reset PIN',
                                style: TextStyle(
                                  color: Color(0xFF00509A),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
                              child: Text(
                                'To add a new staff pin set a solid 4-digit pin for the new staff and confirm.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF000428).withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
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
                                      SizedBox(height: 20),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'New PIN',
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
                                                validator: (value) {
                                                  if (value!.isEmpty) return 'Enter your 4 digit PIN!';
                                                  return null;
                                                },
                                                pinTheme: PinTheme(
                                                  shape: PinCodeFieldShape.box,
                                                  borderWidth: 1,
                                                  fieldHeight: 60,
                                                  fieldWidth: 60,
                                                  activeColor: Color(0xFF7BBBE5),
                                                  selectedColor: Color(0xFF7BBBE5),
                                                  borderRadius: BorderRadius.all(Radius.circular(3))),
                                                onChanged: (value) {
                                                  if (!mounted) return;
                                                  setState(() => _newPin = value);
                                                }),
                                            ),
                                            SizedBox(height: 36),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Confirm PIN',
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
                                                validator: (value) {
                                                  if (value!.isEmpty) return 'Enter your 4 digit PIN!';
                                                  else if(_newPin != _confirmPin) return 'Re-confirm your PIN';
                                                  return null;
                                                },
                                                pinTheme: PinTheme(
                                                  shape: PinCodeFieldShape.box,
                                                  borderWidth: 1,
                                                  fieldHeight: 60,
                                                  fieldWidth: 60,
                                                  activeColor: Color(0xFF7BBBE5),
                                                  selectedColor: Color(0xFF7BBBE5),
                                                  borderRadius: BorderRadius.all(Radius.circular(3))),
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
                                    if(_newPin.length == 4 && _confirmPin.length == 4){
                                      if(_newPin == _confirmPin) _resetUserPin(setDialogState);
                                    }
                                    else{
                                      Functions.showErrorMessage('Enter a valid 4 digit Pin!');
                                    }
                                  }
                                }
                              },
                              buttonColor: Color(0xFF00509A),
                              child: Center(
                                child: _showSpinner ?
                                CircleProgressIndicator() :
                                const  Text(
                                  'Save Changes',
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
                            SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
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

  /// Function to call api [RESET_PIN]
  void _resetUserPin(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    await api.resetStaffPin(widget.userId).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'RESET PIN',
          'Staff Pin Reset Successfully',
          'Staff pin has been reset successfully. Go back to review other staffs',
          Color(0xFF00CFA0),
        );
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }

  Future<void> _block() {

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
                              'BLOCK STAFF',
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
                                'Are you sure you want to block this Staff?',
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
                                'This will mean that this staff will temporary not be allowed to make/conduct business decisions or activities',
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
                                                      borderRadius: BorderRadius.all(Radius.circular(3))),
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
                                      _blockUser(setDialogState); //if(_confirmPin == _adminPin)
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
                                child: _showSpinner ?
                                  CircleProgressIndicator() :
                                  const Text(
                                  'Yes, block',
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

  /// Function to call api [BLOCK_USER]
  void _blockUser(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    await api.blockStaff(widget.userId).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'BLOCK STAFF',
          'Staff blocked Successfully',
          'Staff has been blocked successfully. Go back to review other staffs',
          Color(0xFF00CFA0),
        );
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }

  Future<void> _activate() {

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
                              'ACTIVATE STAFF',
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
                                'Are you sure you want to activate this Staff?',
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
                                'This means that this staff will be allowed to make/conduct business decisions or activities',
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
                                                      borderRadius: BorderRadius.all(Radius.circular(3))),
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
                                      _activateUser(setDialogState); //if(_confirmPin == _adminPin)
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
                                child: _showSpinner ?
                                  CircleProgressIndicator() :
                                  const Text(
                                  'Yes, activate',
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

  /// Function to call api [ACTIVATE_USER]
  void _activateUser(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    await api.activateStaff(widget.userId).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'ACTIVATE STAFF',
          'Staff activated Successfully',
          'Staff has been activated successfully. Go back to review other staffs',
          Color(0xFF00CFA0),
        );
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }

  Future<void> _deletePermanently() {

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
                              'DELETE',
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
                                'Are you sure you want to delete this Staff?',
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
                                'This will mean that this staff is no longer part of your organization and the staff\'s detail wont be found under the staffs',
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
                                      _deleteUserPermanently(setDialogState); // if(_confirmPin == _adminPin)
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

  /// Function to call api [DELETE_USER]
  void _deleteUserPermanently(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    await api.deleteStaff(widget.userId).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        _popUpMessage(
          'DELETE STAFF',
          'Staff Deleted Successfully',
          'Staff has been deleted successfully. Go back to review other staffs',
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

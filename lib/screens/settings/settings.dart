import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Settings extends StatefulWidget {

  static const String id = 'settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of account form widget for form validation
  final _accountFormKey = GlobalKey<FormState>();

  /// A [GlobalKey] to hold the form state of security form widget for form validation
  final _securityFormKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the name
  TextEditingController _nameController = TextEditingController();

  /// A [TextEditingController] to control the input text for the phone number
  TextEditingController _phoneController = TextEditingController();

  String _currentPin = '';

  String _newPin = '';

  String _confirmPin = '';

  bool _showSpinner = false;

  bool _showCurrentPin = true;

  bool _showNewPin = true;

  bool _showConfirmPin = true;

  /// This is a variable that holds the user model
  User? _user;

  /// Function to fetch the user's details and set their name and phone number
  /// to [_nameController] and [_phoneController]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((User value) async {
      setState(() {
        _nameController.text = value.name!;
        _phoneController.text = value.phone!;
      });
    }).catchError((e) => print(e));
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: AbsorbPointer(
        absorbing: _showSpinner,
        child: LayoutBuilder(
          builder: (context, constraints) => (Scaffold(
            appBar: buildAppBar(constraints, 'SETTINGS'),
            drawer: RefactoredDrawer(title: 'SETTINGS'),
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 194,
                      child: TabBar(
                        labelStyle: kTabBarTextStyle,
                        labelColor: Color(0xFF004E92),
                        unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                        indicatorColor: Color(0xFF004E92),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                            child: Text(
                              'Account',
                              style: kTabBarTextStyle,
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Security',
                              style: kTabBarTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _accountSection(constraints),
                          _securitySection(constraints),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  /// View for account details
  Widget _accountSection(BoxConstraints constraints){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: kTableContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/settingsgroup.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 56),
            _buildAccountForm(constraints),
            SizedBox(height: 40),
            Button(
              onTap: (){
                if(!_showSpinner){
                  if(_accountFormKey.currentState!.validate())_editUser();
                }
              },
              buttonColor: Color(0xFF00509A),
              child: Center(
                child: _showSpinner ?
                CircleProgressIndicator() :
                const Text(
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
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// Form widget for account details
  Widget _buildAccountForm(BoxConstraints constraints){
    return Form(
      key: _accountFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name'),
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
                  controller: _nameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter your name';
                    return null;
                  },
                  decoration: kTextFieldBorderDecoration.copyWith(
                    hintText: 'Enter name',
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
          // Phone Number
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone Number'),
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
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  maxLength: 11,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter  phone number';
                    return null;
                  },
                  decoration: kTextFieldBorderDecoration.copyWith(
                    hintText: 'Enter phone number',
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
        ]
      ),
    );
  }

  ///function to make api call to [EDIT_USER]
  void _editUser() async{
    if(!mounted)return;
    setState(() => _showSpinner = true);
    var api = UserDataSource();
    Map<String, String> body = {
      "name": _nameController.text,
      "phone": _phoneController.text,
    };
    await api.editUser(body).then((message) async{
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      Functions.showSuccessMessage('Successfully updated user details');
      await futureValue.updateUser();
    }).catchError((e){
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }


  /// View for security section
  Widget _securitySection(BoxConstraints constraints){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: kTableContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityForm(),
            SizedBox(height: 40),
            Center(
              child: Button(
                onTap: (){
                  if(!_showSpinner){
                    if(_securityFormKey.currentState!.validate()){
                      if(_currentPin.length == 4 && _newPin.length == 4){
                        if(_currentPin != _newPin) _changeUserPin();
                        else print("You cannot use this pin because it is your current PIN");
                      }
                    }
                  }
                },
                buttonColor: Color(0xFF00509A),
                child:  _showSpinner ?
                SizedBox(
                  height: 17,
                  width: 17,
                    child: CircleProgressIndicator(),
                ) :
                const Center(
                  child: Text(
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
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// Form Widget for security details
  Widget _buildSecurityForm() {
    return Form(
      key: _securityFormKey,
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current PIN',
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
                    obscuringCharacter: '*',
                    obscureText: _showCurrentPin,
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
                      borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    onChanged: (value) {
                      if(!mounted)return;
                      setState(() => _currentPin = value);
                    }
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      if(_showCurrentPin == true) _showCurrentPin = false;
                    });
                  },
                  child: Text(
                    'Show',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
                    obscuringCharacter: '*',
                    obscureText: _showNewPin,
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
                      borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    onChanged: (value) {
                      if(!mounted)return;
                      setState(() => _newPin = value);
                    }
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      if(_showNewPin == true) _showNewPin = false;
                    });
                  },
                  child: Text(
                    'Show',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
                    obscuringCharacter: '*',
                    obscureText: _showConfirmPin,
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
                      borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    onChanged: (value) {
                      if(!mounted)return;
                      setState(() => _confirmPin = value);
                    }
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      if(_showConfirmPin == true) _showConfirmPin = false;
                    });
                  },
                  child: Text(
                    'Show',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Function to  make api call to [CHANGE_PIN]
  void _changeUserPin() async{
    if(!mounted)return;
    setState(() => _showSpinner = true);
    var api = UserDataSource();
    Map<String, String> body = {
      "currentPin": _currentPin,
      "newPin": _newPin,
    };
    await api.changePin(body).then((message) async{
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      Functions.showSuccessMessage('Successfully updated user\'s pin');
    }).catchError((e){
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }

}

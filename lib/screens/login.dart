import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/database/user-db-helper.dart';
import 'package:fumzy/model/user.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/dashboard.dart';

class Login extends StatefulWidget {

  static const String id = 'login';
  
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();

  String _pin = '';

  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: AbsorbPointer(
        absorbing: _showSpinner,
        child: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.17,
                      bottom: constraints.maxHeight * 0.0683
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: 0.8,
                        child: Container(
                          width: 70.7,
                          height: 70.7,
                          color: Color(0xFF00509A),
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.8,
                              child: Text(
                                'FGV',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FUMZZY',
                            style: TextStyle(
                                color: Color(0xFF023C72),
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Global Ventures',
                            style: TextStyle(
                                color: Color(0xFF023C72),
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  'Welcome back, Admin',
                  style: TextStyle(
                    color: Color(0xFF004E92),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Please enter your pin to login',
                  style: TextStyle(
                    color: Color(0xFF000428).withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 55),
                _buildForm(constraints),
                SizedBox(height: 50),
                Button(
                  onTap: (){
                    if(!_showSpinner){
                      if(_formKey.currentState!.validate()){
                        if(_pin.length == 4) _signIn();
                        else print('Enter a 4 digit valid pin');
                      }
                    }
                  },
                  buttonColor: Color(0xFF00509A),
                  child: Center(
                    child: _showSpinner
                        ? CircleProgressIndicator()
                        : Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildForm(BoxConstraints constraints){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 280,
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
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
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
          SizedBox(height: 24),
          // PIN
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter PIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 280,
                child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    textInputAction: TextInputAction.done,
                    animationType: AnimationType.fade,
                    enablePinAutofill: false,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF004E92),
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter your pin';
                      if (_pin.length != 4) return 'Enter a valid 4 digit pin';
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
                      setState(() => _pin = value);
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    if(!mounted)return;
    setState(()=> _showSpinner = true);
    var api = UserDataSource();
    Map<String, String> body = {
      "name": _nameController.text,
      "pin": _pin
    };
    await api.signIn(body).then((User user) async {
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      var db = DatabaseHelper();
      await db.initDb();
      await db.saveUser(user);
      _addBoolToSP(user);
    }).catchError((e){
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      print(e);
    });
  }

  /// This function adds a true boolean value to show user is logged in and also
  /// saves token as reference from the [user] model using [SharedPreferences]
  /// It moves to the [Dashboard] after saving those details
  _addBoolToSP(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
    Navigator.pushReplacementNamed(context, Dashboard.id);
  }
  
}

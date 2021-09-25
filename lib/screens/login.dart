import 'package:flutter/material.dart';
import 'package:fumzy/components/button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dashboard/dashboard.dart';

class Login extends StatefulWidget {

  static const String id = 'login';
  
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _pin = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
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
              Container(
                child: Column(
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
                            borderRadius: BorderRadius.all(Radius.circular(3))
                          ),
                          onChanged: (value) {
                            if(!mounted)return;
                            setState(() {
                              _pin = value;
                            });
                          }
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
              Button(
                onTap: (){
                  Navigator.pushNamed(context, Dashboard.id);
                },
                buttonColor: Color(0xFF00509A),
                child: Center(
                  child: Text(
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
    );
  }
  
}

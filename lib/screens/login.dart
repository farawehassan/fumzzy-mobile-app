import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dashboard/dashboard.dart';

class Login extends StatefulWidget {

  static const String id = 'login';
  
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: constraints.maxHeight * 0.17, bottom: constraints.maxHeight * 0.0683),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 0.8,
                  child: Container(
                    width: constraints.maxWidth * 0.17,//TODO: change the constaints here.
                    height: constraints.maxHeight * 0.08,
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
                Container(
                  margin: EdgeInsets.only(left: constraints.maxWidth * 0.076,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FUMZZY',
                        style: TextStyle(
                            color: Color(0xFF023C72),
                            fontSize: 21,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'Global Ventures',
                        style: TextStyle(
                            color: Color(0xFF023C72),
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),//fgv logo
          Padding(
            padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.016),
            child: Text(
              'Welcome back, Admin',
              style: TextStyle(
                color: Color(0xFF004E92),
                fontSize: 29,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.055),
            child: Text(
              'Please enter your pin to login',
              style: TextStyle(
                color: Color(0xFF000428).withOpacity(0.5,),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.075,),
            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.07),
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
                Container(
                  margin: EdgeInsets.only(top: constraints.maxHeight * 0.02, bottom: constraints.maxHeight * 0.02),
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
                        fieldHeight: constraints.maxHeight * .075,
                        fieldWidth: constraints.maxWidth * 0.139,
                        activeColor: Color(0xFF000428).withOpacity(0.7,),
                        selectedColor: Colors.blue,
                      ),
                      onChanged: (value) {
                        print("value");
                      }
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("show pin");
                  },
                  child: Center(
                    child: Text(
                      'Show PIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF000428).withOpacity(0.5,),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Dashboard.id);
            },
            child: Container(
              height: constraints.maxHeight * 0.063,
              width: constraints.maxWidth * 0.476,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Color(0xFF00509A),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
  
}

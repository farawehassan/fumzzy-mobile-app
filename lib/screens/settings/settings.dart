import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fumzy/dashboard/drawer.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          drawer: RefactoredDrawer(),
          body: LayoutBuilder(builder: (context, constraints) => ListView(
            children: [
              Container(
                child: Container(
                  padding: EdgeInsets.only(top: constraints.maxHeight*0.07, left: constraints.maxWidth*0.050,),
                  color: Color(0xFFF7F8F9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: constraints.maxWidth*0.016),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Account',
                                  style: TextStyle(
                                    color: Color(0xFF004E92),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),//account and security name
                                Container(
                                  margin: EdgeInsets.only(top: constraints.maxHeight*0.04, bottom: constraints.maxHeight*0.025),
                                  color: Color(0xFF004E92),
                                  height: 3,
                                  width: 79,
                                ),//blue divider
                              ],
                            ),
                          ),//account with the blue indicator
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Security',
                                style: TextStyle(
                                  color: Color(0xFF004E92).withOpacity(0.6),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),//account name
                              Container(
                                margin: EdgeInsets.only(top: constraints.maxHeight*0.04, bottom: constraints.maxHeight*0.025),
                                color: Colors.transparent,
                                height: 3,
                                width: 78,
                              ),//blue divider
                            ],
                          ),//security with the transparent container indicator
                        ],
                      ),//account and security
                      Container(
                        margin: EdgeInsets.only(top: constraints.maxHeight*0.028),
                        width: constraints.maxWidth*0.69,
                        height: constraints.maxHeight*1.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFE2E2EA),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: constraints.maxHeight*0.07, bottom: constraints.maxHeight*0.1),
                              width: 70,
                              height: 70,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/settingsgroup.png',),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),//circle avater for profile picture
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: constraints.maxHeight*0.05,right: constraints.maxHeight*0.14, bottom: constraints.maxHeight*0.14),
                                  child: ReuseableTextField(
                                    fieldName: 'First Name',
                                    inputName: 'Victor',
                                    margin: constraints.maxHeight*0.023,
                                    height: constraints.maxHeight*0.163,
                                    width: constraints.maxWidth*0.25,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: constraints.maxHeight*0.14),
                                  child: ReuseableTextField(
                                    fieldName: 'Last Name',
                                    inputName: 'Daudu',
                                    margin: constraints.maxHeight*0.023,
                                    height: constraints.maxHeight*0.163,
                                    width: constraints.maxWidth*0.25,
                                  ),
                                ),
                              ],
                            ),//first row field selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: constraints.maxHeight*0.05,right: constraints.maxHeight*0.14, bottom: constraints.maxHeight*0.14),
                                  child: ReuseableTextField(
                                    fieldName: 'Email Adress',
                                    inputName: 'Daudu.victor173@gmail.com',
                                    margin: constraints.maxHeight*0.023,
                                    height: constraints.maxHeight*0.163,
                                    width: constraints.maxWidth*0.25,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: constraints.maxHeight*0.023),
                                      child: Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: constraints.maxHeight*0.14),
                                      height: constraints.maxHeight*0.163,
                                      width: constraints.maxWidth*0.25,
                                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 16.0,),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 1,
                                          color: Color(0xFF7BBBE5),
                                        ),
                                      ),
                                      child: Text(
                                        '+234    8082734235',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),//phone number and country flag
                              ],
                            ),//second row field selector
                            GestureDetector(
                              onTap: () {
                                print("save changes");
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                height: constraints.maxHeight*0.163,
                                width: constraints.maxWidth*0.176,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Color(0xFF00509A),
                                ),
                                child: Center(
                                  child: Text(
                                    'Save changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),//save changes
                          ],
                        ),
                      ),//settings details
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class ReuseableTextField extends StatelessWidget {
  ReuseableTextField({required this.margin, required this.height, required this.width, required this.fieldName, required this.inputName});
  final double margin;
  final double height;
  final double width;
  final String fieldName;
  final String inputName;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: margin),
          child: Text(
            fieldName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 16.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Color(0xFF7BBBE5),
            ),
          ),
          child: Text(
            inputName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

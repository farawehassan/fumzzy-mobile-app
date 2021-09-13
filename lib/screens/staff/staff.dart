import 'package:flutter/material.dart';
import 'package:fumzy/dashboard/drawer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
class Staff extends StatefulWidget {

  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
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
                  padding: EdgeInsets.only(top: constraints.maxHeight*0.07, left: constraints.maxWidth*0.026, right: constraints.maxWidth*0.026,),
                  color: Color(0xFFF7F8F9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: constraints.maxHeight*0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Staffs',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Color(0xFF000428).withOpacity(0.58),
                                  builder: (context) => Center(
                                    child: Container(
                                      //margin: EdgeInsets.symmetric(vertical: 70.0),
                                      height: constraints.maxHeight,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: constraints.maxHeight*0.042),
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            width: constraints.maxWidth,
                                            height: constraints.maxWidth*0.18,
                                            color: Color(0xFFF5F8FF),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'NEW STAFF',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context)
                                                  },
                                                  child: Icon(
                                                    IconlyBold.closeSquare,
                                                    color: Colors.black.withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),//newstaff header with cancel icon
                                          Padding(
                                            padding:  EdgeInsets.only(bottom: constraints.maxHeight*0.025),
                                            child: Text(
                                              'Add New Staff',
                                              style: TextStyle(
                                                color: Color(0xFF00509A),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15.0),
                                            child: Text(
                                              'To add a new staff enter a username and set a solid 4-digit pin for the new staff.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF000428).withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            //margin: EdgeInsets.only(bottom: constraints.maxHeight*0.0,),
                                            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.07),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PIN',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: constraints.maxHeight*0.02, bottom: constraints.maxHeight*0.02),
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
                                                          fieldHeight: constraints.maxHeight*.075,
                                                          fieldWidth: constraints.maxWidth*0.139,
                                                          activeColor: Color(0xFF000428).withOpacity(0.7,),
                                                          selectedColor: Colors.blue,
                                                        ),
                                                        onChanged: (value) {
                                                          print("value");
                                                        }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: constraints.maxHeight*0.075,),
                                            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.07),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Confirm PIN',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: constraints.maxHeight*0.02, bottom: constraints.maxHeight*0.02),
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
                                                          fieldHeight: constraints.maxHeight*.075,
                                                          fieldWidth: constraints.maxWidth*0.139,
                                                          activeColor: Color(0xFF000428).withOpacity(0.7,),
                                                          selectedColor: Colors.blue,
                                                        ),
                                                        onChanged: (value) {
                                                          print("value");
                                                        }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: constraints.maxHeight*0.063,
                                            width: constraints.maxWidth*0.476,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6.0),
                                              color: Color(0xFF00509A),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Add Staff',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                height: constraints.maxHeight*0.163,
                                width: constraints.maxWidth*0.156,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Color(0xFF00509A),
                                ),
                                child: Center(
                                  child: Text(
                                    'Add Staff',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),//all staff, add staff button
                      Container(
                        margin: EdgeInsets.only(bottom: constraints.maxHeight*0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: constraints.maxHeight*0.155,
                              width: constraints.maxWidth*0.34,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(27.5),
                              ),
                              child: TextField(
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    IconlyLight.search,
                                    color: Colors.black,
                                    size: 17,
                                  ),
                                  hintText: 'Search',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0,
                                    color: Colors.black
                                ),
                              ),
                            ),//search
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("export table");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                    padding: EdgeInsets.all(15),
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.file_download_outlined,
                                          color: Color(0xFF75759E),
                                          size: 17,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            'Export table',
                                            style: TextStyle(
                                              color: Color(0xFF75759E),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("filter");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                    padding: EdgeInsets.all(15),
                                    height: constraints.maxHeight*0.163,
                                    width: constraints.maxWidth*0.131,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFFE2E2EA),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Filter',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Icon(
                                          Icons.tune,
                                          color: Colors.black,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),//filter
                              ],
                            ),
                          ],
                        ),
                      ),//search, export and filter
                      Container(
                        margin: EdgeInsets.only(top: constraints.maxHeight*0.028),
                        width: constraints.maxWidth*0.75,
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

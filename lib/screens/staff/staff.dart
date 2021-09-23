import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fumzy/screens/ReuseableWidgets.dart';

class Staff extends StatefulWidget {
  static const String id = 'staff';

  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {

  final Color activeStatusColor = Color(0xFF00AF27);
  final Color blockedStatusColor = Color(0xFF4B545A);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'Staffs'),
        drawer: RefactoredDrawer(),
        body: ListView(children: [
          Container(
            child: Container(
              padding: EdgeInsets.only(
                  top: constraints.maxHeight * 0.07,
                  left: constraints.maxWidth * 0.026,
                  right: constraints.maxWidth * 0.026),
              color: Color(0xFFF7F8F9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //all staff, add staff button
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
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
                            _addStaffDialog(constraints);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: constraints.maxHeight * 0.044),
                            height: constraints.maxHeight * 0.133,
                            width: constraints.maxWidth * 0.156,
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
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.125,
                          width: constraints.maxWidth * 0.34,
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
                                color: Colors.black),
                          ),
                        ), //search
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("export table");
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
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
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
                                padding: EdgeInsets.all(15),
                                height: constraints.maxHeight * 0.133,
                                width: constraints.maxWidth * 0.131,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFFE2E2EA),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            ), //filter
                          ],
                        ),
                      ],
                    ),
                  ),
                  //search, export and filter
                  Container(
                      margin:
                          EdgeInsets.only(top: constraints.maxHeight * 0.028),
                      width: constraints.maxWidth * 0.79,
                      height: constraints.maxHeight * 1.8,
                      decoration: kTableContainer,
                      child: StaffTableContents(
                          activeStatusColor: activeStatusColor,
                          blockedStatusColor: blockedStatusColor)),
                  //staff details
                ],
              ),
            ),
          )
        ]),
      )),
    );
  }

  Future<void> _addStaffDialog(BoxConstraints constraints) {
    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFFFFF),
        ),
        margin: EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //newstaff header with cancel icon
              Container(
                padding: EdgeInsets.fromLTRB(34, 30, 34, 27),
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
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
              Padding(
                padding: EdgeInsets.only(top: 42),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
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
              //username
              Container(
                margin: EdgeInsets.only(
                  top: constraints.maxHeight * 0.019,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
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
                        margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.02,
                            bottom: constraints.maxHeight * 0.02),
                        height: constraints.maxHeight * 0.07,
                        width: constraints.maxWidth,
                        padding: EdgeInsets.only(
                            top: 14.0, bottom: 10.0, left: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF7BBBE5),
                          ),
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Enter staff username',
                            hintStyle: TextStyle(
                              color: Color(0xFF818181),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 17.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //enter pin
              Container(
                //margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.0,),
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.07),
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
                        margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.02,
                            bottom: constraints.maxHeight * 0.02),
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
                              activeColor: Color(0xFF000428).withOpacity(
                                0.7,
                              ),
                              selectedColor: Colors.blue,
                            ),
                            onChanged: (value) {
                              print("value");
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              //re-enter pin
              Container(
                margin: EdgeInsets.only(
                  bottom: constraints.maxHeight * 0.035,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.07),
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
                        margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.02,
                            bottom: constraints.maxHeight * 0.02),
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
                              activeColor: Color(0xFF000428).withOpacity(
                                0.7,
                              ),
                              selectedColor: Colors.blue,
                            ),
                            onChanged: (value) {
                              print("value");
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("re-add staff");
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: constraints.maxHeight * 0.045),
                  height: constraints.maxHeight * 0.063,
                  width: constraints.maxWidth * 0.476,
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
              ),
              GestureDetector(
                onTap: () {
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
              ), //No, cancel
              //add staff
            ],
          ),
        ),
      ),
    );
  }
}

class StaffTableContents extends StatelessWidget {
  StaffTableContents({
    required this.activeStatusColor,
    required this.blockedStatusColor,
  });

  final Color activeStatusColor;
  final Color blockedStatusColor;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: TextStyle(
        color: Color(0xFF75759E),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      dataTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 13,
        //fontWeight: FontWeight.w400,
      ),
      columnSpacing: 3.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text(' Username')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Date Created')),
        DataColumn(label: Text('Actions')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Jermey')),
          DataCell(Text('Active', style: TextStyle(color: activeStatusColor))),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(ReusablePopMenu()),
        ]),
        DataRow(cells: [
          DataCell(Text('Bisolapere')),
          DataCell(
              Text('Blocked', style: TextStyle(color: blockedStatusColor))),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(ReusablePopMenu()),
        ]),
        DataRow(cells: [
          DataCell(Text('ObiCubana')),
          DataCell(Text('Active', style: TextStyle(color: activeStatusColor))),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(ReusablePopMenu()),
        ]),
        DataRow(cells: [
          DataCell(Text('Paulo')),
          DataCell(Text('Active', style: TextStyle(color: activeStatusColor))),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(ReusablePopMenu()),
        ]),
        DataRow(cells: [
          DataCell(Text('Korede')),
          DataCell(
              Text('Blocked', style: TextStyle(color: blockedStatusColor))),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(ReusablePopMenu()),
        ]),
      ],
    );
  }
}//the table contents of the staff

class ReusablePopMenu extends StatelessWidget {
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
              print('Reset Pin');
            }
            break;
          case 1:
            {
              print('Block');
            }
            break;
          case 2:
            {
              print('delete permanently');
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
                  'Reset Pin',
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
}

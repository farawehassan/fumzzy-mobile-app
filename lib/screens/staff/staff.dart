import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'pop-up.dart';

class Staff extends StatefulWidget {

  static const String id = 'staff';

  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'STAFFS'),
        drawer: RefactoredDrawer(title: 'STAFFS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Staffs',
                    style: TextStyle(
                      color: Color(0xFF171725),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  Button(
                    onTap: () {
                      _addStaffDialog(constraints);
                    },
                    buttonColor: Color(0xFF00509A),
                    width: 160,
                    child: Center(
                      child: Text(
                        'Add Staff',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              margin: EdgeInsets.only(right: 50),
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
                            InkWell(
                              onTap: () {
                                print("filter");
                              },
                              child: Container(
                                width: 110,
                                height: 50,
                                padding: EdgeInsets.all(15),
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
                                        color: Color(0xFF171725),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 35),
                      Container(
                          width: constraints.maxWidth,
                          decoration: kTableContainer,
                          child: StaffTableContents()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  /// Widget to show the dialog to add staff
  Future<void> _addStaffDialog(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    String newPin = '';
    String confirmPin = '';
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
                        'Add New Staff',
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
                        'To add a new staff enter a username and set a solid 4-digit pin for the new staff.',
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
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
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
                                      controller: nameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[a-zA-Z]')),
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter your name';
                                        }
                                        return null;
                                      },
                                      decoration:
                                          kTextFieldBorderDecoration.copyWith(
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
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
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
                                      controller: phoneController,
                                      maxLength: 11,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]')),
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter your name';
                                        }
                                        return null;
                                      },
                                      decoration:
                                          kTextFieldBorderDecoration.copyWith(
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
                                          pinTheme: PinTheme(
                                              shape: PinCodeFieldShape.box,
                                              borderWidth: 1,
                                              fieldHeight: 60,
                                              fieldWidth: 60,
                                              activeColor: Color(0xFF7BBBE5),
                                              selectedColor: Color(0xFF7BBBE5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          onChanged: (value) {
                                            if (!mounted) return;
                                            setState(() {
                                              newPin = value;
                                            });
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
                                          pinTheme: PinTheme(
                                              shape: PinCodeFieldShape.box,
                                              borderWidth: 1,
                                              fieldHeight: 60,
                                              fieldWidth: 60,
                                              activeColor: Color(0xFF7BBBE5),
                                              selectedColor: Color(0xFF7BBBE5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          onChanged: (value) {
                                            if (!mounted) return;
                                            setState(() {
                                              confirmPin = value;
                                            });
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
                        print("re-add staff");
                      },
                      buttonColor: Color(0xFF00509A),
                      child: Center(
                        child: Text(
                          'Add Staff',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
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
                    SizedBox(height: 50),
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

class StaffTableContents extends StatelessWidget {

  final Color activeStatusColor = Color(0xFF00AF27);

  final Color blockedStatusColor = Color(0xFF4B545A);

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
      columnSpacing: 3.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Actions')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Jeremy')),
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

}


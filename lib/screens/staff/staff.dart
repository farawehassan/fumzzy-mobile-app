import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/model/staffs.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:fumzy/utils/size-config.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:shimmer/shimmer.dart';
import 'pop-up.dart';

class Staff extends StatefulWidget {

  static const String id = 'staff';

  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  TextEditingController _search = TextEditingController();

  TextEditingController _nameController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  String _newPin = '';

  String? _confirmPin = '';

  final _formKey = GlobalKey<FormState>();

  bool _showSpinner = false;

  Map<String, Color> _statusColor = {
    'Active Status Color' : Color(0xFF00AF27),
    'Blocked Status Color' : Color(0xFF4B545A)
  };

  /// A list to hold staff
  List<Staffs> _staff = [];

  /// A list to hold filtered staff
  List<Staffs> _filteredStaff = [];

  ///A variable to hold length of filtered staff
  int? _staffLength;

  ///A function to get all staffs
  void _getAllStaff({bool? refresh}) async{
    Future<List<Staffs>> staffs = futureValue.getAllStaff(refresh: refresh);
    await staffs.then((value){
      if(!mounted)return;
      setState((){
        _staff.addAll(value);
        _filteredStaff = _staff;
        _staffLength = _filteredStaff.length;
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
      if(!mounted)return;
    });
  }

  ///A widget to build staff table
  Widget _buildAllStaffList() {
    List<DataRow> itemRow = [];
    if(_filteredStaff.length > 0 && _filteredStaff.isNotEmpty){
      for(int i = 0; i < _filteredStaff.length; i++){
        Staffs staff = _filteredStaff[i];
        String status = '';
        staff.status! == 'active'
            ? status = 'Active Status Color'
            : status = 'Blocked Status Color';
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(staff.name!)),
            DataCell(Text(staff.status!,style: TextStyle(color: _statusColor[status]))),
            DataCell(Text(Functions.getFormattedDateTime(staff.createdAt!))),
            DataCell(ReusablePopMenu(userId: staff.id!,)),
          ]),
        );
      }
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
        rows: itemRow,
      );
    }
    else if(_staffLength == 0) return Container();
    return _shimmerLoader();
  }

  Widget _shimmerLoader(){
    List<Widget> containers = [];
    for(int i = 0; i < 20; i++){
      containers.add(
          Container(
              width: SizeConfig.screenWidth,
              height: 40,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Color(0xFFF6F6F6)
              )
          )
      );
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(children: containers)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAllStaff(refresh: true);
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: LayoutBuilder(
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
                        _addStaffDialog(constraints,CircleProgressIndicator());
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
                                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                                margin: EdgeInsets.only(right: 50),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(27.5),
                                ),
                                child: TextField(
                                  textAlign: TextAlign.start,
                                  textInputAction: TextInputAction.search,
                                  controller: _search,
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
                            child: _buildAllStaffList()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  /// Widget to show the dialog to add staff
  Future<void> _addStaffDialog(BoxConstraints constraints, Widget circleProgressIndicator) {
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
                                'Add New Staff',
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
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                                FilteringTextInputFormatter.allow(
                                                    RegExp('[a-zA-Z]')),
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter your name';
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
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.number,
                                              controller: _phoneController,
                                              maxLength: 11,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp('[0-9]')),
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter phone number';
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
                                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) return 'Enter your 4 digit PIN!';
                                                    return null;
                                                  },
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
                                                  else if(_newPin != _confirmPin) return 'Re-confirm your PIN';
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
                                    if(_newPin.length == 4 && _confirmPin!.length == 4){
                                      if(_newPin == _confirmPin) _addStaff(setDialogState);
                                    }
                                  }
                                }
                              },
                              buttonColor: Color(0xFF00509A),
                              child: Center(
                                child: _showSpinner ?
                                circleProgressIndicator :
                                const Text(
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

  /// Function to call api for [ADD_USER]
  void _addStaff(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    Map<String, String> body = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "type": "staff",
      "pin": _newPin
    };
    await api.signUP(body).then((message)async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }

}



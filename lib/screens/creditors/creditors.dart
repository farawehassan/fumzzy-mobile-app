import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/networking/creditor-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

import 'creditors-detail/creditor-detail.dart';

class Creditors extends StatefulWidget {

  static const String id = 'creditors';

  @override
  _CreditorsState createState() => _CreditorsState();
}

class _CreditorsState extends State<Creditors> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshCreditorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshDebtorKey = GlobalKey<RefreshIndicatorState>();

  bool _showSpinner = false;

  TextEditingController search = TextEditingController();

  /// A List to hold the all the creditors
  List<Creditor> _creditors = [];

  /// A List to hold all the filtered creditors
  List<Creditor> _filteredCreditors = [];

  /// An Integer variable to hold the length of [_creditors]
  int? _creditorsLength;

  int? _totalCreditorCount;

  int _creditorPageSize = 1;

  bool _showCreditorSpinner = false;

  void _getAllCreditors({bool? refresh}) async {
    Future<Map<String, dynamic>> customers = futureValue.getAllCreditorsPaginated(
        refresh: refresh, page: _creditorPageSize, limit: 50
    );
    await customers.then((value) {
      if(!mounted)return;
      setState(() {
        _creditors.addAll(value['items']);
        _filteredCreditors = _creditors;
        _creditorsLength = _filteredCreditors.length;
        _totalCreditorCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future _loadMoreCreditors() async {
    setState(() { _creditorPageSize += 1; });
    Future<Map<String, dynamic>> purchases = futureValue.getAllCreditorsPaginated(page: _creditorPageSize, limit: 50);
    await purchases.then((value) {
      if (!mounted) return;
      setState(() {
        _creditors.addAll(value['items']);
        _filteredCreditors = _creditors;
        _creditorsLength = _creditors.length;
        _totalCreditorCount = value['totalCount'];
        _showCreditorSpinner = false;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the creditors
  Widget _buildCreditorList() {
    List<DataRow> itemRow = [];
    if(_filteredCreditors.length > 0 && _filteredCreditors.isNotEmpty){
      for (int i = 0; i < _filteredCreditors.length; i++){
        Creditor creditor = _filteredCreditors[i];
        double totalSales = 0;
        creditor.reports!.forEach((element) {
          totalSales += element.amount!;
        });
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(creditor.name!)),
            DataCell(Text(Functions.money(totalSales, 'N'))),
            DataCell(Text(creditor.reports!.length.toString())),
            DataCell(Text(Functions.getFormattedShortDate(creditor.createdAt!))),
            DataCell(TableArrowButton()),
          ],
          onSelectChanged: (value){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreditorsDetail(
                  creditor: creditor,
                ),
              ),
            ).then((value) => _refreshCreditors());
          }),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_showCreditorSpinner && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if(_totalCreditorCount! > (_creditorPageSize * 50)){
              setState(() { _showCreditorSpinner = true; });
              _loadMoreCreditors();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshCreditors,
          key: _refreshCreditorKey,
          color: Color(0xFF004E92),
          child: Container(
            decoration: kTableContainer,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: DataTable(
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
                        columnSpacing: 15.0,
                        dataRowHeight: 65.0,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Total Amount')),
                          DataColumn(label: Text('Volume')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('')),
                        ],
                        rows: itemRow,
                      )
                  ),
                  const SizedBox(height: 80),
                  _showCreditorSpinner
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A459F)),
                      ),
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else if(_creditorsLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of creditors from page 1 similar to [_getAllCreditors()]
  Future<Null> _refreshCreditors() {
    Future<Map<String, dynamic>> customers = futureValue.getAllCreditorsPaginated(page: 1, limit: 50);
    return customers.then((value) {
      _creditorsLength = null;
      _creditors.clear();
      _filteredCreditors.clear();
      _totalCreditorCount = null;
      if(!mounted)return;
      setState(() {
        _creditors.addAll(value['items']);
        _filteredCreditors = _creditors;
        _creditorsLength = _creditors.length;
        _totalCreditorCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllCreditors();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'CREDITORS'),
        drawer: RefactoredDrawer(title: 'CREDITORS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Creditors',
                    style: TextStyle(
                      color: Color(0xFF171725),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  Button(
                    onTap: (){
                      _addNewCreditor(constraints);
                    },
                    buttonColor: Color(0xFF00509A),
                    width: 160,
                    child: Center(
                      child: Text(
                        'Add New Creditor',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(height: 37),
                      _buildCreditorList()
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

  Future<void> _addNewCreditor(BoxConstraints constraints) {

    final formKey = GlobalKey<FormState>();
    TextEditingController creditorController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
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
                                'NEW CREDITOR',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
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
                        ), //new category header with cancel icon
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 42),
                                  child: Text(
                                    'Add New Creditor',
                                    style: TextStyle(
                                      color: Color(0xFF00509A),
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
                                  child: Text(
                                    'You have made additional purchase on credit. Please fill the fields to record your credit purchase.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF000428).withOpacity(0.6),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// Creditor Name
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Creditor Name'),
                                            SizedBox(height: 10),
                                            Container(
                                              width: constraints.maxWidth,
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                keyboardType: TextInputType.text,
                                                controller: creditorController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter creditor name';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: 'Enter creditor name',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  contentPadding: EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        /// Amount
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Amount'),
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
                                                controller: amountController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter amount';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: 'Enter amount',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  contentPadding: EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        /// Description
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Description'),
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
                                                controller: referenceController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter description';
                                                  }
                                                  return null;
                                                },
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: 'Enter description',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  contentPadding: EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Button(
                                  onTap: (){
                                    if(formKey.currentState!.validate()){
                                      Map<String, dynamic> body = {
                                        "name": creditorController.text,
                                        "amount": amountController.text,
                                        "paymentMade": 0,
                                        "description": referenceController.text
                                      };
                                      _addCreditor(body, setDialogState);
                                    }
                                  },
                                  buttonColor: Color(0xFF00509A),
                                  child: Center(
                                    child: _showSpinner
                                        ? CircleProgressIndicator()
                                        : Text(
                                      'Record Creditor',
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
        ),
      ),
    );
  }

  /// function to make api call to [addNewCreditor] with the help of
  /// [CreditorDataSource]
  Future<void> _addCreditor(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CreditorDataSource();
    await api.addNewCreditor(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      _refreshCreditors();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}

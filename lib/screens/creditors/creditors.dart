import 'package:flutter/material.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

class Creditors extends StatefulWidget {

  static const String id = 'creditors';

  @override
  _CreditorsState createState() => _CreditorsState();
}

class _CreditorsState extends State<Creditors> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshCustomerKey = GlobalKey<RefreshIndicatorState>();
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
    Future<Map<String, dynamic>> customers = futureValue.getAllCustomersPaginated(
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
    Future<Map<String, dynamic>> purchases = futureValue.getAllCustomersPaginated(page: _creditorPageSize, limit: 50);
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
            DataCell(Text('-')),
            DataCell(TableArrowButton()),
          ],
          onSelectChanged: (value){

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
          key: _refreshCustomerKey,
          color: Color(0xFF004E92),
          child: Container(
            decoration: kTableContainer,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          DataColumn(label: Text('Total Sales')),
                          DataColumn(label: Text('Volume')),
                          DataColumn(label: Text('Onboard Date')),
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
    Future<Map<String, dynamic>> customers = futureValue.getAllCustomersPaginated(page: 1, limit: 50);
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
                      print("save changes");
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
                      Container(
                        decoration: kTableContainer,
                        child: ReusableDataTable()
                      ),
                      SizedBox(height: 40),
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

}

class ReusableDataTable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: TextStyle(
          color: Color(0xFF75759E),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        dataTextStyle: TextStyle(
          color: Color(0xFF1F1F1F),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        columnSpacing: 15.0,
        dataRowHeight: 65.0,
        columns: [
          DataColumn(label: Expanded(child: Text(' Name'))),
          DataColumn(label: Expanded(child: Text('Total Credits'))),
          DataColumn(label: Expanded(child: Text('Last Re-payment Date'))),
          DataColumn(label: Expanded(child: Text(''))),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N5,000')),
            DataCell(Text('-')),
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N20,000')),
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
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N200,000')),
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
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N180,000')),
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
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N180,000')),
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
            DataCell(TableArrowButton()),
          ]),
        ],
      ),
    );
  }

}



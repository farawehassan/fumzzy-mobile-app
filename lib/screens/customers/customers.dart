import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/bloc/suggestions.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/all-customers.dart';
import 'package:fumzy/model/customer-names.dart';
import 'package:fumzy/networking/customer-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'customer-detail/customer-detail.dart';

class Customers extends StatefulWidget {

  static const String id = 'cutomers';

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshCustomerKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshDebtorKey = GlobalKey<RefreshIndicatorState>();

  bool _showSpinner = false;

  TextEditingController search = TextEditingController();

  /// A List to hold the all the customers
  List<AllCustomers> _customers = [];

  /// A List to hold all the filtered customers
  List<AllCustomers> _filteredCustomers = [];

  /// An Integer variable to hold the length of [_customers]
  int? _customersLength;

  int? _totalCustomerCount;

  int _customerPageSize = 1;

  bool _showCustomerSpinner = false;

  void _getAllCustomers({bool? refresh}) async {
    Future<Map<String, dynamic>> customers = futureValue.getAllCustomersPaginated(
        refresh: refresh, page: _customerPageSize, limit: 50
    );
    await customers.then((value) {
      if(!mounted)return;
      setState(() {
        _customers.addAll(value['items']);
        _filteredCustomers = _customers;
        _customersLength = _filteredCustomers.length;
        _totalCustomerCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future _loadMoreCustomers() async {
    setState(() { _customerPageSize += 1; });
    Future<Map<String, dynamic>> purchases = futureValue.getAllCustomersPaginated(page: _customerPageSize, limit: 50);
    await purchases.then((value) {
      if (!mounted) return;
      setState(() {
        _customers.addAll(value['items']);
        _filteredCustomers = _customers;
        _customersLength = _customers.length;
        _totalCustomerCount = value['totalCount'];
        _showCustomerSpinner = false;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the customers
  Widget _buildCustomerList() {
    List<DataRow> itemRow = [];
    if(_filteredCustomers.length > 0 && _filteredCustomers.isNotEmpty){
      for (int i = 0; i < _filteredCustomers.length; i++){
        AllCustomers customer = _filteredCustomers[i];
        double totalSales = 0;
        customer.reports!.forEach((element) {
          totalSales += element.totalAmount!;
        });
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(customer.name!)),
            DataCell(Text(Functions.money(totalSales, 'N'))),
            DataCell(Text(customer.reports!.length.toString())),
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Functions.getFormattedDate(customer.createdAt!)),
                Text(
                  Functions.getFormattedTime(customer.createdAt!),
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            )),
            DataCell(TableArrowButton()),
          ],
          onSelectChanged: (value){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomersDetail(
                  customer: customer,
                ),
              ),
            ).then((value) => _refreshDebtors());
          }),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_showCustomerSpinner && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if(_totalCustomerCount! > (_customerPageSize * 50)){
              setState(() { _showCustomerSpinner = true; });
              _loadMoreCustomers();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshCustomers,
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
                  _showCustomerSpinner
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
    else if(_customersLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of customers from page 1 similar to [_getAllCustomers()]
  Future<Null> _refreshCustomers() {
    Future<Map<String, dynamic>> customers = futureValue.getAllCustomersPaginated(page: 1, limit: 50);
    return customers.then((value) {
      _customersLength = null;
      _customers.clear();
      _filteredCustomers.clear();
      _totalCustomerCount = null;
      if(!mounted)return;
      setState(() {
        _customers.addAll(value['items']);
        _filteredCustomers = _customers;
        _customersLength = _customers.length;
        _totalCustomerCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }


  /// A List to hold the all the debtors
  List<AllCustomers> _debtors = [];

  /// A List to hold all the filtered debtors
  List<AllCustomers> _filteredDebtors = [];

  /// An Integer variable to hold the length of [_debtors]
  int? _debtorsLength;

  int? _totalDebtorCount;

  int _debtorPageSize = 1;

  bool _showDebtorSpinner = false;

  void _getAllDebtors({bool? refresh}) async {
    Future<Map<String, dynamic>> debtors = futureValue.getAllDebtorsPaginated(
        refresh: refresh, page: _debtorPageSize, limit: 50
    );
    await debtors.then((value) {
      if(!mounted)return;
      setState(() {
        _debtors.addAll(value['items']);
        _filteredDebtors = _debtors;
        _debtorsLength = _filteredDebtors.length;
        _totalDebtorCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future _loadMoreDebtors() async {
    setState(() { _debtorPageSize += 1; });
    Future<Map<String, dynamic>> debtor = futureValue.getAllDebtorsPaginated(
        page: _customerPageSize, limit: 50);
    await debtor.then((value) {
      if (!mounted) return;
      setState(() {
        _debtors.addAll(value['items']);
        _filteredDebtors = _debtors;
        _debtorsLength = _debtors.length;
        _totalDebtorCount = value['totalCount'];
        _showDebtorSpinner = false;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the debtors
  Widget _buildDebtorList() {
    List<DataRow> itemRow = [];
    if(_filteredDebtors.length > 0 && _filteredDebtors.isNotEmpty){
      for (int i = 0; i < _filteredDebtors.length; i++){
        AllCustomers customer = _filteredDebtors[i];
        int references = 0;
        int invoices = 0;
        double totalDebts = 0;
        customer.reports!.forEach((element) {
          totalDebts += (element.totalAmount! - element.paymentMade!);
          if(element.paid!){
            if(element.description == null) invoices += 1;
            else references += 1;
          }
        });
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(customer.name!)),
            DataCell(Text(Functions.money(totalDebts, 'N'))),
            DataCell(Text(invoices == 0 ? '-' : '$invoices' + ' Invoice(s) due')),
            DataCell(Text(references == 0 ? '-' : '$references' + ' Reference(s)')),
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Functions.getFormattedShortDate(customer.updatedAt!)),
                Text(
                  Functions.getFormattedTime(customer.updatedAt!),
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            )),
            DataCell(TableArrowButton()),
          ],
          onSelectChanged: (value){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomersDetail(
                  customer: customer,
                ),
              ),
            ).then((value) => _refreshDebtors());
          }),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_showDebtorSpinner && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if(_totalDebtorCount! > (_debtorPageSize * 50)){
              setState(() { _showDebtorSpinner = true; });
              _loadMoreDebtors();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshDebtors,
          key: _refreshDebtorKey,
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
                          DataColumn(label: Text('Total Debts')),
                          DataColumn(label: Text('Invoices')),
                          DataColumn(label: Text(' References')),
                          DataColumn(label: Text(' Last Re-payment Date')),
                          DataColumn(label: Text('')),
                        ],
                        rows: itemRow,
                      )
                  ),
                  const SizedBox(height: 80),
                  _showDebtorSpinner
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
    else if(_debtorsLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of debtors from page 1 similar to [_getAllDebtors()]
  Future<Null> _refreshDebtors() {
    Future<Map<String, dynamic>> debtors = futureValue.getAllDebtorsPaginated(
        page: 1, limit: 50);
    return debtors.then((value) {
      _debtorsLength = null;
      _debtors.clear();
      _filteredDebtors.clear();
      _totalDebtorCount = null;
      if(!mounted)return;
      setState(() {
        _debtors.addAll(value['items']);
        _filteredDebtors = _debtors;
        _debtorsLength = _debtors.length;
        _totalDebtorCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /// A List to hold the all the customer names
  List<CustomerName> _customerNames = [];

  void _getAllCustomerNames() async {
    Future<List<CustomerName>> allCustomerNames = futureValue.getAllCustomerNames();
    allCustomerNames.then((value) {
      _customerNames.addAll(value);
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllCustomers(refresh: true);
    _getAllDebtors(refresh: true);
    _getAllCustomerNames();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'CUSTOMERS'),
        drawer: RefactoredDrawer(title: 'CUSTOMERS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'All Customers',
                      style: TextStyle(
                        color: Color(0xFF171725),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    Button(
                      onTap: () {
                        _addNewDebtor(constraints);
                      },
                      buttonColor: Color(0xFF00509A),
                      width: 160,
                      child: Center(
                        child: Text(
                          'Add Debtor',
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
                SizedBox(height: 35),
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
                          controller: search,
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
                          print('filter');
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
                SizedBox(height: 17),
                Container(
                  width: 163,
                  child: TabBar(
                    labelStyle: kTabBarTextStyle,
                    labelColor: Color(0xFF004E92),
                    unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                    indicatorColor: Color(0xFF004E92),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(child: Text('All', style: kTabBarTextStyle)),
                      Tab(child: Text('Debtors', style: kTabBarTextStyle)),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildCustomerList(),
                      _buildDebtorList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _addNewDebtor(BoxConstraints constraints) {

    final formKey = GlobalKey<FormState>();
    TextEditingController customerController = TextEditingController();
    CustomerName? selectedCustomer;
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
    TextEditingController dueDate = TextEditingController();
    DateTime? dueDateTime;

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
                              'NEW DEBTOR',
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
                                  'Add New Debtor',
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
                                  'You have made additional sales on credit. Please fill the fields to record your credit sales.',
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
                                      /// Customer
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Customer'),
                                          SizedBox(height: 10),
                                          Container(
                                            width: constraints.maxWidth,
                                            child: TypeAheadFormField(
                                              textFieldConfiguration: TextFieldConfiguration(
                                                controller: customerController,
                                                decoration: kTextFieldBorderDecoration.copyWith(
                                                  hintText: 'Customer name',
                                                  contentPadding: EdgeInsets.all(10),
                                                ),
                                              ),
                                              suggestionsCallback: (pattern) async {
                                                return await Suggestions.getCustomerSuggestions(pattern, _customerNames);
                                              },
                                              itemBuilder: (context, CustomerName suggestion) {
                                                return ListTile(title: Text(suggestion.name!));
                                              },
                                              transitionBuilder: (context, suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Select or type customer';
                                                }
                                                return null;
                                              },
                                              onSuggestionSelected: (CustomerName suggestion) {
                                                if (!mounted) return;
                                                setState(() {
                                                  selectedCustomer = suggestion;
                                                  customerController.text = suggestion.name!;
                                                });
                                              },
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
                                      /// Reference
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Reference'),
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
                                                  return 'Enter reference or description';
                                                }
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter reference or description',
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
                                      /// Due date
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Due Date'),
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
                                              controller: dueDate,
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime now = DateTime.now();
                                                final DateTime? picked = await showDatePicker(
                                                    context: context,
                                                    initialDate: now,
                                                    firstDate: now,
                                                    lastDate: DateTime(2030),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData.light().copyWith(
                                                          colorScheme: ColorScheme.light().copyWith(
                                                            primary: Color(0xFF00509A),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    }
                                                );
                                                if (picked != null && picked != now) {
                                                  if (!mounted) return;
                                                  setDialogState(() {
                                                    dueDateTime = picked;
                                                    dueDate.text = Functions.getFormattedDate(picked);
                                                  });
                                                }
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Enter due date';
                                                }
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Select due date',
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
                                      'totalAmount': amountController.text,
                                      'soldAt': DateTime.now().toIso8601String(),
                                      'dueDate': dueDateTime!.toIso8601String(),
                                      'description': referenceController.text
                                    };
                                    if(selectedCustomer == null){
                                      body['name'] = customerController.text;
                                      _addDebtor(body, setDialogState);
                                    }
                                    else {
                                      body['id'] = selectedCustomer!.id;
                                      _addDebtorReports(body, setDialogState);
                                    }
                                  }
                                },
                                buttonColor: Color(0xFF00509A),
                                child: Center(
                                  child: _showSpinner
                                      ? CircleProgressIndicator()
                                      : Text(
                                    'Record Debt',
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

  /// function to make api call to [addPreviousCustomer] with the help of
  /// [CustomerDataSource]
  Future<void> _addDebtor(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.addPreviousCustomer(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      _refreshDebtors();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

  /// function to make api call to [addPreviousCustomerReports] with the help of
  /// [CustomerDataSource]
  Future<void> _addDebtorReports(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.addPreviousCustomerReports(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      _refreshDebtors();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}






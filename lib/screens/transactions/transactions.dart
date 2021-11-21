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
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/expense.dart';
import 'package:fumzy/model/purchases.dart';
import 'package:fumzy/networking/expense-datasource.dart';
import 'package:fumzy/model/sales.dart';
import 'package:fumzy/networking/product-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'expense-info.dart';
import 'sales-info.dart';
import 'add-sale.dart';

class Transactions extends StatefulWidget {

  static const String id = 'transactions';

  final int? tabSelector;

  Transactions({
    this.tabSelector
  });

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshPurchaseKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshSalesKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshExpenseKey = GlobalKey<RefreshIndicatorState>();

  TextEditingController search = TextEditingController();

  ///[CONTROLLERS] and [KEY] for [EXPENSE DIALOG]
  final _expenseFormKey = GlobalKey<FormState>();

  ///[CONTROLLERS] and [KEY] for [ADD PRODUCT DIALOG]
  final _addPurchaseFormKey = GlobalKey<FormState>();
  Category? selectedCategory;
  TextEditingController _productName = TextEditingController();
  TextEditingController _productCategory = TextEditingController();
  TextEditingController _costPrice = TextEditingController();
  TextEditingController _sellingPrice = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _sellersName = TextEditingController();

  bool _showSpinner = false;

  ///A list to hold the categories
  List<Category> _categories = [];


  /** Expense Section **/

  ///A list to hold expenses
  List<Expense> _expenses = [];

  ///A list to hold filtered expenses
  List<Expense> _filteredExpenses = [];

  /// An Integer variable to hold the length of [_expenses]
  int? _expensesLength;

  int? _totalExpenseCount;

  int _expensePageSize = 1;

  bool _showExpenseSpinner = false;

  void _getAllExpenses({bool? refresh}) async {
    Future<Map<String, dynamic>> expenses = futureValue.getAllExpense(
        refresh: refresh, page: _expensePageSize, limit: 50
    );
    await expenses.then((value) {
      if(!mounted)return;
      setState(() {
        _expenses.addAll(value['items']);
        _filteredExpenses = _expenses;
        _expensesLength = _filteredExpenses.length;
        _totalExpenseCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future _loadMoreExpenses() async {
    setState(() { _expensePageSize += 1; });
    Future<Map<String, dynamic>> expenses = futureValue.getAllExpense(page: _purchasePageSize, limit: 50);
    await expenses.then((value) {
      if (!mounted) return;
      setState(() {
        _expenses.addAll(value['items']);
        _filteredExpenses = _expenses;
        _expensesLength = _expenses.length;
        _totalExpenseCount = value['totalCount'];
        _showExpenseSpinner = false;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  ///A function to build expense list
  Widget _buildExpenseList(){
    List<DataRow> itemRow = [];
    if(_filteredExpenses.isNotEmpty){
      for (int i = 0; i < _filteredExpenses.length; i++){
        Expense expense = _filteredExpenses[i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(Functions.getFormattedDateTime(expense.createdAt!))),
            DataCell(Text(expense.description!)),
            DataCell(Text(Functions.money(expense.amount!, 'N'))),
            DataCell(Text(expense.staff!.name!)),
            DataCell(TableArrowButton()),
          ],
          onSelectChanged: (value){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseInfo(
                  expense: expense,
                ),
              ),
            ).then((value) => _refreshExpenses());
          }),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_showExpenseSpinner && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if(_totalExpenseCount! > (_expensePageSize * 50)){
              setState(() { _showExpenseSpinner = true; });
              _loadMoreExpenses();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshExpenses,
          key: _refreshExpenseKey,
          color: Color(0xFF004E92),
          child: Container(
            decoration: kTableContainer,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
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
                        //fontWeight: FontWeight.w400,
                      ),
                      columnSpacing: 15.0,
                      dataRowHeight: 65.0,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Staff')),
                        DataColumn(label: Text('')),
                      ],
                      rows: itemRow,
                    ),
                  ),
                  const SizedBox(height: 80),
                  if(_showExpenseSpinner)
                    Padding(
                      padding: EdgeInsets.only(left: 150),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A459F)),
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else if(_expensesLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of expenses from page 1 similar to [_getAllExpenses()]
  Future<Null> _refreshExpenses() {
    Future<Map<String, dynamic>> expenses = futureValue.getAllExpense(page: 1, limit: 50);
    return expenses.then((value) {
      _expensesLength = null;
      _expenses.clear();
      _filteredExpenses.clear();
      _totalExpenseCount = null;
      if(!mounted)return;
      setState(() {
        _expenses.addAll(value['items']);
        _filteredExpenses = _expenses;
        _expensesLength = _expenses.length;
        _totalExpenseCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }


  /** Purchase Section **/

  /// A List to hold the all the purchases
  List<Purchase> _purchases = [];

  /// A List to hold all the filtered purchases
  List<Purchase> _filteredPurchases = [];

  /// An Integer variable to hold the length of [_purchases]
  int? _purchasesLength;

  int? _totalPurchaseCount;

  int _purchasePageSize = 1;

  bool _showPurchaseSpinner = false;

  void _getAllPurchases({bool? refresh}) async {
    Future<Map<String, dynamic>> products = futureValue.getAllPurchasesPaginated(
        refresh: refresh, page: _purchasePageSize, limit: 50
    );
    await products.then((value) {
      if(!mounted)return;
      setState(() {
        _purchases.addAll(value['items']);
        _filteredPurchases = _purchases;
        _purchasesLength = _filteredPurchases.length;
        _totalPurchaseCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future _loadMorePurchases() async {
    setState(() { _purchasePageSize += 1; });
    Future<Map<String, dynamic>> purchases = futureValue.getAllPurchasesPaginated(page: _purchasePageSize, limit: 50);
    await purchases.then((value) {
      if (!mounted) return;
      setState(() {
        _purchases.addAll(value['items']);
        _filteredPurchases = _purchases;
        _purchasesLength = _purchases.length;
        _totalPurchaseCount = value['totalCount'];
        _showPurchaseSpinner = false;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the purchases
  Widget _buildPurchaseList() {
    List<DataRow> itemRow = [];
    if(_filteredPurchases.isNotEmpty){
      for (int i = 0; i < _filteredPurchases.length; i++){
        Purchase purchase = _filteredPurchases[i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(Functions.getFormattedDateTime(purchase.createdAt!))),
            DataCell(Text(purchase.product!.productName!)),
            DataCell(Text(purchase.product!.category!.name!)),
            DataCell(Text(purchase.quantity!.toString())),
            DataCell(Text(Functions.money(purchase.costPrice!, 'N'))),
            DataCell(Text(Functions.money(purchase.costPrice!, 'N'))),
            DataCell(Text(Functions.money(purchase.product!.costPrice! * purchase.quantity!, 'N'))),
          ]),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_showPurchaseSpinner && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if(_totalPurchaseCount! > (_purchasePageSize * 50)){
              setState(() { _showPurchaseSpinner = true; });
              _loadMorePurchases();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshPurchases,
          key: _refreshPurchaseKey,
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
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Product Name')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Cost Price')),
                          DataColumn(label: Text('Selling Price')),
                          DataColumn(label: Text('Amount')),
                        ],
                        rows: itemRow,
                      )
                  ),
                  const SizedBox(height: 80),
                  if(_showPurchaseSpinner)
                    Padding(
                      padding: EdgeInsets.only(left: 200),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A459F)),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else if(_purchasesLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of products from page 1 similar to [_getAllProducts()]
  Future<Null> _refreshPurchases() {
    Future<Map<String, dynamic>> products = futureValue.getAllPurchasesPaginated(page: 1, limit: 50);
    return products.then((value) {
      _purchasesLength = null;
      _purchases.clear();
      _filteredPurchases.clear();
      _totalPurchaseCount = null;
      if(!mounted)return;
      setState(() {
        _purchases.addAll(value['items']);
        _filteredPurchases = _purchases;
        _purchasesLength = _purchases.length;
        _totalPurchaseCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }


  /** SALES SECTION ***/

  /// A List to hold the all the sales
  List<Sale> _sales = [];

  /// A List to hold all the filtered sales
  List<Sale> _filteredSales = [];

  /// An Integer variable to hold the length of [_sales]
  int? _saleLength;

  int? _totalSaleCount;

  int _salePageSize = 1;

  bool _showSaleSpinner = false;

  void _getAllSales({bool? refresh}) async {
    Future<Map<String, dynamic>> products = futureValue.getAllSalesPaginated(
        refresh: refresh, page: _salePageSize, limit: 50
    );
    await products.then((value) {
      if(!mounted)return;
      setState(() {
        _sales.addAll(value['items']);
        _filteredSales = _sales;
        _saleLength = _filteredSales.length;
        _totalSaleCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future _loadMoreSales() async {
    setState(() { _salePageSize += 1; });
    Future<Map<String, dynamic>> sales = futureValue.getAllSalesPaginated(page: _salePageSize, limit: 50);
    await sales.then((value) {
      if (!mounted) return;
      setState(() {
        _sales.addAll(value['items']);
        _filteredSales = _sales;
        _saleLength = _sales.length;
        _totalSaleCount = value['totalCount'];
        _showSaleSpinner = false;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the sales
  Widget _buildSaleList() {
    List<DataRow> itemRow = [];
    if(_filteredSales.isNotEmpty){
      for (int i = 0; i < _filteredSales.length; i++){
        Sale sale = _filteredSales[i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(Functions.getFormattedDateTime(sale.createdAt!))),
            DataCell(Text(sale.productName!)),
            DataCell(Text(sale.quantity!.toString())),
            DataCell(Text(sale.paymentMode!)),
            DataCell(Text(
              Functions.money(sale.totalPrice!, 'N'),
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(TableArrowButton()),
          ],
          onSelectChanged: (value){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesInfo(
                  sale: sale,
                ),
              ),
            ).then((value) => _refreshSales());
          }),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_showSaleSpinner && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if(_totalSaleCount! > (_salePageSize * 50)){
              setState(() { _showSaleSpinner = true; });
              _loadMoreSales();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshSales,
          key: _refreshSalesKey,
          color: Color(0xFF004E92),
          child: Container(
            decoration: kTableContainer,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
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
                        //fontWeight: FontWeight.w400,
                      ),
                      columnSpacing: 15.0,
                      dataRowHeight: 65.0,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Product Name')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Payment Mode')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('')),
                      ],
                      rows: itemRow,
                    ),
                  ),
                  const SizedBox(height: 80),
                  if(_showSaleSpinner)
                    Padding(
                      padding: EdgeInsets.only(left: 200),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A459F)),
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            )),
        ),
      );
    }
    else if(_saleLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of sales from page 1 similar to [_getAllSales()]
  Future<Null> _refreshSales() {
    Future<Map<String, dynamic>> products = futureValue.getAllSalesPaginated(page: 1, limit: 50);
    return products.then((value) {
      _saleLength = null;
      _sales.clear();
      _filteredSales.clear();
      _totalSaleCount = null;
      if(!mounted)return;
      setState(() {
        _sales.addAll(value['items']);
        _filteredSales = _sales;
        _saleLength = _sales.length;
        _totalSaleCount = value['totalCount'];
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  ///A function to get all the available categories and store them in list[_categories]
  void _getAllCategories() async {
    Future<List<Category>> categories = futureValue.getAllCategories();
    await categories.then((value){
      if (!mounted)return;
      setState((){
        _categories.addAll(value);
      });
    }).catchError((e){
      Functions.showErrorMessage(e);
    });
  }

  /// This is a variable that holds if the user is admin or not
  bool _isAdmin = false;

  /// Function to fetch the user's details and check if user is admin or not to
  /// set to [_isAdmin]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((value) async {
      if(!mounted)return;
      setState(() => _isAdmin = value.type! == 'admin');
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
    _getAllPurchases(refresh: true);
    _getAllSales(refresh: true);
    _getAllCategories();
    _getAllExpenses(refresh: true);
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
          appBar: buildAppBar(constraints, 'TRANSACTIONS'),
          drawer: RefactoredDrawer(title: 'TRANSACTIONS'),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: DefaultTabController(
              length: 3,
              initialIndex: widget.tabSelector ?? 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'All Transactions',
                          style: TextStyle(
                            color: Color(0xFF171725),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          alignment: WrapAlignment.end,
                          runAlignment: WrapAlignment.end,
                          runSpacing: 12,
                          spacing: 12,
                          children: [
                            TextButton(
                              onPressed: () {
                                _addExpense(constraints).then((value) => _refreshExpenses());
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Add expenses',
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Button(
                              onTap: (){
                                Navigator.pushNamed(context, AddSale.id).then((value) => _refreshSales());
                              },
                              buttonColor: Color(0xFF00AF27),
                              width: 160,
                              child: Center(
                                child: Text(
                                  'Add Sale',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            if(_isAdmin) Button(
                              onTap: (){
                                _addPurchase(constraints);
                              },
                              buttonColor: Color(0xFFF28301),
                              width: 160,
                              child: Center(
                                child: Text(
                                  'Add Purchase',
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
                  SizedBox(height: 37),
                  Container(
                    width: 296,
                    child: TabBar(
                      labelStyle: kTabBarTextStyle,
                      labelColor: Color(0xFF004E92),
                      unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                      indicatorColor: Color(0xFF004E92),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(child: Text('Sales', style: kTabBarTextStyle)),
                        Tab(child: Text('Purchases', style: kTabBarTextStyle)),
                        Tab(child: Text('Expenses', style: kTabBarTextStyle)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildSaleList(),
                        _buildPurchaseList(),
                        _buildExpenseList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  /**[EXPENSE] SECTION **/

  ///widget to show the dialog to add [EXPENSES]
  Future<void> _addExpense (BoxConstraints constraints) {
    TextEditingController expenseDescription = TextEditingController();
    TextEditingController expenseAmount = TextEditingController();
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
                margin: EdgeInsets.all(40),
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
                              'NEW EXPENSE',
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
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 42),
                                child: Text(
                                  'Add a New Expense',
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
                                  'You have made a new expense. Please fill the fields to record your expense.',
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
                                  key: _expenseFormKey,
                                  child: Column(
                                    children: [
                                      //description
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
                                              keyboardType: TextInputType.text,
                                              controller: expenseDescription,
                                              maxLines: 3,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter Description';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Enter description',
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
                                      // Amount
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
                                              textInputAction: TextInputAction.done,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                              ],
                                              controller: expenseAmount,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter amount';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'N Enter amount',
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
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              Button(
                                onTap: (){
                                  if(!_showSpinner){
                                    if(_expenseFormKey.currentState!.validate()){
                                      Map<String, dynamic> body = {
                                        'description': expenseDescription.text,
                                        'amount': expenseAmount.text,
                                      };
                                      _createExpense(setDialogState, body);
                                    }
                                  }
                                },
                                buttonColor: Color(0xFF00509A),
                                child: Center(
                                  child: _showSpinner
                                      ? CircleProgressIndicator()
                                      : const Text(
                                    'Record Expense',
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
              ),
            );
          },
        ),
      ),
    );
  }

  ///function to make api call to [CREATE_EXPENSE]
  void _createExpense(StateSetter setDialogState, Map<String, dynamic> body) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ExpenseDataSource();
    await api.createExpense(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      _refreshExpenses();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

  /**[PURCHASE] SECTION **/

  ///widget to show the dialog [ADD_NEW_PRODUCT]
  Future<void> _addPurchase(BoxConstraints constraints) {
    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) => AbsorbPointer(
            absorbing: _showSpinner,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFFFFFFF),
              ),
              margin: EdgeInsets.all(40),
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
                            'NEW PURCHASE',
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
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 42),
                              child: Text(
                                'Add a New Product',
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
                                'You wish to add a new product. Please fill the fields to record this product.',
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
                                key: _addPurchaseFormKey,
                                child: Column(
                                  children: [
                                    //product name
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Product Name'),
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
                                            keyboardType: TextInputType.text,
                                            controller: _productName,
                                            validator: (value) {
                                              if (value!.isEmpty) return 'Enter product name';
                                              return null;
                                            },
                                            decoration: kTextFieldBorderDecoration.copyWith(
                                              hintText: 'Enter product name',
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
                                    //product category
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Product Category'),
                                        SizedBox(height: 10),
                                        Container(
                                          width: constraints.maxWidth,
                                          child: TypeAheadFormField(
                                            textFieldConfiguration: TextFieldConfiguration(
                                              controller: _productCategory,
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Category',
                                                contentPadding: EdgeInsets.all(10),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) return 'Select category';
                                              return null;
                                            },
                                            suggestionsCallback: (pattern) async {
                                              return await Suggestions.getCategorySuggestions(pattern, _categories);
                                            },
                                            itemBuilder: (context, Category suggestion) {
                                              return ListTile(title: Text(suggestion.name!));
                                            },
                                            transitionBuilder: (context, suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected: (Category suggestion) {
                                              if (!mounted) return;
                                              setState(() {
                                                selectedCategory = suggestion;
                                                _productCategory.text = suggestion.name!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    //cost and selling price
                                    Row(
                                        children: [
                                          // Cost Price
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Cost Price'),
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
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                    ],
                                                    controller: _costPrice,
                                                    validator: (value) {
                                                      if (value!.isEmpty) return 'Enter amount';
                                                      return null;
                                                    },
                                                    decoration: kTextFieldBorderDecoration.copyWith(
                                                      hintText: 'Enter amount',
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
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Selling Price'),
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
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                    ],
                                                    controller: _sellingPrice,
                                                    validator: (value) {
                                                      if (value!.isEmpty) return 'Enter amount';
                                                      return null;
                                                    },
                                                    decoration: kTextFieldBorderDecoration.copyWith(
                                                      hintText: 'Enter amount',
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
                                          ),
                                        ]
                                    ),
                                    SizedBox(height: 20),
                                    // Quantity
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Quantity'),
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
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                            ],
                                            controller: _quantity,
                                            validator: (value) {
                                              if (value!.isEmpty) return 'Enter quantity';
                                              return null;
                                            },
                                            decoration: kTextFieldBorderDecoration.copyWith(
                                              hintText: 'Enter quantity',
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
                                    // Sellers name
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Seller\'s Name',),
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
                                            keyboardType: TextInputType.text,
                                            controller: _sellersName,
                                            validator: (value) {
                                              if (value!.isEmpty) return 'Enter seller\'s name';
                                              return null;
                                            },
                                            decoration: kTextFieldBorderDecoration.copyWith(
                                              hintText: 'Enter seller\'s name',
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
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Button(
                              onTap: (){
                                if(!_showSpinner){
                                  if(_addPurchaseFormKey.currentState!.validate()){
                                    _addProduct(setDialogState);
                                  }
                                }
                              },
                              buttonColor: Color(0xFF00509A),
                              child: Center(
                                child: _showSpinner ?
                                CircleProgressIndicator() :
                                const Text(
                                  'Add Product',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 100,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Center(
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
                            const SizedBox(height: 50),
                            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///function to make api call to [ADD_PRODUCT]
  void _addProduct(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ProductDataSource();
    Map<String, String> body = {
      'productName': _productName.text,
      'category': _productCategory.text,
      'costPrice': _costPrice.text,
      'sellingPrice': _sellingPrice.text,
      'initialQty': _quantity.text,
      'currentQty': _quantity.text,
      'quantity': _quantity.text,
      'sellersName': _sellersName.text,
    };
    await api.addProduct(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      _refreshPurchases();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}
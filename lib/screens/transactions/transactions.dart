import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/model/purchases.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:fumzy/utils/size-config.dart';
import 'package:shimmer/shimmer.dart';
import 'expenses.dart';
import 'purchase-info.dart';
import 'purchases.dart';
import 'sales.dart';
import 'add-sale.dart';

class Transactions extends StatefulWidget {

  static const String id = 'transactions';

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshPurchaseKey = GlobalKey<RefreshIndicatorState>();

  TextEditingController search = TextEditingController();

  ///[CONTROLLERS] and [KEY] for [EXPENSE DIALOG]
  final _expenseFormKey = GlobalKey<FormState>();
  TextEditingController _expenseDescriptionController = TextEditingController();
  TextEditingController _expenseAmountController = TextEditingController();

  bool _showSpinner = false;

  /// A List to hold the all the purchases
  List<Purchase> _purchases = [];

  /// A List to hold the all the filtered purchases
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
      if(!mounted)return;
      //_getAllProducts(refresh: false);
    });
  }

  Future _loadMorePurchases() async {
    setState(() { _purchasePageSize += 1; });
    Future<Map<String, dynamic>> deliveries = futureValue.getAllPurchasesPaginated(page: _purchasePageSize, limit: 50);
    await deliveries.then((value) {
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
    if(_filteredPurchases.length > 0 && _filteredPurchases.isNotEmpty){
      for (int i = 0; i < _filteredPurchases.length; i++){
        Purchase purchase = _filteredPurchases[i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(Functions.getFormattedDateTime(purchase.createdAt!))),
            DataCell(Text(purchase.product!.productName!)),
            DataCell(Text(purchase.product!.category!.name!)),
            DataCell(Text(purchase.quantity!.toString())),
            DataCell(Text(Functions.money(purchase.product!.costPrice!, 'N'))),
            DataCell(Text(Functions.money(purchase.product!.costPrice!, 'N'))),
            DataCell(Text(Functions.money(purchase.product!.costPrice! * purchase.quantity!, 'N'))),
            DataCell(GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, PurchaseInfo.id);
              },
              child: TableArrowButton(),
            )),
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
          onRefresh: _refreshProducts,
          key: _refreshPurchaseKey,
          color: Color(0xFF004E92),
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
                        DataColumn(label: Text('')),
                      ],
                      rows: itemRow,
                    )
                ),
                const SizedBox(height: 80),
                _showPurchaseSpinner
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
      );
    }
    else if(_purchasesLength == 0) return Container();
    return _shimmerLoader();
  }

  /// Function to refresh list of products from page 1 similar to [_getAllProducts()]
  Future<Null> _refreshProducts() {
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
    _getAllPurchases(refresh: true);
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
              initialIndex: 0,
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
                                _addExpense(constraints,CircleProgressIndicator());
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
                                Navigator.pushNamed(context, AddSale.id);
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
                            Button(
                              onTap: (){
                                _addNewPurchase(constraints);
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
                    width: 296,
                    child: TabBar(
                      labelStyle: kTabBarTextStyle,
                      labelColor: Color(0xFF004E92),
                      unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                      indicatorColor: Color(0xFF004E92),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          child: Text(
                            'Sales',
                            style: kTabBarTextStyle,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Purchases',
                            style: kTabBarTextStyle,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Expenses',
                            style: kTabBarTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Sales(),
                        _buildPurchaseList(),
                        Expenses(),
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

  ///widget to show the dialog to add [PURCHASE]
  List<String> categories = ["Drinks", "Sweet", "Furniture", "Wine"];

  Future<void> _addNewPurchase(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController productName = TextEditingController();
    TextEditingController costPrice = TextEditingController();
    TextEditingController sellingPrice = TextEditingController();
    TextEditingController quantity = TextEditingController();
    TextEditingController amount = TextEditingController();
    TextEditingController sellersName = TextEditingController();

    String? selectedCategory = "Drinks";

    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => Container(
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
                          'Add a New Purchase',
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
                          'You have made a new purchase. Please fill the fields to record your purchase.',
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
                            children: [
                              //product name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Name',
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
                                      keyboardType: TextInputType.text,
                                      autofocus: true,
                                      controller: productName,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter product name';
                                        }
                                        return null;
                                      },
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        hintText: 'Enter product',
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
                                  Text(
                                    'Product Category',
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: constraints.maxWidth,
                                    child: DropdownButtonFormField<String>(
                                      value: selectedCategory,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      },
                                      style: TextStyle(
                                          color: Color(0xFF171725),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14
                                      ),
                                      iconEnabledColor: Color(0xFF000000),
                                      icon: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        contentPadding: EdgeInsets.all(12),
                                      ),
                                      items: categories.map((value) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: Color(0xFF171725),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14
                                            ),
                                          ),
                                          value: value,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              //unit cost and selling price
                              Row(
                                children: [
                                  // Cost Price
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Unit Cost Price',
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                            ],
                                            controller: costPrice,
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
                                        Text(
                                          'Unit Selling Price',
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                            ],
                                            controller: sellingPrice,
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
                                  Text(
                                    'Quantity',
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
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                      ],
                                      controller: quantity,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter quantity';
                                        }
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
                              // Amount
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount',
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
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                      ],
                                      controller: amount,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter amount';
                                        }
                                        return null;
                                      },
                                      decoration: kTextFieldBorderDecoration.copyWith(
                                        hintText: 'N',
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
                                  Text(
                                    'Seller\'s Name',
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
                                      keyboardType: TextInputType.text,
                                      controller: sellersName,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter seller\'s name';
                                        }
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
                      SizedBox(height: 40),
                      Button(
                        onTap: (){
                          print("Record Purchase");
                        },
                        buttonColor: Color(0xFF00509A),
                        child: Center(
                          child: Text(
                            'Record Purchase',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///widget to show the dialog to add [EXPENSES]
  Future<void> _addExpense (BoxConstraints constraints, Widget circleProgressIndicator) {
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
                                  'You have made a new purchase. Please fill the fields to record your purchase.',
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
                                              controller: _expenseDescriptionController,
                                              maxLines: 3,
                                              validator: (value) {
                                                if (value!.isEmpty) return 'Enter Description';
                                                return null;
                                              },
                                              decoration: kTextFieldBorderDecoration.copyWith(
                                                hintText: 'Bought 10 litres petrol',
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
                                              controller: _expenseAmountController,
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
                                      _createOneExpense(setDialogState);
                                    }
                                  }
                                },
                                buttonColor: Color(0xFF00509A),
                                child: Center(
                                  child: _showSpinner ?
                                  circleProgressIndicator :
                                  const Text(
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
  void _createOneExpense(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    Map<String, String> body = {
      "description": _expenseDescriptionController.text,
      "amount": _expenseAmountController.text,
    };
    await api.createExpense(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      print(message);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
    });
  }
}
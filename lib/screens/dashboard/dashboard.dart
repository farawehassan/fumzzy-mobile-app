import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/fade-animation.dart';
import 'package:fumzy/components/inventory-card.dart';
import 'package:fumzy/components/reusable-card.dart';
import 'package:fumzy/components/sales-card.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/purchases.dart';
import 'package:fumzy/model/sales.dart';
import 'package:fumzy/model/store.dart';
import 'package:fumzy/screens/transactions/sales-info.dart';
import 'package:fumzy/screens/transactions/transactions.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'drawer.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';

class Dashboard extends StatefulWidget {

  static const String id = 'dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshPurchaseKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshSalesKey = GlobalKey<RefreshIndicatorState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Instantiating a class of the [Store]
  Store? _storeInfo;

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

  /// A function to build the list of all the purchases
  Widget _buildPurchaseList() {
    List<DataRow> itemRow = [];
    if(_filteredPurchases.length > 0 && _filteredPurchases.isNotEmpty){
      for (int i = 0; i <= 3; i++){
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
      return RefreshIndicator(
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
                      dataRowHeight: 72.0,
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
                const SizedBox(height: 5),
                _showPurchaseSpinner ?
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A459F)),
                      ),
                    ),
                  )
                    : Container(),
                const SizedBox(height: 5),
              ],
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
    Future<Map<String, dynamic>> products = futureValue.getAllPurchasesPaginated(page: 1, limit: 5);
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

  /// A function to build the list of all the sales
  Widget _buildSaleList() {
    List<DataRow> itemRow = [];
    if(_filteredSales.length > 0 && _filteredSales.isNotEmpty){
      for (int i = 0; i <= 3; i++){
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
              );
            }),
        );
      }
      return RefreshIndicator(
        onRefresh: _refreshSales,
        key: _refreshSalesKey,
        color: Color(0xFF004E92),
        child: Container(
          decoration: kTableContainer,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DataTable(
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
                    dataRowHeight: 72.0,
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
                  const SizedBox(height: 5),
                  _showPurchaseSpinner ?
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A459F)),
                      ),
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          )),
      );
    }
    else if(_saleLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of sales from page 1 similar to [_getAllSales()]
  Future<Null> _refreshSales() {
    Future<Map<String, dynamic>> products = futureValue.getAllSalesPaginated(page: 1, limit: 5);
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


  void _getStoreInformation() async{
    Future<Store> store = futureValue.getStoreInformation();
      await store.then((Store value) {
      setState(() => _storeInfo = value);
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getStoreInformation();
    _getAllPurchases(refresh: true);
    _getAllSales(refresh: true);
  }

  List<String> _view = [
    "This Week",
    "Yesterday",
    "Today",
    "This Month",
    "6 Months",
    "All Time"
  ];

  String? _selectedView = "This Week";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: buildAppBar(constraints, 'DASHBOARD'),
        drawer: RefactoredDrawer(title: 'DASHBOARD'),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 23, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: _selectedView,
                    onChanged: (value) {
                      setState(() {
                        _selectedView = value;
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E2EA), width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E2EA), width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    items: _view.map((value) {
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
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    TotalSalesCard(
                      cardName: 'Total Sales',
                      totalPrice: _storeInfo?.totalSales!,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Purchases',
                      totalPrice: _storeInfo?.totalPurchases!,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Expenses',
                      totalPrice: _storeInfo?.totalExpenses!,
                    ),
                    TotalSalesCard(
                      cardName: 'Total Profit',
                      totalPrice: _storeInfo?.totalProfitMade!,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Wrap(
                  children: [
                    InventoryCard(
                      cardName: 'Inventory Cost Price',
                      totalPrice: _storeInfo?.inventoryCostPrice,
                      cardColor: Color(0xFFF64932),
                    ),
                    InventoryCard(
                      cardName: 'Inventory Selling Price',
                      totalPrice: _storeInfo?.inventorySellingPrice,
                      cardColor: Color(0xFF00AF27),
                    ),
                    InventoryCard(
                      cardName: 'Inventory Profit',
                      totalPrice: _storeInfo?.inventoryProfit,
                      cardColor: Color(0xFF00509A),
                    ),
                    InventoryCard(
                      cardName: 'Inventory Items',
                      totalPrice: _storeInfo?.inventoryItems,
                      cardColor: Colors.brown,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                //outstanding cards, recent purchases
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Outstanding',
                            style: TextStyle(
                              color: Color(0xFF171725),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            child: ReusableCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Sales  ',
                                                  style: TextStyle(
                                                    color: Color(0xFF75759E),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                GreenIndicator(),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                Functions.money(110000, 'N'),
                                                style: const TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 75,
                                          margin: EdgeInsets.symmetric(horizontal: 13),
                                          child: VerticalDivider(
                                            color: Colors.grey,
                                            thickness: 0.6,
                                            width: 1,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Volume',
                                              style: TextStyle(
                                                color: Color(0xFF75759E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                '20',
                                                style: const TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        print("see details");
                                      },
                                      child: Wrap(
                                        children: [
                                          const Text(
                                            'See Details  ',
                                            style: TextStyle(
                                              color: Color(0xFF00509A),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Icon(
                                            IconlyBold.arrowRightCircle,
                                            size: 16.5,
                                            color: Color(0xFF004E92).withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),//see details button
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          Container(
                            child: ReusableCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Purchase  ',
                                                  style: TextStyle(
                                                    color: Color(0xFF75759E),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                PartPaidIndicator(),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                Functions.money(75000, 'N'),
                                                style: const TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),//purchase
                                        Container(
                                          height: 75,
                                          margin: EdgeInsets.symmetric(horizontal: 13),
                                          child: VerticalDivider(
                                            color: Colors.grey,
                                            thickness: 0.6,
                                            width: 1,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Volume',
                                              style: TextStyle(
                                                color: Color(0xFF75759E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            FadeAnimation(
                                              delay: 1.5,
                                              child: Text(
                                                '12',
                                                style: const TextStyle(
                                                  color: Color(0xFF171725),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),//volume
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        print("see details");
                                      },
                                      child: Wrap(
                                        children: [
                                          const Text(
                                            'See Details  ',
                                            style: TextStyle(
                                              color: Color(0xFF00509A),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Icon(
                                            IconlyBold.arrowRightCircle,
                                            size: 16.5,
                                            color: Color(0xFF004E92).withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),//see details button
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 13),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Purchases',
                                style: TextStyle(
                                  color: Color(0xFF171725),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 450),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (BuildContext context) => Transactions(tabSelector: 1)),
                                  );
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          ReusableCard(
                            child: Container(
                              height: 340,
                              child: _buildPurchaseList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Sales',
                            style: TextStyle(
                              color: Color(0xFF171725),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Transactions.id);
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFF00509A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 340,
                      //width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFE2E2EA),
                        ),
                      ),
                      child: _buildSaleList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

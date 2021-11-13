import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/screens/inventory/inventory-detail/inventory-detail.dart';
import 'package:fumzy/utils/functions.dart';

class ProductsOnly extends StatefulWidget {

  static const String id = 'products-only';

  @override
  _ProductsOnlyState createState() => _ProductsOnlyState();
}

class _ProductsOnlyState extends State<ProductsOnly> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshProductKey = GlobalKey<RefreshIndicatorState>();

  TextEditingController _search = TextEditingController();

  Map<String, Color> _stockColor = {
    'Short Stock': Color(0xFFF28301),
    'In Stock': Color(0xFF00AF27),
    'Out of Stock': Color(0xFFF64932),
    '': Colors.transparent
  };

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

  /** Product aspect ***/

  /// A List to hold the all the products
  List<Product> _products = [];

  /// A List to hold the all the product categories and product count
  Map<String, double> _productCategories = {};

  /// An Integer variable to hold the length of [_products]
  int? _productsLength;

  void _getAllProducts({bool? refresh}) async {
    Future<List<Product>> products = futureValue.getAllProducts(refresh: refresh);
    await products.then((value) {
      if(!mounted)return;
      setState(() {
        for(int i = 0; i < value.length; i++){
          _products.add(value[i]);
          if(_productCategories.containsKey(value[i].category!.name!)){
            _productCategories[value[i].category!.name!] =
                _productCategories[value[i].category!.name!]! + value[i].currentQty!;
          }
          else {
            _productCategories[value[i].category!.name!] = value[i].currentQty!;
          }
        }
        _productsLength = _products.length;
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the products
  Widget _buildProductList() {
    List<DataRow> itemRow = [];
    if(_products.length > 0 && _products.isNotEmpty){
      for (int i = 0; i < _products.length; i++){
        Product product = _products[i];
        String stock = '';
        if(product.currentQty! > 10) stock = 'In Stock';
        else if(product.currentQty! > 0) stock = 'Short Stock';
        else stock = 'Out of Stock';
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(product.productName!)),
            DataCell(Text(product.category!.name!)),
            DataCell(Text(product.currentQty.toString())),
            if(_isAdmin) DataCell(Text(Functions.money(product.costPrice!, 'N'))),
            DataCell(Text(Functions.money(product.sellingPrice!, 'N'))),
            DataCell(Text(stock, style: TextStyle(color: _stockColor[stock]))),
            DataCell(TableArrowButton()),
          ],
            onSelectChanged: (value){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InventoryDetail(
                      product: _products[i],
                      allCategories: _categories
                  ),
                ),
              ).then((value) => _refreshProducts());
            },
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _refreshProducts,
        key: _refreshProductKey,
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
                      fontWeight: FontWeight.normal,
                    ),
                    columnSpacing: 15.0,
                    dataRowHeight: 65.0,
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Quantity')),
                      if(_isAdmin) DataColumn(label: Text('Cost Price')),
                      DataColumn(label: Text('Selling Price')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('')),
                    ],
                    rows: itemRow,
                  )
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      );
    }
    else if(_productsLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of products from page 1 similar to [_getAllProducts()]
  Future<Null> _refreshProducts() {
    Future<List<Product>> products = futureValue.getAllProducts(refresh: true);
    return products.then((value) {
      _productsLength = null;
      _products.clear();
      if(!mounted)return;
      setState(() {
        _products.addAll(value);
        _productsLength = _products.length;
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Functions.showErrorMessage(e);
    });
  }

  /** Product Category aspect ***/

  /// A List to hold the all the product categories
  List<Category> _categories = [];

  ///A function to get all the available categories and store them in list[_categories]
  void _getAllCategories() async {
    Future<List<Category>> categories = futureValue.getAllCategories();
    await categories.then((value) {
      if(!mounted)return;
      setState(() => _categories.addAll(value));
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
    _getAllProducts(refresh: true);
    _getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'PRODUCTS'),
        drawer: RefactoredDrawer(title: 'PRODUCTS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Products',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 35),
                Row(
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
                SizedBox(height: 25),
                Expanded(
                  child: _buildProductList(),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

}
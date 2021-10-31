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
import 'package:fumzy/networking/product-datasource.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:fumzy/utils/size-config.dart';
import 'inventory-detail/inventory-detail.dart';

class Inventory extends StatefulWidget {

  static const String id = 'inventory';

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshProductKey = GlobalKey<RefreshIndicatorState>();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshCategoryKey = GlobalKey<RefreshIndicatorState>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _categoryController = TextEditingController();

  bool _showSpinner = false;

  TextEditingController _search = TextEditingController();

  ///[CONTROLLERS] and [KEY] for [ADD PRODUCT DIALOG]
  final _addProductFormKey = GlobalKey<FormState>();
  Category? selectedCategory;
  TextEditingController _productName = TextEditingController();
  TextEditingController _productCategory = TextEditingController();
  TextEditingController _costPrice = TextEditingController();
  TextEditingController _sellingPrice = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _sellersName = TextEditingController();

  Map<String, Color> _stockColor = {
    'Short Stock': Color(0xFFF28301),
    'In Stock': Color(0xFF00AF27),
    'Out of Stock': Color(0xFFF64932),
    '': Colors.transparent
  };

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
            DataCell(Text(Functions.money(product.costPrice!, 'N'))),
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
                    columns: const [
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Cost Price')),
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

  /// An Integer variable to hold the length of [_categories]
  int? _categoriesLength;

  ///A function to get all the available categories and store them in list[_categories]
  void _getAllCategories() async {
    Future<List<Category>> categories = futureValue.getAllCategories();
    await categories.then((value) {
      if(!mounted)return;
      setState(() {
        _categories.addAll(value);
        _categoriesLength = _categories.length;
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the list of all the categories
  Widget _buildCategoryList() {
    List<DataRow> itemRow = [];
    if(_categories.length > 0 && _categories.isNotEmpty){
      for (int i = 0; i < _categories.length; i++){
        Category category = _categories[i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(category.name!)),
            DataCell(Text(_productCategories.containsKey(category.name!)
                ? _productCategories[category.name!].toString()
                : '0')),
            DataCell(
                InkWell(
                  onTap: () {
                    _updateCategory(category);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit ',
                        style: TextStyle(
                          color: Color(0xFF004E92).withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.info,
                        color: Color(0xFF004E92).withOpacity(0.5),
                        size: 15,
                      ),
                    ],
                  ),
                ),
            ),
          ]),
        );
      }
      return RefreshIndicator(
        onRefresh: _refreshCategories,
        key: _refreshCategoryKey,
        color: Color(0xFF004E92),
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
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Products')),
            DataColumn(label: Text('')),
          ],
          rows: itemRow,
        ),
      );
    }
    else if(_categoriesLength == 0) return Container();
    return ShimmerLoader();
  }

  /// Function to refresh list of categories similar to [_getAllCategories()]
  Future<Null> _refreshCategories() {
    Future<List<Category>> categories = futureValue.getAllCategories();
    return categories.then((value) {
      _categoriesLength = null;
      _categories.clear();
      if(!mounted)return;
      setState(() {
        _categories.addAll(value);
        _categoriesLength = _categories.length;
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
    _getAllProducts(refresh: true);
    _getAllCategories();
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
          appBar: buildAppBar(constraints, 'INVENTORY'),
          drawer: RefactoredDrawer(title: 'INVENTORY'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'All Inventory',
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
                                _addNewCategory(constraints);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Add new category',
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
                                _addNewProduct(constraints);
                              },
                              buttonColor: Color(0xFF00509A),
                              width: 160,
                              child: Center(
                                child: Text(
                                  'Add New Product',
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
                  const SizedBox(height: 35),
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
                  SingleChildScrollView(
                    child: Container(
                      width: 257,
                      child: TabBar(
                        labelStyle: kTabBarTextStyle,
                        labelColor: Color(0xFF004E92),
                        unselectedLabelColor: Color(0xFF004E92).withOpacity(0.6),
                        indicatorColor: Color(0xFF004E92),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(child: Text( 'Products', style: kTabBarTextStyle)),
                          Tab(child: Text('Product Categories', style: kTabBarTextStyle)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _productView(),
                        _productCategoriesView(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _productView(){
    return Container(
        decoration: kTableContainer,
        child: _buildProductList()
    );
  }

  Widget _productCategoriesView(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: kTableContainer,
              child: _buildCategoryList()
          ),
          SizedBox(height: 40),
          Button(
            onTap: (){
              print('save changes');
            },
            buttonColor: Color(0xFF00509A),
            width: 160,
            child: Center(
              child: Text(
                'Save Changes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  /// Widget to show the dialog to add [CATEGORY]
  Future<void> _addNewCategory(BoxConstraints constraints) {
    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      barrierDismissible: false,
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
                              'NEW PRODUCT CATEGORY',
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
                                  'Add New Category',
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
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Category',
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
                                          keyboardType: TextInputType.name,
                                          controller: _categoryController,
                                          validator: (value) {
                                            if (value!.isEmpty) return 'Enter category name';
                                            return null;
                                          },
                                          decoration: kTextFieldBorderDecoration.copyWith(
                                            hintText: 'Enter category name',
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
                              ),
                              SizedBox(height: 40),
                              Button(
                                onTap: (){
                                  if(!_showSpinner){
                                    if(_formKey.currentState!.validate()){
                                      _createCategory(setDialogState);
                                    }
                                  }
                                },
                                buttonColor: Color(0xFF00509A),
                                child: Center(
                                  child: _showSpinner
                                      ? CircleProgressIndicator()
                                      : const Text(
                                    'Add Category',
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

  /// function to make api call to [createCategory]
  void _createCategory(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ProductDataSource();
    Map<String, String> body = { 'name': _categoryController.text };
    await api.createCategory(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage('Successfully added category');
      _refreshCategories();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  /// Widget to show the dialog to add [CATEGORY]
  Future<void> _updateCategory(Category category) {
    final formKey = GlobalKey<FormState>();
    TextEditingController editCategoryController = TextEditingController();
    editCategoryController.text = category.name!;

    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      barrierDismissible: false,
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
                                'UPDATE PRODUCT CATEGORY',
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
                                  'Add New Category',
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
                                  '',
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
                                      Text('Category'),
                                      SizedBox(height: 10),
                                      Container(
                                        width: SizeConfig.screenWidth,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.name,
                                          controller: editCategoryController,
                                          validator: (value) {
                                            if (value!.isEmpty) return 'Enter category name';
                                            return null;
                                          },
                                          decoration: kTextFieldBorderDecoration.copyWith(
                                            hintText: 'Enter category name',
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
                              ),
                              SizedBox(height: 40),
                              Button(
                                onTap: (){
                                  if(!_showSpinner){
                                    if(formKey.currentState!.validate()){
                                      _editCategory(setDialogState, editCategoryController.text, category.id!);
                                    }
                                  }
                                },
                                buttonColor: Color(0xFF00509A),
                                child: Center(
                                  child: _showSpinner 
                                      ? CircleProgressIndicator() 
                                      : const Text(
                                    'Update Category',
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

  /// function to make api call to [createCategory]
  void _editCategory(StateSetter setDialogState, String name, String id) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ProductDataSource();
    Map<String, String> body = {'id': id, 'name': name };
    await api.updateCategory(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage('Successfully updated category');
      _refreshCategories();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  ///widget to show the dialog [ADD_NEW_PRODUCT]
  Future<void> _addNewProduct(BoxConstraints constraints) {
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
                            'NEW PRODUCT',
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
                                key: _addProductFormKey,
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
                                  if(_addProductFormKey.currentState!.validate()){
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
                          ],
                        ),
                      ),
                    ),
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
      _refreshProducts();
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}

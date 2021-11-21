import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/bloc/suggestions.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/category.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/model/purchases.dart';
import 'package:fumzy/networking/product-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class InventoryDetail extends StatefulWidget {

  static const String id = 'inventoryDetail';

  final Product? product;

  final List<Category>? allCategories;

  const InventoryDetail({
    Key? key,
    @required this.product,
    @required this.allCategories
  }) : super(key: key);

  @override
  _InventoryDetailState createState() => _InventoryDetailState();
}

class _InventoryDetailState extends State<InventoryDetail> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items
  final GlobalKey<RefreshIndicatorState> _refreshPurchaseKey = GlobalKey<RefreshIndicatorState>();

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

  String _status = '';

  /// A List to hold the all the purchases
  List<Purchase> _purchases = [];

  /// A List to hold all the filtered purchases
  List<Purchase> _filteredPurchases = [];

  /// An Integer variable to hold the length of [_purchases]
  int? _purchasesLength;

  int? _totalPurchaseCount;

  int _purchasePageSize = 1;

  bool _showPurchaseSpinner = false;

  void _checkStatus(){
    if(!mounted)return;
    setState(() {
      if(widget.product!.currentQty! > 10) _status = 'In Stock';
      else if(widget.product!.currentQty! > 0) _status = 'Short Stock';
      else _status = 'Out of Stock';
    });
  }

  void _setProductDetails(){
    if(!mounted)return;
    setState(() {
      selectedCategory = widget.product!.category!;
      _productName.text = widget.product!.productName!;
      _productCategory.text = widget.product!.category!.name!;
      _costPrice.text = widget.product!.costPrice!.toString();
      _sellingPrice.text = widget.product!.sellingPrice!.toString();
      _sellersName.text = widget.product!.sellersName!;
    });
  }

  void _getAllPurchases({bool? refresh}) async {
    Future<Map<String, dynamic>> products = futureValue.getProductPurchases(
        widget.product!.id!, page: _purchasePageSize, limit: 50
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
    Future<Map<String, dynamic>> deliveries = futureValue.getProductPurchases(
        widget.product!.id!, page: _purchasePageSize, limit: 50);
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
    if(_filteredPurchases.isNotEmpty){
      for (int i = 0; i < _filteredPurchases.length; i++){
        Purchase purchase = _filteredPurchases[i];
        itemRow.add(
          DataRow(
            cells: [
              DataCell(Text(Functions.getFormattedDateTime(purchase.product!.createdAt!))),
              DataCell(Text(purchase.product!.sellersName!)),
              DataCell(Text(purchase.quantity!.toString())),
              DataCell(Text(Functions.money(purchase.costPrice!, 'N'))),
              DataCell(Text(Functions.money(purchase.sellingPrice!, 'N'))),
              DataCell(Text(
                Functions.money(purchase.costPrice! * purchase.quantity!, 'N'),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataCell(InkWell(
                onTap: (){
                  _deletePurchasePermanently(purchase.id!);
                },
                child: Icon(
                  Icons.delete,
                  color: Color(0xFFF64932),
                  size: 15,
                ),
              )),
            ],
          ),
        );
      }
      return Container(
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
                    ),
                    columnSpacing: 15.0,
                    dataRowHeight: 65.0,
                    columns: [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Seller')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Unit Cost Price')),
                      DataColumn(label: Text('Unit Selling Price')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('')),
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
              const SizedBox(height: 50),
            ],
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
    _checkStatus();
    _setProductDetails();
    _getAllPurchases(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBarWithBackButton(context, 'INVENTORY'),
        body: NotificationListener<ScrollNotification>(
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
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  IconlyBold.arrowLeftCircle,
                                  size: 19,
                                  color: Color(0xFF004E92).withOpacity(0.5),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  ' Inventory Detail',
                                  style: TextStyle(
                                    color: Color(0xFF75759E),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(_isAdmin)
                            Button(
                              onTap: () => _restockProduct(constraints),
                              buttonColor: Color(0xFF00509A),
                              width: 100,
                              child: Center(
                                child: Text(
                                  'Re-stock',
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
                      // Product info
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: constraints.maxWidth,
                          decoration: kTableContainer,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Info',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF004E92),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              Wrap(
                                runSpacing: 20,
                                spacing: 55,
                                children: [
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Product Name',
                                    widget: Text(
                                      widget.product!.productName!,
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Category',
                                    widget: Text(
                                      widget.product!.category!.name!,
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Quantity',
                                    widget: Text(
                                      widget.product!.currentQty!.toString(),
                                    ),
                                  ),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Status',
                                    widget: Text(
                                      _status,
                                      style: TextStyle(
                                        color: _stockColor[_status]
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Unit Selling Price',
                                    widget: Text(Functions.money(widget.product!.sellingPrice!, 'N')),
                                  ),
                                  SizedBox(width: 40),
                                  ReusableCustomerInfoFields(
                                    tableTitle: 'Last Re-payment Date',
                                    widget: Text(Functions.getFormattedDate(widget.product!.updatedAt!)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      Text(
                        'Restock History',
                        style: TextStyle(
                          color: Color(0xFF00509A),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 19),
                      _buildPurchaseList(),
                      SizedBox(height: 100),
                    ],
                  ),
                )),
          ),
        ),
      )),
    );
  }

  ///widget to show the dialog to update or restock product
  Future<void> _restockProduct(BoxConstraints constraints) {
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
                                              return await Suggestions.getCategorySuggestions(pattern, widget.allCategories!);
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
                                    _updateProduct(setDialogState);
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

  ///function to make api call to [updateProduct]
  void _updateProduct(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ProductDataSource();
    Map<String, dynamic> body = {
      'productName': _productName.text,
      'category': selectedCategory!.id!,
      'costPrice': _costPrice.text,
      'sellingPrice': _sellingPrice.text,
      'initialQty': widget.product!.initialQty!,
      'currentQty': widget.product!.currentQty!,
      'sellersName': _sellersName.text,
    };
    if(_quantity.text.isNotEmpty) {
      body['currentQty'] = widget.product!.currentQty! + double.parse(_quantity.text);
      body['quantity'] = _quantity.text;
    }
      await api.updateProduct(body, widget.product!.id!).then((message) async{
        if(!mounted)return;
        setDialogState((){
          _showSpinner = false;
          Navigator.pop(context);
          Navigator.pop(context);
        });
        Functions.showSuccessMessage(message);
      }).catchError((e){
        if(!mounted)return;
        setDialogState(()=> _showSpinner = false);
        Functions.showErrorMessage(e);
      });
    }

  Future<void> _deletePurchasePermanently(String purchaseId) {
    final formKey = GlobalKey<FormState>();
    TextEditingController reasonController = TextEditingController();
    String newPin = '';
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
                            'DELETE',
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
                              'Are You Sure You want to Delete this Purchase?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF00509A),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
                            child: Text(
                              'This means that this Purchase will no longer be available and it will be removed from your product. This action cannot be undone.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF000428).withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
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
                                          'Reason',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.name,
                                            controller: reasonController,
                                            decoration:
                                            kTextFieldBorderDecoration.copyWith(
                                              hintText: 'Enter reason',
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
                                    SizedBox(height: 30),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Enter your PIN',
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
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                ],
                                                textInputAction: TextInputAction.done,
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
                                                    borderRadius: BorderRadius.all(Radius.circular(3))
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) return 'Enter pin';
                                                  if (newPin.length != 4) return 'Enter a valid 4 digit pin';
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  if (!mounted) return;
                                                  setDialogState(() => newPin = value);
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
                                if(formKey.currentState!.validate()){
                                  _deletePurchase(setDialogState, purchaseId, newPin);
                                }
                              }
                            },
                            buttonColor: Color(0xFFF64932),
                            child: Center(
                              child: _showSpinner
                                  ? CircleProgressIndicator()
                                  : const Text(
                                'Yes, delete',
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
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                        ]),
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

  /// function to make api call to [deletePurchase]
  void _deletePurchase(StateSetter setDialogState, String purchaseId, String pin) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ProductDataSource();
    Map<String, dynamic> body = {
      'id': purchaseId,
      'pin': pin,
    };
    await api.deletePurchase(body, purchaseId).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

  Future<void> _addDebt(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateController = TextEditingController();
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
                      'NEW DEBT',
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
                          'Add Debt',
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
                              ///text field for customer
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Obi Cubana and Sons Limited',
                                style: TextStyle(
                                  color: Color(0xFF1F1F1F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 30),

                              ///field for amount
                              Text(
                                'Amount',
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
                                  controller: amountController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter amount';
                                    }
                                    return null;
                                  },
                                  decoration:
                                  kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              ///field for description
                              Text(
                                'Description',
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
                                  controller: descriptionController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter reference or description';
                                    }
                                    return null;
                                  },
                                  decoration:
                                  kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter description',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              ///field for date
                              Text(
                                'Due Date',
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
                                  controller: dateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter due date';
                                    }
                                    return null;
                                  },
                                  decoration:
                                  kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter due date',
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
                        onTap: () {
                          print('Add Category');
                        },
                        buttonColor: Color(0xFF00509A),
                        child: Center(
                          child: Text(
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

  Future<void> _recordRepayment(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController referenceController = TextEditingController();
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
                      'DEBT REPAYMENT',
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
                          'Debt repayment',
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
                          'You have made additional purchase on credit. Please fill the fields to repay your debt.',
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
                              ///text field for customer
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Obi Cubana and Sons Limited',
                                style: TextStyle(
                                  color: Color(0xFF1F1F1F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 30),

                              ///field for amount
                              Text(
                                'Amount',
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
                                  controller: amountController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter amount';
                                    }
                                    return null;
                                  },
                                  decoration:
                                  kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              ///field for reference
                              Text(
                                'Due Date',
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
                                  controller: referenceController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter due date';
                                    }
                                    return null;
                                  },
                                  decoration:
                                  kTextFieldBorderDecoration.copyWith(
                                    hintText: 'Enter due date',
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
                        onTap: () {
                          print('Add Category');
                        },
                        buttonColor: Color(0xFF00509A),
                        child: Center(
                          child: Text(
                            'Record Repayment',
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

}

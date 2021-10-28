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
import 'package:fumzy/components/reusable-card.dart';
import 'package:fumzy/model/customer-names.dart';
import 'package:fumzy/model/product.dart';
import 'package:fumzy/networking/customer-datasource.dart';
import 'package:fumzy/networking/sales-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

enum PaymentMode { cash, transfer }

PaymentMode? _paymentMode = PaymentMode.cash;

class AddSale extends StatefulWidget {

  static const String id = 'addSale';

  @override
  _AddSaleState createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  final _formKey = GlobalKey<FormState>();

  bool _showSpinner = false;

  /// All sales container added
  int _sales = 0;

  List<Widget> _salesContainers = [];

  List _salesData = [];

  List _realSalesData = [];

  double _totalPrice = 0;

  /// A List to hold the all the products
  List<Product> _products = [];

  void _getAllProducts({bool? refresh}) async {
    Future<List<Product>> allProducts = futureValue.getAllProducts(refresh: refresh);
    allProducts.then((value) {
      _products.addAll(value);
    }).catchError((e){
      print(e);
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
    _getAllProducts(refresh: true);
    _getAllCustomerNames();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            ' Add a new Sale',
                            style: TextStyle(
                              color: Color(0xFF75759E),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 35),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: constraints.maxWidth,
                        decoration: kTableContainer,
                        padding: EdgeInsets.fromLTRB(30, 24, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _salesContainers
                              ),
                            ),
                            SizedBox(height: 60),
                            _salesContainers.length > 0
                                ? Button(
                              onTap: (){
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    _realSalesData.clear();
                                    _totalPrice = 0;
                                    for(int i = 0; i < _salesData.length; i++){
                                      if(_salesContainers[i].runtimeType != Container){
                                        _realSalesData.add(_salesData[i]);
                                      }
                                    }
                                    if(_realSalesData.isNotEmpty){
                                      _realSalesData.forEach((element) {
                                        _totalPrice += element['total'];
                                      });
                                      _checkout(constraints);
                                    }
                                  });
                                }
                              },
                              buttonColor: Color(0xFF00509A),
                              child: Center(
                                child: Text(
                                  'Continue to Checkout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _sales += 1;
                _salesData.add({});
                _buildExtraProduct(_sales);
              });
            },
            backgroundColor: Color(0xFF004E92),
            tooltip: 'Add another product',
            child: Center(
              child: Icon(
                Icons.add,
                color: Color(0xFFFFFFFF)
              ),
            ),
          ),
        )),
      ),
    );
  }

  void _buildExtraProduct(int index){
    Product? selectedProduct;
    TextEditingController product = TextEditingController();
    TextEditingController sellingPrice = TextEditingController();
    TextEditingController quantity = TextEditingController();
    TextEditingController amount = TextEditingController();
    _salesData[index - 1]['total'] = '0';
    _salesContainers.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Wrap(
            runSpacing: 20,
            spacing: 15,
            children: [
              ReusableCustomerInfoFields(
                tableTitle: 'Product Name',
                widget: Container(
                  width: 300,
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: product,
                      decoration: kTextFieldBorderDecoration.copyWith(
                        hintText: 'Product',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await Suggestions.getProductSuggestions(pattern, _products);
                    },
                    itemBuilder: (context, Product suggestion) {
                      return ListTile(title: Text(suggestion.productName!));
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    validator: (value) {
                      if (value!.isEmpty && selectedProduct == null) {
                        return 'Select Product';
                      }
                      return null;
                    },
                    onSuggestionSelected: (Product suggestion) {
                      if (!mounted) return;
                      setState(() {
                        selectedProduct = suggestion;
                        product.text = suggestion.productName!;
                        _salesData[index - 1]['product'] = suggestion;
                        sellingPrice.text = suggestion.sellingPrice!.toString();
                        _salesData[index - 1]['sellingPrice'] = sellingPrice.text;
                      });
                    },
                  ),
                ),
              ),
              ReusableCustomerInfoFields(
                tableTitle: 'Selling Price',
                widget: Container(
                  width: 67,
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
                    controller: sellingPrice,
                    onChanged: (value){
                      _salesData[index - 1]['sellingPrice'] = value;
                      if(quantity.text.isNotEmpty){
                        amount.text = (double.parse(sellingPrice.text) * double.parse(value)).toString();
                        _salesData[index - 1]['total'] = double.parse(amount.text);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter selling price';
                      return null;
                    },
                    decoration: kTextFieldBorderDecoration.copyWith(
                      hintText: '00',
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              ReusableCustomerInfoFields(
                tableTitle: 'Quantity',
                widget: Container(
                  width: 67,
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    controller: quantity,
                    onChanged: (value){
                      if(!mounted)return;
                      setState(() {
                        _salesData[index - 1]['quantity'] = value;
                        if(sellingPrice.text.isNotEmpty){
                          try{
                            double total = double.parse(sellingPrice.text) * double.parse(value);
                            amount.text = Functions.money(total, 'N');
                            _salesData[index - 1]['total'] = total;
                          } catch(e){
                            print(e);
                            amount.text = 'N0.0';
                            _salesData[index - 1]['total'] = 0.0;
                          }
                        }
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter quantity';
                      if(selectedProduct != null) {
                        if(selectedProduct!.currentQty! < double.parse(value)){
                          return 'You don\'t have up to $value ${selectedProduct!.productName}';
                        }
                      }
                      return null;
                    },
                    decoration: kTextFieldBorderDecoration.copyWith(
                      hintText: '0',
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              ReusableCustomerInfoFields(
                tableTitle: 'Amount',
                widget: Container(
                  width: 100,
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    controller: amount,
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter total';
                      return null;
                    },
                    decoration: kTextFieldBorderDecoration.copyWith(
                      hintText: 'N0.0',
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    _salesContainers.removeAt(index - 1);
                    _salesContainers.insert(index - 1, Container());
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      Icons.remove_circle,
                      color: Color(0xFFFF2A52),
                      size: 16
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  List<String> paymentStatus = [
    "Fully Paid",
    "Part Paid",
    "Credit",
  ];

  Future<void> _checkout(BoxConstraints constraints) {
    final formKey = GlobalKey<FormState>();
    TextEditingController discount = TextEditingController();
    CustomerName? selectedCustomer;
    TextEditingController customer = TextEditingController();
    TextEditingController amountPaid = TextEditingController();
    amountPaid.text = _totalPrice.toString();
    TextEditingController dueDate = TextEditingController();
    DateTime? dueDateTime;

    String? selectedPaymentStatus = 'Fully Paid';

    double totalPayableAmount = _totalPrice;

    double balance = 0;

    setState(() => _showSpinner = false);

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
            return Container(
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
                            'CHECKOUT',
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
                                'Checkout Invoice',
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
                                'You are making a new sale. Please fill the fields to record your sales.',
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
                                    // Total amount
                                    Column(
                                      children: [
                                        Text('Total Amount'),
                                        SizedBox(height: 11),
                                        Text(
                                          Functions.money(_totalPrice, 'N'),
                                          style: TextStyle(
                                            color: Color(0xFF1F1F1F),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Discount
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Discount'),
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
                                            onChanged: (value){
                                              if(!mounted)return;
                                              setDialogState(() {
                                                try{
                                                  totalPayableAmount = _totalPrice - double.parse(value);
                                                } catch(e){
                                                  totalPayableAmount = _totalPrice;
                                                }
                                              });
                                            },
                                            controller: discount,
                                            decoration: kTextFieldBorderDecoration.copyWith(
                                              hintText: 'N Enter discount amount',
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
                                    // Total amount payable
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Amount Payable'),
                                        SizedBox(height: 11),
                                        Text(
                                          Functions.money(totalPayableAmount, 'N'),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Customer
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Customer'),
                                        SizedBox(height: 10),
                                        Container(
                                          width: constraints.maxWidth,
                                          child: TypeAheadFormField(
                                            textFieldConfiguration: TextFieldConfiguration(
                                              controller: customer,
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
                                                customer.text = suggestion.name!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Payment status
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Payment Status'),
                                        SizedBox(height: 10),
                                        Container(
                                          width: constraints.maxWidth,
                                          child: DropdownButtonFormField<String>(
                                            value: selectedPaymentStatus,
                                            onChanged: (value) {
                                              setDialogState(() {
                                                selectedPaymentStatus = value;
                                                if(value == 'Fully Paid'){
                                                  amountPaid.text = _totalPrice.toString();
                                                  balance = 0;
                                                }
                                                else if(value == 'Part Paid'){
                                                  amountPaid.text = '0';
                                                  balance = _totalPrice;
                                                }
                                                if(value == 'Credit'){
                                                  amountPaid.text = '0';
                                                  balance = _totalPrice;
                                                }
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
                                            hint: Text(
                                              'Select payment',
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(0.5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            decoration: kTextFieldBorderDecoration.copyWith(
                                              contentPadding: EdgeInsets.all(10),
                                            ),
                                            items: paymentStatus.map((value) {
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
                                    // Amount paid
                                    Row(
                                        children: [
                                          // Amount paid
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Amount Paid'),
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
                                                    readOnly: selectedPaymentStatus == 'Fully Paid' ? true : false,
                                                    controller: amountPaid,
                                                    onChanged: (value) {
                                                      setDialogState(() {
                                                        if(value != 'Fully Paid'){
                                                          try{
                                                            balance = _totalPrice - double.parse(value);
                                                          } catch(e){
                                                            balance = 0;
                                                          }
                                                        }
                                                        else {
                                                          balance = 0;
                                                        }
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Enter amount paid';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: kTextFieldBorderDecoration.copyWith(
                                                      hintText: 'N 00,000',
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
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 15.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Balance'),
                                                  SizedBox(height: 14),
                                                  Text(
                                                    Functions.money(balance, 'N'),
                                                    style: TextStyle(
                                                      color: Color(0xFF1F1F1F),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]
                                    ),
                                    SizedBox(height: 20),
                                    // Balance due date
                                    selectedPaymentStatus != 'Fully Paid'
                                        ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Balance Due Date'),
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
                                              if (value!.isEmpty && selectedPaymentStatus != 'Fully Paid') {
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
                                        SizedBox(height: 20),
                                      ],
                                    )
                                        : Container(),
                                    // Mode of payment
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Amount'),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Cash
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Radio<PaymentMode>(
                                                  value: PaymentMode.cash,
                                                  activeColor: Color(0xFF00509A),
                                                  groupValue: _paymentMode,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                  ),
                                                  onChanged: (PaymentMode? value) {
                                                    setDialogState(() { _paymentMode = value; });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    'Cash',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 15),
                                            // Transfer
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Radio<PaymentMode>(
                                                  value: PaymentMode.transfer,
                                                  activeColor: Color(0xFF00509A),
                                                  groupValue: _paymentMode,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                  ),
                                                  onChanged: (PaymentMode? value) {
                                                    setDialogState(() { _paymentMode = value; });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    'Transfer',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
                                  Map<String, dynamic> body = {};
                                  if(selectedCustomer == null){
                                    body['name'] = customer.text;
                                  }
                                  else {
                                    body['id'] = selectedCustomer!.id;
                                    body['name'] = selectedCustomer!.name;
                                  }

                                  List<dynamic> reports = [];
                                  for(int i = 0; i < _realSalesData.length; i++){
                                    reports.add(
                                        {
                                          'quantity': _realSalesData[i]['quantity'],
                                          'productName': _realSalesData[i]['product'].productName,
                                          'costPrice': _realSalesData[i]['product'].costPrice,
                                          'unitPrice': _realSalesData[i]['sellingPrice'],
                                          'totalPrice': _realSalesData[i]['total']
                                        }
                                    );
                                  }
                                  body['report'] = reports;
                                  body['totalAmount'] = _totalPrice;
                                  body['paymentMade'] = amountPaid.text;
                                  body['paid'] = selectedPaymentStatus == 'Fully Paid' ? true : false;
                                  body['soldAt'] = DateTime.now().toIso8601String();
                                  if(selectedPaymentStatus == 'Fully Paid'){
                                    body['paymentReceivedAt'] = DateTime.now().toIso8601String();
                                  }
                                  else {
                                    body['dueDate'] = dueDateTime!.toIso8601String();
                                  }
                                  String mode = _paymentMode == PaymentMode.cash
                                      ? 'Cash' : 'Transfer' ;
                                  if(!mounted)return;
                                  setDialogState(() => _showSpinner = true);
                                  if(selectedCustomer == null){
                                    _addSales(mode, customer.text, ()=> _addNewCustomer(body, setDialogState));
                                  }
                                  else {
                                    _addSales(mode, selectedCustomer!.name!, ()=> _addNewReportsCustomer(body, setDialogState));
                                  }
                                }
                              },
                              buttonColor: Color(0xFF00509A),
                              child: Center(
                                child: _showSpinner
                                    ? CircleProgressIndicator()
                                    : Text(
                                  'Generate Invoice',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 130,
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _generateInvoice() {
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
                      'DOWNLOAD AND SHARE INVOICE',
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
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 27),
                        Container(
                          width: 67,
                          height: 67,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00CFA0).withOpacity(0.15),
                          ),
                          child: Icon(
                            Icons.done_rounded,
                            color: Color(0xFF00CFA0),
                            size: 45,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 22),
                          child: Text(
                            'Transaction Invoice Generated Successfully',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF00509A),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 19.0),
                          child: Text(
                            'Your transaction invoice has been generated. You can download or share with customers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF000428).withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 45),
                        ReusableCard(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(12, 17, 21, 27),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 62,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/pdf-image.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Invoice' + 023345.toString() + '.pdf',
                                      style: TextStyle(
                                        color: Color(0xFF002338),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '34MB',
                                      style: TextStyle(
                                        color: Color(0xFF002338).withOpacity(0.3),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        Button(
                          onTap: (){
                            print("Download");
                          },
                          buttonColor: Color(0xFF00509A),
                          child: Center(
                            child: Text(
                              'Download',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            print("share");
                          },
                          child: Container(
                            width: 130,
                            child: Center(
                              child: Text(
                                'Share',
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
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addSales(String paymentMode, String customer, Function next) async{
    var api = SalesDataSource();
    for(int i = 0; i < _realSalesData.length; i++){
      Map<String, dynamic> body = {
        'customerName': customer,
        'quantity': _realSalesData[i]['quantity'],
        'productName': _realSalesData[i]['product'].productName,
        'costPrice': _realSalesData[i]['product'].costPrice,
        'unitPrice': _realSalesData[i]['sellingPrice'],
        'totalPrice': _realSalesData[i]['total'],
        "paymentMode": paymentMode
      };
      await api.addSales(body).then((message) async{
        print('saved');
      }).catchError((e){
        if(!mounted)return;
        print(e);
        Functions.showErrorMessage(e);
      });
    }
    await next();
  }

  Future<void> _addNewCustomer(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.addNewCustomer(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage('Successfully added sales');
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  Future<void> _addNewReportsCustomer(Map<String, dynamic> body, StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = CustomerDataSource();
    await api.addNewReportsCustomer(body).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage('Successfully added sales');
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      print(e);
      Functions.showErrorMessage(e);
    });
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/screens/ReuseableWidgets.dart';

class Inventory extends StatefulWidget {
  static const String id = 'inventory';

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final Color shortStockColor = Color(0xFFF28301);
  final Color inStockColor = Color(0xFF00AF27);
  final Color outOfStockColor = Color(0xFFF64932);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'Inventory'),
        drawer: RefactoredDrawer(),
        body: ListView(children: [
          Container(
            child: Container(
              padding: EdgeInsets.only(
                  top: constraints.maxHeight * 0.07,
                  left: constraints.maxWidth * 0.026,
                  right: constraints.maxWidth * 0.026),
              color: Color(0xFFF7F8F9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Inventory',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _addNewCategory(constraints);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
                                padding: EdgeInsets.all(15),
                                color: Colors.transparent,
                                child: Text(
                                  'Add new category',
                                  style: TextStyle(
                                    color: Color(0xFF00509A),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ), //add new category
                            GestureDetector(
                              onTap: () {
                                print('add new product');
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
                                height: constraints.maxHeight * 0.133,
                                width: constraints.maxWidth * 0.156,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Color(0xFF00509A),
                                ),
                                child: Center(
                                  child: Text(
                                    'Add New Product',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ), //add new product
                          ],
                        ),
                      ],
                    ),
                  ), //all inventory, add new category and add new product
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.125,
                          width: constraints.maxWidth * 0.34,
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27.5),
                          ),
                          child: TextField(
                            textAlign: TextAlign.start,
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
                                color: Colors.black),
                          ),
                        ), //search
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("export table");
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
                                padding: EdgeInsets.all(15),
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.file_download_outlined,
                                      color: Color(0xFF75759E),
                                      size: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        'Export table',
                                        style: TextStyle(
                                          color: Color(0xFF75759E),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("filter");
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: constraints.maxHeight * 0.044),
                                padding: EdgeInsets.all(15),
                                height: constraints.maxHeight * 0.133,
                                width: constraints.maxWidth * 0.131,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFFE2E2EA),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
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
                            ), //filter
                          ],
                        ), //export table and filter
                      ],
                    ),
                  ), //search, export and filter
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 350.0,
                          child: TabBar(
                            tabs: [
                              Tab(
                                child: Text(
                                  'Products',
                                  style: kTabBarTextStyle,
                                ),
                              ), //account tab name
                              Tab(
                                child: Text(
                                  'Product Categories',
                                  style: kTabBarTextStyle,
                                ),
                              ), //security tab name
                            ],
                          ),
                        ), //tabBar
                        Container(
                          height: constraints.maxHeight,
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.05),
                          child: TabBarView(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                decoration: kTableContainer,
                                child: ProductsTableDetails(
                                    inStockColor: inStockColor,
                                    outOfStockColor: outOfStockColor,
                                    shortStockColor: shortStockColor),
                              ),
                              //tabView for product details
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: constraints.maxHeight * 0.76,
                                      width: constraints.maxWidth * 0.48,
                                      decoration: kTableContainer,
                                      child: ProuctCatergoriesTable(),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print('save changes');
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: constraints.maxHeight * 0.06),
                                        height: constraints.maxHeight * 0.133,
                                        width: constraints.maxWidth * 0.156,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          color: Color(0xFF00509A),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Save Changes',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ), //save changes
                                  ],
                                ),
                              ),
                              //tabView for the product categories details and save changes button
                            ],
                          ),
                        ), //tabView// details
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      )),
    );
  }

  Future<void> _addNewCategory(BoxConstraints constraints) {
    return showDialog(
      context: context,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFFFFF),
        ),
        margin: EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(34, 30, 34, 27),
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
                margin: EdgeInsets.only(
                  top: constraints.maxHeight * 0.019,
                  bottom: constraints.maxHeight * 0.045,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.02,
                            bottom: constraints.maxHeight * 0.02),
                        height: constraints.maxHeight * 0.07,
                        width: constraints.maxWidth,
                        padding:
                            EdgeInsets.only(top: 14.0, bottom: 4.0, left: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF7BBBE5),
                          ),
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Enter category name',
                            hintStyle: TextStyle(
                              color: Color(0xFF818181),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 17.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ), //username
              GestureDetector(
                onTap: () {
                  print("add category");
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: constraints.maxHeight * 0.045),
                  height: constraints.maxHeight * 0.063,
                  width: constraints.maxWidth * 0.476,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Color(0xFF00509A),
                  ),
                  child: Center(
                    child: Text(
                      'Add Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
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
              ), //No, cancel
              //add staff
            ],
          ),
        ),
      ),
    );
  }
}

class ProuctCatergoriesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: TextStyle(
        color: Color(0xFF75759E),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      dataTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 13,
        //fontWeight: FontWeight.w400,
      ),
      columnSpacing: 5.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Products')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Obi Cubana and ')),
          DataCell(Text('500')),
          DataCell(ReusableDeleteText()),
        ]),
        DataRow(cells: [
          DataCell(Text('Obi Cubana ')),
          DataCell(Text('330')),
          DataCell(ReusableDeleteText()),
        ]),
      ],
    );
  }
}

class ReusableDeleteText extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('Delete');
      },
      child: Row(
          children: [
            Text(
              'Delete ',
              style: TextStyle(
                color: Color(0xFFF64932),
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.delete,
              color: Color(0xFFF64932),
              size: 15,
            ),
          ],
        ),
    );
  }
}

class ProductsTableDetails extends StatelessWidget {
  ProductsTableDetails({
    required this.inStockColor,
    required this.outOfStockColor,
    required this.shortStockColor,
  });

  final Color inStockColor;
  final Color outOfStockColor;
  final Color shortStockColor;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: TextStyle(
        color: Color(0xFF75759E),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      dataTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 13,
        //fontWeight: FontWeight.w400,
      ),
      columnSpacing: 3.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text(' Product Name')),
        DataColumn(label: Text('Caategory')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Unit Cost Price')),
        DataColumn(label: Text('Unit Selling Price')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('500')),
          DataCell(Text('N50,000')),
          DataCell(Text('N55,000')),
          DataCell(Text('In Stock', style: TextStyle(color: inStockColor))),
          DataCell(ReusableTableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('3')),
          DataCell(Text('N50,000')),
          DataCell(Text('N55,000')),
          DataCell(
              Text('Out Of Stock', style: TextStyle(color: outOfStockColor))),
          DataCell(ReusableTableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('500')),
          DataCell(Text('N50,000')),
          DataCell(Text('N55,000')),
          DataCell(Text('In Stock', style: TextStyle(color: inStockColor))),
          DataCell(ReusableTableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('10')),
          DataCell(Text('N50,000')),
          DataCell(Text('N55,000')),
          DataCell(
              Text('Short Stock', style: TextStyle(color: shortStockColor))),
          DataCell(ReusableTableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('500')),
          DataCell(Text('N50,000')),
          DataCell(Text('N55,000')),
          DataCell(Text('In Stock', style: TextStyle(color: inStockColor))),
          DataCell(ReusableTableArrowButton()),
        ]),
      ],
    );
  }
}

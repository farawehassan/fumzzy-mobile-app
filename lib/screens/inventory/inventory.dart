import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/networking/user-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'product-categories.dart';
import 'products.dart';

class Inventory extends StatefulWidget {

  static const String id = 'inventory';

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  TextEditingController _search = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _categoryController = TextEditingController();

  bool _showSpinner = false;

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
                                _addNewCategory(constraints,CircleProgressIndicator());
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
                                print('add new product');
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
                          Tab(
                            child: Text(
                              'Products',
                              style: kTabBarTextStyle,
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Product Categories',
                              style: kTabBarTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Products(),
                        ProductCategories(),
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

  /// Widget to show the dialog to add [CATEGORY]
  Future<void> _addNewCategory(BoxConstraints constraints, Widget circleSpinnerIndicator) {
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
                                  child: _showSpinner ?
                                  circleSpinnerIndicator :
                                  const Text(
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

  ///function to make api call to [CREATE_EXPENSE]
  void _createCategory(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = UserDataSource();
    Map<String, String> body = {
      "name": _categoryController.text,
    };
    await api.createCategory(body).then((message) async{
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






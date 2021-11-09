import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/model/sales.dart';
import 'package:fumzy/networking/sales-datasource.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SalesInfo extends StatefulWidget {

  static const String id = 'salesInfo';

  final Sale? sale;

  const SalesInfo({
    Key? key,
    @required this.sale,
  }) : super(key: key);

  @override
  _SalesInfoState createState() => _SalesInfoState();
}

class _SalesInfoState extends State<SalesInfo> {
  
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _showSpinner,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004E92)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => (Scaffold(
          appBar: buildAppBarWithBackButton(context, 'TRANSACTIONS'),
          drawer: RefactoredDrawer(title: 'TRANSACTIONS'),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // inventory detail
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              IconlyBold.arrowLeftCircle,
                              size: 19,
                              color: Color(0xFF004E92).withOpacity(0.5),
                            ),
                          ),
                          Text(
                            ' Transactions’s Details',
                            style: TextStyle(
                              color: Color(0xFF75759E),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.7,
                            ),
                          ),
                        ],
                      ),
                      // delete
                      InkWell(
                        onTap: ()=> _deleteReport(),
                        child: Row(
                          children: [
                            Text(
                              'Delete ',
                              style: TextStyle(
                                color: Color(0xFFF64932),
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.delete,
                              color: Color(0xFFF64932),
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Container(
                    width: constraints.maxWidth,
                    decoration: kTableContainer,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sales Info',
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
                          runSpacing: 14,
                          spacing: 40,
                          children: [
                            ReusableCustomerInfoFields(
                              tableTitle: 'Invoice No',
                              widget: Text(widget.sale!.id!.substring(0, 8)),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Product Name',
                              widget: Text(widget.sale!.productName!),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Quantity',
                              widget: Text('${widget.sale!.quantity!}'),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Date',
                              widget: Text(
                                Functions.getFormattedDateTime(widget.sale!.createdAt!),
                              ),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Amount',
                              widget: Text(
                                  Functions.money(widget.sale!.totalPrice!, 'N'),
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Wrap(
                          runSpacing: 20,
                          spacing: 40,
                          children: [
                            ReusableCustomerInfoFields(
                                tableTitle: 'Mode of Payment',
                                widget: Text(widget.sale!.paymentMode!)),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Customer Name',
                              widget: Text(widget.sale!.customerName!),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Unit cost Price',
                              widget: Text(Functions.money(widget.sale!.costPrice!, 'N')),
                            ),
                            ReusableCustomerInfoFields(
                              tableTitle: 'Unit Selling Price',
                              widget: Text(Functions.money(widget.sale!.unitPrice!, 'N')),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        ReusableCustomerInfoFields(
                          tableTitle: 'Staff',
                          widget: Text(widget.sale!.staff ?? 'Admin'),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        )),
      ),
    );
  }

  Future<void> _deleteReport(){
    return showDialog(
      context: context,
      builder: (_) => Platform.isIOS
          ? CupertinoAlertDialog(
        title: const Text('Delete Sales'),
        content: const Text('Are you sure you want to delete this sales. This means that you will no longer find them in your list of sales and the product sold will be added to the inventory back'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
              _deleteSales();
            },
            child: const Text('YES'),
          ),
          CupertinoDialogAction(
            onPressed: ()=> Navigator.pop(context),
            isDefaultAction: true,
            child: const Text('NO'),
          )
        ],
      )
          : AlertDialog(
        title: const Text('Delete Sales'),
        content: const Text('Are you sure you want to delete this sales. This means that you will no longer find them in your list of sales and the product sold will be added to the inventory back'),
        actions: [
          TextButton(
            child: const Text('YES'),
            onPressed: () {
              Navigator.pop(context);
              _deleteSales();
            },
          ),
          TextButton(
            child: const Text('NO'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  /// function to make api call to [deleteSales] with the help of
  /// [SalesDataSource]
  void _deleteSales() async{
    if(!mounted)return;
    setState(() => _showSpinner = true);
    Map<String, dynamic> body = {
      'id': widget.sale!.id!,
      'customerName': widget.sale!.customerName!,
      'productName': widget.sale!.productName!
    };
    var api = SalesDataSource();
    await api.deleteSales(body).then((message) async{
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      Functions.showSuccessMessage(message);
      Navigator.pop(context);
    }).catchError((e){
      if(!mounted)return;
      setState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}

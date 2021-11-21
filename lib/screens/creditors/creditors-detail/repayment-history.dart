import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/bloc/future-values.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/components/shimmer-loader.dart';
import 'package:fumzy/model/creditor-report.dart';
import 'package:fumzy/model/creditor.dart';
import 'package:fumzy/model/repayment-history.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';

class CreditorRepaymentHistory extends StatefulWidget {

  final Creditor? creditor;

  final CreditorReport? report;

  const CreditorRepaymentHistory({
    Key? key,
    @required this.creditor,
    @required this.report,
  }) : super(key: key);

  @override
  _CreditorRepaymentHistoryState createState() => _CreditorRepaymentHistoryState();
}

class _CreditorRepaymentHistoryState extends State<CreditorRepaymentHistory> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A List to hold the all the repayment history
  List<RepaymentHistory> _repaymentHistory = [];

  /// An Integer variable to hold the length of [_repaymentHistory]
  int? _repaymentHistoryLength;

  ///A function to get the report repayment history and store them in list[_repaymentHistory]
  void _getRepaymentHistory() async {
    Future<List<RepaymentHistory>> history = futureValue.getRepaymentHistory(widget.creditor!.id!, widget.report!.id!);
    await history.then((value) {
      if(!mounted)return;
      setState(() {
        _repaymentHistory.addAll(value);
        _repaymentHistoryLength = _repaymentHistory.length;
      });
    }).catchError((e){
      print(e);
      Functions.showErrorMessage(e);
    });
  }

  /// A function to build the repayment history
  Widget _buildRepaymentHistory() {
    List<DataRow> itemRow = [];
    if(_repaymentHistory.isNotEmpty){
      for (int i = 0; i < _repaymentHistory.length; i++){
        RepaymentHistory history = _repaymentHistory[i];
        itemRow.add(
          DataRow(cells: [
            DataCell(Text(Functions.getFormattedDateTime(history.createdAt!))),
            DataCell(Text(Functions.money(history.amount!, 'N'))),
          ]),
        );
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Repayment History',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF004E92),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: kTableContainer,
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
                        columnSpacing: 35.0,
                        dataRowHeight: 65.0,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Amount')),
                        ],
                        rows: itemRow,
                      )
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    }
    else if(_repaymentHistoryLength == 0) return Container();
    return ShimmerLoader();
  }

  @override
  void initState() {
    super.initState();
    _getRepaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBarWithBackButton(context, 'CREDITOR'),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Creditor detail
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
                                ' Credit Details',
                                style: TextStyle(
                                  color: Color(0xFF75759E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.7,
                                ),
                              ),
                            ],
                          ),
                          Container()
                        ],
                      ),
                      SizedBox(height: 35),
                      // creditors info
                      Container(
                        width: constraints.maxWidth,
                        decoration: kTableContainer,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Creditors’s Info',
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
                                  tableTitle: 'Name',
                                  widget: Text(widget.creditor!.name!),
                                ),
                                ReusableCustomerInfoFields(
                                  tableTitle: 'Total Amount',
                                  widget: Text(
                                    Functions.money(widget.report!.amount!, 'N'),
                                  ),
                                ),
                                ReusableCustomerInfoFields(
                                  tableTitle: 'Amount Paid',
                                  widget: Text(
                                    Functions.money(widget.report!.paymentMade!, 'N'),
                                  ),
                                ),
                                ReusableCustomerInfoFields(
                                  tableTitle: 'Balance',
                                  widget: Text(
                                    Functions.money(widget.report!.amount! - widget.report!.paymentMade!, 'N'),
                                  ),
                                ),
                                ReusableCustomerInfoFields(
                                  tableTitle: 'Description',
                                  widget: Text(widget.report!.description!),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 35),
                    ],
                  ),
                  SizedBox(height: 25),
                  _buildRepaymentHistory(),
                ],
              ),
            )
        ),
      )),
    );
  }

}

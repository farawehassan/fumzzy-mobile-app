import 'package:flutter/material.dart';
import 'package:fumzy/utils/constant-styles.dart';

class RepaymentHistory extends StatefulWidget {

  const RepaymentHistory({Key? key}) : super(key: key);

  @override
  _RepaymentHistoryState createState() => _RepaymentHistoryState();
}

class _RepaymentHistoryState extends State<RepaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Container(
            decoration: kTableContainer,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                columns: [
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Reference')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('N30,000')),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text('Invoice 022341')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('N25,000')),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text('Purchase of XX goods before the app')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('N120,000')),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text('Invoice 022341')),
                  ]),
                ],
              ),
            )),
      ),
    );
  }
}

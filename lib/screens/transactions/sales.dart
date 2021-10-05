import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';
import 'package:fumzy/utils/constant-styles.dart';

class Sales extends StatefulWidget {

  const Sales({Key? key}) : super(key: key);

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {

  final Color partPaidColor = Color(0xFFF28301);

  final Color creditColor = Color(0xFFF64932);

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
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Payment Status')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Balance')),
                DataColumn(label: Text('')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('100')),
                  DataCell(Text('Fully Paid')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('-')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('100')),
                  DataCell(Row(
                    children: [
                      Text('Credit'),
                      SizedBox(width: 6),
                      CreditIndicator(),
                    ],
                  )),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N50,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('100')),
                  DataCell(Row(
                    children: [
                      Text('Part-Paid'),
                      SizedBox(width: 6),
                      PartPaidIndicator()
                    ],
                  )),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N2,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('100')),
                  DataCell(Text('Fully Paid')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('-')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('100')),
                  DataCell(Row(
                    children: [
                      Text('Credit'),
                      SizedBox(width: 6),
                      CreditIndicator(),
                    ],
                  )),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N50,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('100')),
                  DataCell(Row(
                    children: [
                      Text('Part-Paid'),
                      SizedBox(width: 6),
                      PartPaidIndicator()
                    ],
                  )),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N2,000')),
                  DataCell(TableArrowButton()),
                ]),
              ],
            ),
          )
        ),
      ),
    );
  }
}

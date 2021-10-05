import 'package:flutter/material.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/components/invoice-pdf-download.dart';

class TotalSales extends StatefulWidget {

  const TotalSales({Key? key}) : super(key: key);

  @override
  _TotalSalesState createState() => _TotalSalesState();
}

class _TotalSalesState extends State<TotalSales> {
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
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Date')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
                    DataCell(Text('Fully Paid')),
                    DataCell(Text('N120,000')),
                    DataCell(Text('23, May\n12:13pm')),
                  ]
                  ),
                  DataRow(cells: [
                    DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
                    DataCell(Row(
                      children: [
                        Text('Part-Paid'),
                        SizedBox(width: 6),
                        PartPaidIndicator(),
                      ],
                    )),
                    DataCell(Text('N120,000')),
                    DataCell(Text('23, May\n12:13pm')),
                  ]
                  ),
                  DataRow(cells: [
                    DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
                    DataCell(Row(
                      children: [
                        Text('Credit'),
                        SizedBox(width: 6),
                        CreditIndicator(),
                      ],
                    )),
                    DataCell(Text('N120,000')),
                    DataCell(Text('23, May\n12:13pm')),
                  ]
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}

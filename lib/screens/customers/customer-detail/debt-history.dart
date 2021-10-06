import 'package:flutter/material.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/components/invoice-pdf-download.dart';

class DebtHistory extends StatefulWidget {

  const DebtHistory({Key? key}) : super(key: key);

  @override
  _DebtHistoryState createState() => _DebtHistoryState();
}

class _DebtHistoryState extends State<DebtHistory> {

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
                  DataColumn(label: Text('Total Sales')),
                  DataColumn(label: Text('Invoice/Reference')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Due Date')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('N120,000')),
                    DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text(
                      '23, May 2021',
                      style: TextStyle(
                        color: Color(0xFFF64932),
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('N25,000')),
                    DataCell(Text('Purchase of XX goods before the app')),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text(
                      '23, May 2021',
                      style: TextStyle(
                        color: Color(0xFFF64932),
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('N12,000')),
                    DataCell(ReusableDownloadPdf(invoiceNo: 022341)),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text(
                      '23, May 2021',
                      style: TextStyle(
                        color: Color(0xFFF64932),
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('N50,000')),
                    DataCell(Text('Purchase of XX goods before the app')),
                    DataCell(Text('23, May\n12:13pm')),
                    DataCell(Text(
                      '23, May 2021',
                      style: TextStyle(
                        color: Color(0xFFF64932),
                      ),
                    )),
                  ]),
                ],
              ),
            )),
      ),
    );
  }
}

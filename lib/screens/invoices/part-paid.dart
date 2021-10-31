import 'package:flutter/material.dart';
import 'package:fumzy/components/invoice-pdf-download.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';
import 'package:fumzy/utils/constant-styles.dart';

class PartPaidInvoicesDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: kTableContainer,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: TextStyle(
              color: Color(0xFF75759E),
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            dataTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            columnSpacing: 15.0,
            dataRowHeight: 65.0,
            columns: [
              DataColumn(label: Text('Invoice No')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Balance')),
              DataColumn(label: Text('Due')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(ReusableDownloadPdf(invoiceNo: '022341')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Part-Paid' + '  '),
                    PartPaidIndicator(),
                  ],
                )),
                DataCell(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('23, May 2021'),
                    Text(
                      '12:30pm',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                )),
                DataCell(Text('Obi Cubana and Sons Limited')),
                DataCell(Text('N20,000')),
                DataCell(Text('23, May 2021',
                    style: TextStyle(color: Color(0xFFF64932)))),
              ]),
              DataRow(cells: [
                DataCell(ReusableDownloadPdf(invoiceNo: '022341')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Part-Paid' + '  '),
                    PartPaidIndicator(),
                  ],
                )),
                DataCell(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('23, May 2021'),
                    Text(
                      '12:30pm',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                )),
                DataCell(Text('Obi Cubana and Sons Limited')),
                DataCell(Text('N20,000')),
                DataCell(Text('23, May 2021',
                    style: TextStyle(color: Color(0xFFF64932)))),
              ]),
              DataRow(cells: [
                DataCell(ReusableDownloadPdf(invoiceNo: '022341')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Part-Paid' + '  '),
                    PartPaidIndicator(),
                  ],
                )),
                DataCell(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('23, May 2021'),
                    Text(
                      '12:30pm',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                )),
                DataCell(Text('Obi Cubana and Sons Limited')),
                DataCell(Text('N20,000')),
                DataCell(Text(
                    '23, May 2021',
                    style: TextStyle(
                      color: Color(0xFFF64932),
                    ))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

}
//TODO: when fetching data from the api, this table is sorted by the part paid status only.

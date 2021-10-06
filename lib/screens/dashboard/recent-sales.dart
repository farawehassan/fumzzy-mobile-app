import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';

class RecentSalesTable extends StatelessWidget {

  const RecentSalesTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
        DataColumn(label: Text('Invoice')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Payment Status')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Balance')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('022341'),
              Text(
                '23, May 2021- ' + '12:13pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('100')),
          DataCell(Text('Fully Paid')),
          DataCell(Text('N' + '50,000')),
          DataCell(Text('-')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('022341'),
              Text(
                '23, May 2021- ' + '12:13pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('100')),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Credit'+'  '),
              CreditIndicator(),
            ],
          )),
          DataCell(Text('N' + '50,000')),
          DataCell(Text('N' + '50,000')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('022341'),
              Text(
                '23, May 2021- ' + '12:13pm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('100')),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Part-Paid'+'  '),
              PartPaidIndicator(),
            ],
          )),
          DataCell(Text('N' + '12,000')),
          DataCell(Text('N' + '2,000')),
          DataCell(TableArrowButton()),
        ]),
      ],
    );
  }

}
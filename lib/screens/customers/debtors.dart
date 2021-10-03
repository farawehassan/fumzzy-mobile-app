import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/utils/constant-styles.dart';

class Debtors extends StatefulWidget {
  const Debtors({Key? key}) : super(key: key);

  @override
  _DebtorsState createState() => _DebtorsState();
}

class _DebtorsState extends State<Debtors> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: kTableContainer,
        child: DebtorsTableDetails(),
      ),
    );
  }
}

class DebtorsTableDetails extends StatelessWidget {
  final Color dueInvoiceColor = Color(0xFFF64932);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          DataColumn(label: Text('Total Debts')),
          DataColumn(label: Text('Invoices')),
          DataColumn(label: Text(' References')),
          DataColumn(label: Text(' Last Re-payment Date')),
          DataColumn(label: Text('')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N' + '120,000')),
            DataCell(Text(
              '2' + ' Invoice(s) due',
              style: TextStyle(color: dueInvoiceColor),
            )),
            DataCell(Text('-')),
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
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N' + '120,000')),
            DataCell(Text('-')),
            DataCell(Text('1' + ' Reference(s)')),
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
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N' + '120,000')),
            DataCell(Text(
              '1' + 'Invoice(s) due',
              style: TextStyle(color: dueInvoiceColor),
            )),
            DataCell(Text('3' + ' Reference(s)')),
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
            DataCell(TableArrowButton()),
          ]),
        ],
      ),
    );
  }
}

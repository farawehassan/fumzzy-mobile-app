import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';

class RecentPurchaseTable extends StatelessWidget {

  const RecentPurchaseTable({
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
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-alcoholic drink 300cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text('Sumec Generator 35”')),
          DataCell(Text('Appliances')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Indomie super pack 60cl')),
          DataCell(Text('Foods')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
        DataRow(cells: [
          DataCell(Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text('23, May 2021'),
              Text(
                '12:30pm',
                style: TextStyle(
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
          DataCell(Text(
              'Carton of Smirnoff non-acholic drink 500cl')),
          DataCell(Text('Drinks')),
          DataCell(Text('200')),
          DataCell(TableArrowButton()),
        ]),
      ],
    );
  }

}
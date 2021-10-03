import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/utils/constant-styles.dart';

class All extends StatefulWidget {

  const All({Key? key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: kTableContainer,
        child: AllTableDetails(),
      ),
    );
  }

}

class AllTableDetails extends StatelessWidget {
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
          DataColumn(label: Text('Total Sales')),
          DataColumn(label: Text('Volume')),
          DataColumn(label: Text('Onboard Date')),
          DataColumn(label: Text('')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N'+'1,200,000')),
            DataCell(Text('10')),
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
            DataCell(Text('N'+'1,200,000')),
            DataCell(Text('10')),
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
            DataCell(Text('N'+'1,200,000')),
            DataCell(Text('10')),
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
            DataCell(Text('N'+'1,200,000')),
            DataCell(Text('10')),
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

import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'purchase-info.dart';

class Purchases extends StatefulWidget {
  const Purchases({Key? key}) : super(key: key);

  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
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
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Cost Price')),
                DataColumn(label: Text('Selling Price')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PurchaseInfo.id);
                    },
                    child: TableArrowButton(),
                  )),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
                DataRow(cells: [
                  DataCell(Text('23, May\n12:130pm')),
                  DataCell(Text('Carton of Smirnoff non-acholic drink 300cl')),
                  DataCell(Text('Drinks')),
                  DataCell(Text('100')),
                  DataCell(Text('N50,000')),
                  DataCell(Text('N55,000')),
                  DataCell(Text('N500,000')),
                  DataCell(TableArrowButton()),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/utils/constant-styles.dart';

import 'inventory-detail/inventory-detail.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  final Color shortStockColor = Color(0xFFF28301);

  final Color inStockColor = Color(0xFF00AF27);

  final Color outOfStockColor = Color(0xFFF64932);

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
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Cost Price')),
                  DataColumn(label: Text('Selling Price')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                        Text('Carton of Smirnoff non-acholic drink 300cl')),
                    DataCell(Text('Drinks')),
                    DataCell(Text('500')),
                    DataCell(Text('N50,000')),
                    DataCell(Text('N55,000')),
                    DataCell(Text('In Stock',
                        style: TextStyle(color: inStockColor))),
                    DataCell(GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, InventoryDetail.id);
                      },
                      child: TableArrowButton(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(
                        Text('Carton of Smirnoff non-acholic drink 300cl')),
                    DataCell(Text('Drinks')),
                    DataCell(Text('3')),
                    DataCell(Text('N50,000')),
                    DataCell(Text('N55,000')),
                    DataCell(Text('Out Of Stock',
                        style: TextStyle(color: outOfStockColor))),
                    DataCell(TableArrowButton()),
                  ]),
                  DataRow(cells: [
                    DataCell(
                        Text('Carton of Smirnoff non-acholic drink 300cl')),
                    DataCell(Text('Drinks')),
                    DataCell(Text('500')),
                    DataCell(Text('N50,000')),
                    DataCell(Text('N55,000')),
                    DataCell(Text('In Stock',
                        style: TextStyle(color: inStockColor))),
                    DataCell(TableArrowButton()),
                  ]),
                  DataRow(cells: [
                    DataCell(
                        Text('Carton of Smirnoff non-acholic drink 300cl')),
                    DataCell(Text('Drinks')),
                    DataCell(Text('10')),
                    DataCell(Text('N50,000')),
                    DataCell(Text('N55,000')),
                    DataCell(Text('Short Stock',
                        style: TextStyle(color: shortStockColor))),
                    DataCell(TableArrowButton()),
                  ]),
                  DataRow(cells: [
                    DataCell(
                        Text('Carton of Smirnoff non-acholic drink 300cl')),
                    DataCell(Text('Drinks')),
                    DataCell(Text('500')),
                    DataCell(Text('N50,000')),
                    DataCell(Text('N55,000')),
                    DataCell(Text('In Stock',
                        style: TextStyle(color: inStockColor))),
                    DataCell(TableArrowButton()),
                  ]),
                ],
              ),
            )),
      ),
    );
  }
}

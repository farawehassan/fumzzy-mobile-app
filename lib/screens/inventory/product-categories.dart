import 'package:flutter/material.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/utils/constant-styles.dart';

class ProductCategories extends StatefulWidget {

  const ProductCategories({Key? key}) : super(key: key);

  @override
  _ProductCategoriesState createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: kTableContainer,
              child: ProductCategoriesTable(),
            ),
            SizedBox(height: 40),
            Button(
              onTap: (){
                print("save changes");
              },
              buttonColor: Color(0xFF00509A),
              width: 160,
              child: Center(
                child: Text(
                  'Save Changes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ProductCategoriesTable extends StatelessWidget {

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
        fontWeight: FontWeight.normal,
      ),
      columnSpacing: 15.0,
      dataRowHeight: 65.0,
      columns: [
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Products')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Drinks')),
          DataCell(Text('500')),
          DataCell(ReusableDeleteText()),
        ]),
        DataRow(cells: [
          DataCell(Text('Appliances')),
          DataCell(Text('330')),
          DataCell(ReusableDeleteText()),
        ]),
      ],
    );
  }

}

class ReusableDeleteText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('Delete');
      },
      child: Row(
        children: [
          Text(
            'Delete ',
            style: TextStyle(
              color: Color(0xFFF64932),
              fontSize: 14,
            ),
          ),
          Icon(
            Icons.delete,
            color: Color(0xFFF64932),
            size: 15,
          ),
        ],
      ),
    );
  }

}
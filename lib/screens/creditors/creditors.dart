import 'package:flutter/material.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/utils/constant-styles.dart';

class Creditors extends StatefulWidget {

  static const String id = 'creditors';

  @override
  _CreditorsState createState() => _CreditorsState();
}

class _CreditorsState extends State<Creditors> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'CREDITORS'),
        drawer: RefactoredDrawer(title: 'CREDITORS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Creditors',
                    style: TextStyle(
                      color: Color(0xFF171725),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  Button(
                    onTap: (){
                      print("save changes");
                    },
                    buttonColor: Color(0xFF00509A),
                    width: 160,
                    child: Center(
                      child: Text(
                        'Add New Creditor',
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
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              margin: EdgeInsets.only(right: 50),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(27.5),
                              ),
                              child: TextField(
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    IconlyLight.search,
                                    color: Colors.black,
                                    size: 17,
                                  ),
                                  hintText: 'Search',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0,
                                    color: Colors.black
                                ),
                              ),
                            ), //search
                            InkWell(
                              onTap: () {
                                print("filter");
                              },
                              child: Container(
                                width: 110,
                                height: 50,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFFE2E2EA),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                        color: Color(0xFF171725),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.tune,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 37),
                      Container(
                        decoration: kTableContainer,
                        child: ReusableDataTable()
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class ReusableDataTable extends StatelessWidget {

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
          fontWeight: FontWeight.normal,
        ),
        columnSpacing: 15.0,
        dataRowHeight: 65.0,
        columns: [
          DataColumn(label: Expanded(child: Text(' Name'))),
          DataColumn(label: Expanded(child: Text('Total Credits'))),
          DataColumn(label: Expanded(child: Text('Last Re-payment Date'))),
          DataColumn(label: Expanded(child: Text(''))),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N5,000')),
            DataCell(Text('-')),
            DataCell(TableArrowButton()),
          ]),
          DataRow(cells: [
            DataCell(Text('Obi Cubana and Sons Limited')),
            DataCell(Text('N20,000')),
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
            DataCell(Text('N200,000')),
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
            DataCell(Text('N180,000')),
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
            DataCell(Text('N180,000')),
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



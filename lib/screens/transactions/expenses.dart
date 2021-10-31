import 'package:flutter/material.dart';
import 'package:fumzy/components/arrow-button.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'expense-info.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
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
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Staff')),
                DataColumn(label: Text('')),
              ], rows: [],
            ),
          ),
        ),
      ),
    );
  }
}

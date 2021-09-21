import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'drawer.dart';
import 'package:fumzy/screens/ReuseableWidgets.dart';

class Dashboard extends StatefulWidget {

  static const String id = 'dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) => Scaffold(
      appBar: buildAppBar(constraints,'Dashboard'),
      drawer: RefactoredDrawer(),
      body: Container(

      ),
    ));
  }
}

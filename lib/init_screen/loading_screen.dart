import 'package:flutter/material.dart';
import 'package:fumzy/dashboard/dash_board.dart';
import 'dart:async';

class BouncingContainer extends StatefulWidget {


  @override
  _BouncingContainerState createState() => _BouncingContainerState();
}

class _BouncingContainerState extends State<BouncingContainer> with TickerProviderStateMixin{
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 95,
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
  }
  // @override
  // void didUpdateWidget( oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   controller.duration = Duration(milliseconds: 1000);
  // }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: controller.value),
      child: Transform.rotate(
        angle: 0.8,
        child: Material(
          elevation: 11.3,
          shadowColor: Colors.black,
          child: Container(
            width: 70,//constraints.maxWidth*0.21,
            height: 70,//constraints.maxHeight*0.10,
            color: Color(0xFF006ACC),
            child: Center(
              child: Transform.rotate(
                angle: -0.8,
                child: Text(
                  'FGV',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00509A),
                    Color(0xFF023C72),
                    Color(0xFF023C72),
                    Color(0xFF023C72),

                  ],
                ),
              ),
              child: Center(
                child: BouncingContainer(),
              ),
            )
        ),
      ),
    );
  }
}


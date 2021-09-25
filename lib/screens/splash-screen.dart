import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class SplashScreen extends StatefulWidget {

  static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late AnimationController _controller;

  void _navigate(){
    Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, Login.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
      lowerBound: 0,
      upperBound: 95,
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat(reverse: true);
    _navigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
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
        child: Container(
          margin: EdgeInsets.only(top: _controller.value),
          child: Transform.rotate(
            angle: 0.8,
            child: Material(
              elevation: 11.3,
              shadowColor: Colors.black,
              child: Container(
                width: 70.7,
                height: 70.7,
                color: Colors.white,
                child: Center(
                  child: Transform.rotate(
                    angle: -0.8,
                    child: Text(
                      'FGV',
                      style: TextStyle(
                        color: Color(0xFF006ACC),
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

}
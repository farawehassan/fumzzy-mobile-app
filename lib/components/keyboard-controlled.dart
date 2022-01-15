import 'package:flutter/material.dart';

/// This widget controls the keyboard to close when user taps on the screen
/// outside the keyboard area
class KeyboardControlled extends StatefulWidget {

  final Widget? child;

  const KeyboardControlled({
    Key? key,
    @required this.child
  }) : super(key: key);

  @override
  _KeyboardControlledState createState() => _KeyboardControlledState();
}

class _KeyboardControlledState extends State<KeyboardControlled> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: widget.child,
    );
  }
}

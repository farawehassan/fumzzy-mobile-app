import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final void Function()? onTap;

  final Color? buttonColor;

  final Color? foregroundColor;

  final Widget? child;

  final double? width;

  final double? height;

  final double? radius;

  const Button({
    Key? key,
    @required this.onTap,
    @required this.buttonColor,
    this.foregroundColor,
    @required this.child,
    this.width,
    this.height,
    this.radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: buttonColor, // background
          onPrimary: foregroundColor ?? Color(0xFFFFFFFF), // foreground
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
          )
      ),
      onPressed: onTap,
      child: Container(
        width: width ?? 179,
        height: 50,
        child: child,
      ),
    );
  }

}
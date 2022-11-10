import 'package:flutter/material.dart';

class TealButton extends StatelessWidget {
  final double width;
  final VoidCallback? press;
  final String name;
  final Color color;
  final Color? txtColor;
  final double? fontSize;
  final double height;
  const TealButton({
    Key? key,
    required this.width,
    this.press,
    required this.name,
    this.color = Colors.deepOrange,
    this.txtColor,
    this.fontSize,
    this.height = 45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: MediaQuery.of(context).size.width * width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: MaterialButton(
          onPressed: press,
          child: Text(
            name.toUpperCase(),
            style: TextStyle(color: txtColor, fontSize: fontSize),
          ),
        ));
  }
}

class AuthButton extends StatelessWidget {
  final double width;
  final VoidCallback? press;
  final String name;
  final Color color;
  final Color? txtColor;
  final double height;
  const AuthButton({
    Key? key,
    required this.width,
    required this.press,
    required this.name,
    this.color = Colors.deepOrange,
    this.txtColor = Colors.white,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width * width,
      child: OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.transparent,
            minimumSize: const Size.fromHeight(35),
            side: const BorderSide(width: 2, color: Colors.lightBlueAccent)),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(color: txtColor),
        ),
      ),
    );
  }
}

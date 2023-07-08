import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBackButton extends StatelessWidget {
  final Color color;
  const AppBarBackButton({
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: color,
          size: 20,
        ));
  }
}

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.acme(
        color: Colors.black,
        fontSize: 28,
      ),
    );
  }
}

class RedBarBackButton extends StatelessWidget {
  const RedBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.white,
        ));
  }
}

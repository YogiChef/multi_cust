import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../minor_page/search.dart';

const textColor = [
  Colors.deepOrange,
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal,
];

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText('Ecommerce',
              textStyle:
                  GoogleFonts.acme(fontSize: 36, fontWeight: FontWeight.bold),
              colors: textColor),
          ColorizeAnimatedText('Salehub',
              textStyle:
                  GoogleFonts.acme(fontSize: 36, fontWeight: FontWeight.bold),
              colors: textColor)
        ],
        isRepeatingAnimation: true,
        repeatForever: true,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchPage()));
          },
          icon: const Icon(
            Icons.search,
            size: 30,
            color: Colors.deepOrange,
          ),
        )
      ],
    );
  }
}

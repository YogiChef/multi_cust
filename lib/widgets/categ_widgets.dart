import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../minor_page/sub_categ_product.dart';

class SliderBar extends StatelessWidget {
  final String maincategName;

  const SliderBar({
    Key? key,
    required this.size,
    required this.maincategName,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 82,
      width: size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(0)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                maincategName == 'bags'
                    ? Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.grey.shade300,
                      )
                    : const Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.black,
                      ),
                Text(maincategName.toUpperCase(), style: style),
                maincategName == 'men'
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade300,
                      )
                    : const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const style = TextStyle(color: Colors.brown, fontSize: 16, letterSpacing: 10);

class SubcategModel extends StatelessWidget {
  final String mainCategName;
  final String subCategName;
  final String assetName;
  final String subctegLabel;

  const SubcategModel({
    Key? key,
    required this.mainCategName,
    required this.subCategName,
    required this.assetName,
    required this.subctegLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategProducts(
                      subcategName: subCategName,
                      maincategName: mainCategName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 80,
            child: Image(
              image: AssetImage(assetName),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: Text(
            subctegLabel,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          headerLabel,
          style: GoogleFonts.acme(
              color: Colors.teal,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
      ),
    );
  }
}

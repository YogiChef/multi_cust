import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/model/product_model.dart';
import 'package:hub/service/globas_service.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HotDealsPage extends StatefulWidget {
  final bool fromOnBoarding;
  final String maxDiscount;
 
   const HotDealsPage({
    super.key,
    required this.fromOnBoarding,
    required this.maxDiscount,
    
  });

  @override
  State<HotDealsPage> createState() => _HotDealsPageState();
}

class _HotDealsPageState extends State<HotDealsPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = store
        .collection('products')
        .where('discount', isEqualTo: 15)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: widget.fromOnBoarding == true
            ? IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'customer_home');
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.yellowAccent,
                ))
            : const TealButton(width: 1, name: ''),
        title: SizedBox(
          height: 160,
          child: Stack(children: [
            Positioned(
                left: 0,
                top: 70,
                child: Center(
                  child: DefaultTextStyle(
                    style: GoogleFonts.acme(
                      height: 1.2,
                      color: Colors.yellowAccent,
                      fontSize: 30,
                    ),
                    child: AnimatedTextKit(
                      totalRepeatCount: 5,
                      animatedTexts: [
                        TypewriterAnimatedText('Hot Deals ',
                            speed: const Duration(milliseconds: 60),
                            cursor: '|'),
                        TypewriterAnimatedText(
                            'up to ${widget.maxDiscount} % off ',
                            speed: const Duration(milliseconds: 60),
                            cursor: '|',
                            textStyle: GoogleFonts.acme(
                              fontSize: 22,
                            )),
                      ],
                      repeatForever: true,
                    ),
                  ),
                ))
          ]),
        ),
      ),
      body: Stack(children: [
        Container(
          height: 60,
          color: Colors.teal,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: productStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'This category \n\n has no items yet !',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.acme(
                            color: Colors.blueGrey,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 2,
                            itemBuilder: ((context, index) {
                              return ProductModel(
                                  product: snapshot.data!.docs[index]);
                            }),
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(1)),
                      ),
                    );
                  })),
        )
      ]),
    );
  }
}

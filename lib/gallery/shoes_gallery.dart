// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/service/global_service.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../model/product_model.dart';

class ShoesGallery extends StatefulWidget {
  final bool fromOnBoarding;
  const ShoesGallery({super.key, this.fromOnBoarding = false});

  @override
  State<ShoesGallery> createState() => _ShoesGalleryState();
}

class _ShoesGalleryState extends State<ShoesGallery> {
  final Stream<QuerySnapshot> _productsStream = store
      .collection('products')
      .where('maincateg', isEqualTo: 'shoes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromOnBoarding == true
          ? AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              title: const AppbarTitle(
                title: 'Shoes',
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'customer_home');
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black54,
                    size: 20,
                  )),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) {
                  return ProductModel(
                    product: snapshot.data!.docs[index],
                  );
                },
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
          );
          //     ListView(
          //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //         Map<String, dynamic> data =
          //             document.data()! as Map<String, dynamic>;
          //         return ListTile(
          //           leading: Image(
          //             image: NetworkImage(data['proimage'][0]),
          //             fit: BoxFit.cover,
          //           ),
          //           title: Text(data['proname']),
          //           subtitle: Text(data['price'].toString()),
          //         );
          //       }).toList(),
          //     );
        },
      ),
    );
  }
}

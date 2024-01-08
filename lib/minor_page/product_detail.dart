// ignore_for_file: avoid_print

import "package:badges/badges.dart" as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart'; //package:collection/src/iterable_extensions.dart
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/main_page/cart.dart';
import 'package:hub/minor_page/full_page_view.dart';
import 'package:hub/minor_page/visit_store.dart';
import 'package:hub/providers/cart_provider.dart';
import 'package:hub/providers/product_class.dart';
import 'package:hub/providers/wish_provider.dart';
import 'package:hub/widgets/alert_dialog.dart';
import 'package:hub/widgets/appbar_widgets.dart';

import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../model/product_model.dart';
import '../service/global_service.dart';
import '../widgets/snackbar.dart';
import '../widgets/widget_button.dart';

class ProductDetail extends StatefulWidget {
  final dynamic prolist;
  const ProductDetail({required this.prolist, super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? documentId;
  @override
  void initState() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        setState(() {
          documentId = user.uid;
        });
      } else {
        setState(() {
          documentId = null;
        });
      }
    });
    super.initState();
  }

  late final Stream<QuerySnapshot> productsStream = store
      .collection('products')
      .where('maincateg', isEqualTo: widget.prolist['maincateg'])
      .where('subcateg', isEqualTo: widget.prolist['subcateg'])
      .snapshots();
  late final Stream<QuerySnapshot> reviewsStream = store
      .collection('products')
      .doc(widget.prolist['proid'])
      .collection('reviews')
      .snapshots();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imgList = widget.prolist['proimage'];
  @override
  Widget build(BuildContext context) {
    var onSale = widget.prolist['discount'];
    late var existingItemWishlist = context
        .read<Wish>()
        .getWishItems
        .firstWhereOrNull(
            (product) => product.documentId == widget.prolist['proid']);
    late var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        (element) => element.documentId == widget.prolist['proid']);
    return Material(
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FullPageView(imgList: imgList)));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                              autoplay: true,
                              pagination: const SwiperPagination(
                                  builder: SwiperPagination.fraction),
                              itemBuilder: (context, index) {
                                return Image(
                                  image: NetworkImage(imgList[index]),
                                  fit: BoxFit.cover,
                                );
                              },
                              itemCount: imgList.length),
                        ),
                        Positioned(
                          top: 40,
                          left: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.white54,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.white54,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share,
                                  size: 20,
                                  color: Colors.black,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 6, 50),
                    child: Column(
                      children: [
                        Text(
                          widget.prolist['proname'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('฿ ',
                                    style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  widget.prolist['price'].toString(),
                                  style: onSale != 0
                                      ? const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w500,
                                        )
                                      : TextStyle(
                                          color: Colors.red.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                onSale != 0
                                    ? Text(
                                        ((1 - (onSale / 100)) *
                                                widget.prolist['price'])
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.red.shade600,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            ),
                            IconButton(
                                onPressed: documentId == null
                                    ? () {
                                        LoginDialog.showLoginDialog(context);
                                      }
                                    : () {
                                        existingItemWishlist != null
                                            ? context.read<Wish>().removeThis(
                                                widget.prolist['proid'])
                                            : context
                                                .read<Wish>()
                                                .addWishItem(Product(
                                                  documentId:
                                                      widget.prolist['proid'],
                                                  name:
                                                      widget.prolist['proname'],
                                                  price: onSale != 0
                                                      ? ((1 - (onSale / 100)) *
                                                          widget
                                                              .prolist['price'])
                                                      : widget.prolist['price'],
                                                  qty: 1,
                                                  qntty:
                                                      widget.prolist['instock'],
                                                  imagesUrl: imgList.first,
                                                  suppId: widget.prolist['sid'],
                                                ));
                                      },
                                icon: context
                                            .watch<Wish>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.prolist['proid']) !=
                                        null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                      )),
                          ],
                        ),
                        widget.prolist['instock'] == 0
                            ? const Text(
                                'This item is out of stock',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.prolist['instock'].toString(),
                                    style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Pieces available in storck',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                        const ProDetailsHeader(
                          label: " Item Description ",
                        ),
                        Text(
                          widget.prolist['prodesc'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        Stack(
                          children: [
                            const Positioned(
                                right: 50,
                                top: 15,
                                child: Text(
                                  'total',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.teal,
                                    decorationThickness: 1.5,
                                  ),
                                )),
                            ExpandableTheme(
                                data: const ExpandableThemeData(
                                    iconColor: Colors.teal, iconSize: 30),
                                child: reviews(reviewsStream)),
                          ],
                        ),
                        const ProDetailsHeader(
                          label: "   Similar Item  ",
                        ),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                    staggeredTileBuilder: (context) =>
                                        const StaggeredTile.fit(1)),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomSheet: SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: documentId != null
                              ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VisitStore(
                                              suppId: widget.prolist['sid'])));
                                }
                              : () {
                                  LoginDialog.showLoginDialog(context);
                                },
                          icon: const Icon(IconlyLight.category),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartPage(
                                          back: AppBarBackButton(),
                                        )));
                          },
                          icon: badges.Badge(
                              showBadge: context.watch<Cart>().getItems.isEmpty
                                  ? false
                                  : true,
                              badgeContent: Text(
                                context
                                    .watch<Cart>()
                                    .getItems
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              child: const Icon(IconlyLight.bag)),
                        ),
                      ],
                    ),
                    documentId == null
                        ? const SizedBox()
                        : existingItemCart != null
                            ? const SizedBox()
                            : TealButton(
                                width: 0.5,
                                name: existingItemCart != null
                                    ? 'ADDED TO CART'
                                    : 'ADD TO CART',
                                color: existingItemCart != null
                                    ? Colors.grey.shade300
                                    : Colors.deepOrange,
                                txtColor: Colors.white,
                                fontSize: 12,                              
                                press: documentId != null
                                    ? () {
                                        if (widget.prolist['instock'] == 0) {
                                          MyMessageHandler.showSnackBar(
                                            _scaffoldKey,
                                            'this item is out of stock',
                                          );
                                        } else if (existingItemCart != null) {
                                          MyMessageHandler.showSnackBar(
                                            _scaffoldKey,
                                            'this item already in cart',
                                          );
                                        } else {
                                          context.read<Cart>().addItem(Product(
                                                documentId:
                                                    widget.prolist['proid'],
                                                name: widget.prolist['proname'],
                                                price: onSale != 0
                                                    ? ((1 - (onSale / 100)) *
                                                        widget.prolist['price'])
                                                    : widget.prolist['price'],
                                                qty: 1,
                                                qntty:
                                                    widget.prolist['instock'],
                                                imagesUrl: imgList.first,
                                                suppId: widget.prolist['sid'],
                                              ));
                                        }
                                      }
                                    : () {
                                        LoginDialog.showLoginDialog(context);
                                      },
                              )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
    header: const Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'reviews',
        style: TextStyle(
            fontSize: 16,
            color: Colors.teal,
            decoration: TextDecoration.underline,
            decorationThickness: 2,
            decorationColor: Colors.teal,
            decorationStyle: TextDecorationStyle.solid,
            fontStyle: FontStyle.italic),
      ),
    ),
    collapsed: SizedBox(
      height: 0,
      child: reviewsAll(reviewsStream),
    ),
    expanded: reviewsAll(reviewsStream),
  );
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snpshot) {
      if (snpshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snpshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'This Item\n\n has no reviews yet !',
            textAlign: TextAlign.center,
            style: GoogleFonts.acme(
              color: Colors.blueGrey,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snpshot.data!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snpshot.data!.docs[index]['profileimg'])),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snpshot.data!.docs[index]['name']),
                Row(
                  children: [
                    Text(snpshot.data!.docs[index]['rate'].toString()),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.deepOrange,
                    )
                  ],
                )
              ],
            ),
            subtitle: Text(snpshot.data!.docs[index]['comment']),
          );
        },
      );
    },
  );
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 30,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.yellow.shade900,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
            width: 30,
            child: Divider(color: Colors.yellow.shade900),
          ),
        ],
      ),
    );
  }
}

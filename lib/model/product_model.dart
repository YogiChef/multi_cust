// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/minor_page/product_detail.dart';
import 'package:hub/providers/product_class.dart';
import 'package:hub/service/global_service.dart';
import 'package:hub/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wish_provider.dart';

class ProductModel extends StatefulWidget {
  final dynamic product;

  const ProductModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  late List<dynamic> imgList = widget.product['proimage'];

  String? documentId;
  @override
  void initState() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
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

  @override
  Widget build(BuildContext context) {
    var onSale = widget.product['discount'];
    late var existingItemCart = context.watch<Cart>().getItems.firstWhereOrNull(
        (element) => element.documentId == widget.product['proid']);
    late var existingItemWishlist = context
        .watch<Wish>()
        .getWishItems
        .firstWhereOrNull(
            (product) => product.documentId == widget.product['proid']);
    return InkWell(
      onTap: widget.product['instock'] == 0
          ? null
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            prolist: widget.product,
                          )));
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0)),
                    child: widget.product['instock'] == 0
                        ? Stack(
                            children: [
                              Image(
                                image:
                                    NetworkImage(widget.product['proimage'][0]),
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.black87.withOpacity(0.7),
                                  constraints: const BoxConstraints(
                                    minHeight: 100,
                                    maxHeight: 250,
                                    minWidth: double.infinity,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'out of stock',
                                      style: GoogleFonts.righteous(
                                          fontSize: 20,
                                          color: Colors.red,
                                          backgroundColor:
                                              Colors.yellow.shade200),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            constraints: const BoxConstraints(
                                minHeight: 100,
                                maxHeight: 250,
                                minWidth: double.infinity),
                            child: Image(
                              image:
                                  NetworkImage(widget.product['proimage'][0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Column(
                      children: [
                        Text(
                          widget.product['proname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '฿' +
                                      widget.product['price']
                                          .toStringAsFixed(2),
                                  style: onSale != 0
                                      ? const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 1.5,
                                          fontWeight: FontWeight.w500,
                                        )
                                      : TextStyle(
                                          color: Colors.red.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                onSale != 0
                                    ? Text(
                                        '฿' +
                                            ((1 - (onSale / 100)) *
                                                    widget.product['price'])
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.red.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.product['instock'] == 0
                ? const SizedBox()
                : onSale != 0
                    ? Positioned(
                        top: 30,
                        left: 0,
                        child: Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.pink.shade500,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          child: Center(
                            child: Text(
                              'Save ${onSale.toString()} %',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                      ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(5))),
                child: widget.product['instock'] == 0
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 35,
                            child: IconButton(
                                onPressed: documentId == null
                                    ? () {
                                        LoginDialog.showLoginDialog(context);
                                      }
                                    : () {
                                        existingItemWishlist != null
                                            ? context.read<Wish>().removeThis(
                                                widget.product['proid'])
                                            : context
                                                .read<Wish>()
                                                .addWishItem(Product(
                                                  documentId:
                                                      widget.product['proid'],
                                                  name:
                                                      widget.product['proname'],
                                                  price: onSale != 0
                                                      ? ((1 - (onSale / 100)) *
                                                          widget
                                                              .product['price'])
                                                      : widget.product['price'],
                                                  qty: 1,
                                                  qntty:
                                                      widget.product['instock'],
                                                  imagesUrl: imgList.first,
                                                  suppId: widget.product['sid'],
                                                ));
                                      },
                                icon: existingItemWishlist != null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 18,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.white,
                                        size: 18,
                                      )),
                          ),
                          SizedBox(
                            height: 30,
                            width: 35,
                            child: IconButton(
                                onPressed: documentId == null
                                    ? () {
                                        LoginDialog.showLoginDialog(context);
                                      }
                                    : () {
                                        existingItemCart != null
                                            ? context.read<Cart>().removeThis(
                                                widget.product['proid'])
                                            : context.read<Cart>().addItem(
                                                  Product(
                                                    documentId:
                                                        widget.product['proid'],
                                                    name: widget
                                                        .product['proname'],
                                                    price: onSale != 0
                                                        ? ((1 -
                                                                (onSale /
                                                                    100)) *
                                                            widget.product[
                                                                'price'])
                                                        : widget
                                                            .product['price'],
                                                    qty: 1,
                                                    qntty: widget
                                                        .product['instock'],
                                                    imagesUrl: imgList.first,
                                                    suppId:
                                                        widget.product['sid'],
                                                  ),
                                                );
                                      },
                                icon: existingItemCart != null
                                    ? const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                        size: 18,
                                      )
                                    : const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      )),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/providers/product_class.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/wish_provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        child: SizedBox(
          height: 90,
          child: Row(
            children: [
              SizedBox(
                height: 70,
                width: 90,
                child: Image.network(
                  product.imagesUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, top: 8, bottom: 8, right: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 0),
                          height: 28,
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey, width: 1),
                          //     borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              product.qty == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoActionSheet(
                                                  title: const Text(
                                                    'Remove Item',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.teal),
                                                  ),
                                                  message: const Text(
                                                      'Are you sure to remove this item ?.',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .deepOrange)),
                                                  actions: <CupertinoActionSheetAction>[
                                                    CupertinoActionSheetAction(
                                                        onPressed: () async {
                                                          context
                                                                      .read<
                                                                          Wish>()
                                                                      .getWishItems
                                                                      .firstWhereOrNull((element) =>
                                                                          element
                                                                              .documentId ==
                                                                          product
                                                                              .documentId) !=
                                                                  null
                                                              ? context
                                                                  .read<Cart>()
                                                                  .removeItem(
                                                                      product)
                                                              : await context
                                                                  .read<Wish>()
                                                                  .addWishItem(Product(
                                                                      documentId:
                                                                          product
                                                                              .documentId,
                                                                      name: product
                                                                          .name,
                                                                      price: product
                                                                          .price,
                                                                      qty: 1,
                                                                      qntty: product
                                                                          .qntty,
                                                                      imagesUrl:
                                                                          product
                                                                              .imagesUrl,
                                                                      suppId: product
                                                                          .suppId));
                                                          context
                                                              .read<Cart>()
                                                              .removeItem(
                                                                  product);

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Move to wishlist',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .teal))),
                                                    CupertinoActionSheetAction(
                                                      onPressed: () async {
                                                        context
                                                            .read<Cart>()
                                                            .removeItem(
                                                                product);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Delete Item',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.teal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 20),
                                                        ))
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 20,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        cart.reduceByOne(product);
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 20,
                                      )),
                              Text(
                                product.qty.toString(),
                                style: product.qty >= product.qntty - 10
                                    ? const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)
                                    : const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  onPressed: product.qty == product.qntty
                                      ? null
                                      : () {
                                          cart.increment(product);
                                        },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 20,
                                  ))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

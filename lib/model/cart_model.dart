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
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: SizedBox(
          height: 90,
          child: Row(
            children: [
              SizedBox(
                height: 90,
                width: 110,
                child: Image.network(
                  product.imagesUrl.first,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 12, bottom: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              product.qty == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoActionSheet(
                                                  title:
                                                      const Text('Remove Item'),
                                                  message: const Text(
                                                      'Are you sure to remove this item ?.'),
                                                  actions: <
                                                      CupertinoActionSheetAction>[
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
                                                                  .addWishItem(
                                                                    product
                                                                        .name,
                                                                    product
                                                                        .price,
                                                                    1,
                                                                    product
                                                                        .qntty,
                                                                    product
                                                                        .imagesUrl,
                                                                    product
                                                                        .documentId,
                                                                    product
                                                                        .suppId,
                                                                  );
                                                          context
                                                              .read<Cart>()
                                                              .removeItem(
                                                                  product);

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Move to wishlist')),
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
                                        size: 16,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        cart.reduceByOne(product);
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 16,
                                      )),
                              Text(
                                product.qty.toString(),
                                style: product.qty >= product.qntty - 10
                                    ? const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)
                                    : const TextStyle(
                                        fontSize: 16,
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
                                    size: 16,
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

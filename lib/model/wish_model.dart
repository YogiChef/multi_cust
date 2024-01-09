import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hub/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_class.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: SizedBox(
          height: 95,
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
                padding: const EdgeInsets.only(left: 12, right: 8, top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        product.name.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: Colors.red),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.read<Wish>().removeItem(product);
                                },
                                icon: const Icon(
                                  IconlyLight.delete,
                                  size: 20,
                                )),
                            const SizedBox(
                              width: 0,
                            ),
                            context.watch<Cart>().getItems.firstWhereOrNull(
                                            (element) =>
                                                element.documentId ==
                                                product.documentId) !=
                                        null ||
                                    product.qntty == 0
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addItem(Product(
                                            documentId: product.documentId,
                                            name: product.name,
                                            price: product.price,
                                            qty: 1,
                                            qntty: product.qntty,
                                            imagesUrl: product.imagesUrl,
                                            suppId: product.suppId,
                                          ));
                                    },
                                    icon: const Icon(
                                      IconlyLight.bag,
                                      size: 20,
                                    )),
                          ],
                        )
                      ],
                    ),
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

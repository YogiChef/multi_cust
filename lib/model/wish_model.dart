import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hub/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_class.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

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
                  product.imagesUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 12, bottom: 0, right: 8),
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
                          product.price.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.read<Wish>().removeItem(product);
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
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
                                      Icons.shopping_cart_outlined,
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

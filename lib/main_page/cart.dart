// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/widgets/alert_dialog.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';
import '../minor_page/place_order.dart';
import '../model/cart_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/widget_button.dart';

class CartPage extends StatefulWidget {
  final Widget? back;
  const CartPage({super.key, this.back});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<String> documentId;
  String? docId;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  setUserId() {
    context.read<IdProvider>().clearCustId();
  }

  @override
  void initState() {
    // documentId = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString('customerid') ?? '';
    // }).then((value) {
    //   setState(() {
    //     docId = value;
    //   });
    //   print(documentId);
    //   print(docId);
    //   return docId!;
    // });
    documentId = context.read<IdProvider>().getDocumentId();
    docId = context.read<IdProvider>().getData;
    super.initState();
  }
  // late String docId;
  // @override
  // void initState() {
  //   docId = context.read<IdProvider>().getData;

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: widget.back,
            title: const AppbarTitle(
              title: 'Cart',
            ),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          contant: 'Are you sure to clear cart ?',
                          context: context,
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            context.read<Cart>().clearCart();
                            Navigator.pop(context);
                          },
                          title: 'Clear Cart',
                        );
                      },
                      icon: const Icon(
                        IconlyLight.delete,
                        color: Colors.black54,
                      ))
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total:  ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              total.toStringAsFixed(0),
                              style: const TextStyle(
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepOrange, width: 2),
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(5)),
                          child: MaterialButton(
                            onPressed: total == 0.0
                                ? null
                                : docId != ''
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PlaceOrderPage()));
                                      }
                                    : () {
                                        LoginDialog.showLoginDialog(context);
                                      },
                            child: Text(
                              'checkouts'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Your Cart Is Empty !',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 50,
        ),
        TealButton(
          width: 0.8,
          name: 'Continue Shopping',
          txtColor: Colors.white,
          color: Colors.teal,
          fontSize: 12,
          press: () {
            Navigator.canPop(context)
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(context, ('customer_home'));
          },
        )
      ],
    );
  }

  void logInDialog(context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('please log in'),
              content: const Text('you should be logged in to take an action'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Log in'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: ListView.builder(
              itemCount: cart.count,
              itemBuilder: (context, index) {
                final product = cart.getItems[index];
                return CartModel(
                  product: product,
                  cart: context.read<Cart>(),
                );
              }),
        );
      },
    );
  }
}

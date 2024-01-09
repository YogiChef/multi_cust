import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/customers/add_address.dart';
import 'package:hub/customers/address_book.dart';
import 'package:hub/minor_page/payment.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../service/global_service.dart';

class PlaceOrderPage extends StatefulWidget {
  final dynamic items;
  const PlaceOrderPage({super.key, this.items});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  late String docId;
  CollectionReference customers = store.collection('customers');
  CollectionReference anonymous = store.collection('anonymous');

  late String name;
  late String phone;
  late String address;

  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> addressStream = store
        .collection('customers')
        .doc(/*auth.currentUser!.uid*/ docId)
        .collection('address')
        .where('default', isEqualTo: true)
        .limit(1)
        .snapshots();
    double totalPrice = context.watch<Cart>().totalPrice;
    return StreamBuilder<QuerySnapshot>(
        stream: addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Material(
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: const AppBarBackButton(),
                  title: const AppbarTitle(title: 'Place Order'),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 50),
                  child: Column(
                    children: [
                      snapshot.data!.docs.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddAddress()));
                              },
                              child: Container(
                                height: 90,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.person_pin_circle_outlined,
                                      color: Colors.green,
                                      size: 32,
                                    ),
                                    Text(
                                      'set your address',
                                      style: GoogleFonts.acme(
                                          color: Colors.red,
                                          height: 1,
                                          fontSize: 24,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2),
                                    ),
                                  ],
                                )),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddressBook()));
                              },
                              child: Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5)),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var customer = snapshot.data!.docs[index];
                                      name = customer['firstname'] +
                                          ' ' +
                                          customer['lastname'];
                                      phone = customer['phone'];
                                      address = customer['state'] +
                                          ', ' +
                                          customer['city'] +
                                          ', \n' +
                                          customer['country'] +
                                          ', ' +
                                          customer['zipcode'];

                                      return ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${customer['firstname']}  ${customer['lastname']} ',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    height: 1.5,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              "Tel: ${customer['phone']}",
                                              style: const TextStyle(
                                                  fontSize: 10, height: 1.2),
                                            )
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'city/state: ${customer['city']}  ${customer['state']} ',
                                                style: const TextStyle(
                                                    fontSize: 10, height: 1.2)),
                                            Text(
                                                "country:  ${customer['country']},  ${customer['zipcode']}",
                                                style: const TextStyle(
                                                    fontSize: 10, height: 1.2))
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child:
                              Consumer<Cart>(builder: (context, cart, child) {
                            return ListView.builder(
                                itemCount: cart.count,
                                itemBuilder: (context, index) {
                                  final order = cart.getItems[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 0.3,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(children: [
                                        ClipRRect(
                                          // borderRadius: const BorderRadius.only(
                                          //     bottomLeft: Radius.circular(5),
                                          //     topLeft: Radius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 70,
                                              width: 90,
                                              child: Image.network(
                                                order.imagesUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  order.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      Text(
                                                        order.price
                                                            .toStringAsFixed(0),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      Text(
                                                        ' x ${order.qty.toString()} ',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red),
                                                      ),
                                                    ]),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${order.qty * order.price.floor()}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  );
                                });
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TealButton(
                    width: 0.8,
                    name: snapshot.data!.docs.isEmpty
                        ? 'Add New Address'
                        : 'Confirm  ${totalPrice.toStringAsFixed(2)} BAHT',
                    txtColor: Colors.white,
                    fontSize: 12,
                    press: snapshot.data!.docs.isEmpty
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddAddress()));
                          }
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                          name: name,
                                          phone: phone,
                                          address: address,
                                        )));
                          },
                  ),
                ),
              ),
            ),
          );
        });
  }
}

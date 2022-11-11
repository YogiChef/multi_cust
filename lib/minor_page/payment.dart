// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../providers/cart_provider.dart';
import '../service/globas_service.dart';

class PaymentPage extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  const PaymentPage({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selected = 1;
  late String orderId;
  CollectionReference customers = store.collection('customers');
  CollectionReference anonymous = store.collection('anonymous');

  void showprogress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait..', msgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    String docId = context.read<IdProvider>().getData;
    double totalPriad = context.watch<Cart>().totalPrice;
    double totalPrice = context.watch<Cart>().totalPrice * 0.01 +
        context.watch<Cart>().totalPrice;
    double sippCoast = context.watch<Cart>().totalPrice * 0.01;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(/*auth.currentUser!.uid*/ docId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text('Document does not exist');
          }
          if (snapshot.hasError) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: const AppBarBackButton(),
                title: const AppbarTitle(title: 'Payment'),
                centerTitle: true,
              ),
              body: Material(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} BAHT',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.black87,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Order',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${totalPriad.toStringAsFixed(2)} ฺฺBAHT',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Shipping Coast',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${sippCoast.toStringAsFixed(2)} BAHT',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  RadioListTile(
                                    value: 1,
                                    groupValue: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value!;
                                      });
                                    },
                                    title: Text(
                                      'Cash On Delivery',
                                      style: TextStyle(
                                          fontSize: selected == 1 ? 16 : 14,
                                          color: selected == 1
                                              ? Colors.teal
                                              : Colors.grey),
                                    ),
                                    subtitle: Text(
                                      'Pay Cash At Home',
                                      style: TextStyle(
                                          fontSize: selected == 1 ? 16 : 14,
                                          color: selected == 1
                                              ? Colors.teal
                                              : Colors.grey),
                                    ),
                                  ),
                                  RadioListTile(
                                    value: 2,
                                    groupValue: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value!;
                                      });
                                    },
                                    title: Text(
                                      'Pay via visa / Master card',
                                      style: TextStyle(
                                          fontSize: selected == 2 ? 16 : 14,
                                          color: selected == 2
                                              ? Colors.teal
                                              : Colors.grey),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(Icons.payment,
                                            color: selected == 2
                                                ? Colors.teal
                                                : Colors.grey),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Icon(FontAwesomeIcons.ccMastercard,
                                            color: selected == 2
                                                ? Colors.teal
                                                : Colors.grey),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Icon(FontAwesomeIcons.ccVisa,
                                            color: selected == 2
                                                ? Colors.teal
                                                : Colors.grey)
                                      ],
                                    ),
                                  ),
                                  RadioListTile(
                                    value: 3,
                                    groupValue: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value!;
                                      });
                                    },
                                    title: Text(
                                      'Pay via Paypal',
                                      style: TextStyle(
                                          fontSize: selected == 3 ? 16 : 14,
                                          color: selected == 3
                                              ? Colors.teal
                                              : Colors.grey),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.paypal,
                                          color: selected == 3
                                              ? Colors.teal
                                              : Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccPaypal,
                                          color: selected == 3
                                              ? Colors.teal
                                              : Colors.grey,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottomSheet: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: TealButton(
                  width: 1,
                  name: 'Confirm  ${totalPrice.toStringAsFixed(2)} BAHT',
                  txtColor: Colors.white,
                  fontSize: 16,
                  press: () async {
                    if (selected == 1) {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Pay At Home ${totalPrice.toStringAsFixed(2)} ฿',
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                      TealButton(
                                        width: 0.9,
                                        name:
                                            'Confirm ${totalPrice.toStringAsFixed(2)} ฿',
                                        txtColor: Colors.white,
                                        fontSize: 16,
                                        press: () async {
                                          showprogress();
                                          for (var item in context
                                              .read<Cart>()
                                              .getItems) {
                                            CollectionReference ref =
                                                store.collection('orders');
                                            orderId = const Uuid().v4();
                                            await ref.doc(orderId).set({
                                              'cid': data['cid'],
                                              'custname': widget.name,
                                              'email': data['email'],
                                              'address': widget.address,
                                              'phone': widget.phone,
                                              'profileimg':
                                                  data['profileImage'],
                                              'sid': item.suppId,
                                              'proid': item.documentId,
                                              'orderid': orderId,
                                              'ordername': item.name,
                                              'orderimg': item.imagesUrl,
                                              'orderqty': item.qty,
                                              'orderprice':
                                                  item.qty * item.price,
                                              'deliverystatus': 'preparing',
                                              'deliverydate': '',
                                              'orderdate': DateTime.now(),
                                              'paymenystatus':
                                                  'cash on delivery',
                                              'orderreview': false,
                                            }).whenComplete(() async {
                                              await store.runTransaction(
                                                  (transaction) async {
                                                DocumentReference docRf = store
                                                    .collection('products')
                                                    .doc(item.documentId);
                                                DocumentSnapshot spshot =
                                                    await transaction
                                                        .get(docRf);
                                                transaction.update(docRf, {
                                                  'instock': spshot['instock'] -
                                                      item.qty
                                                });
                                              });
                                            });
                                          }
                                          await Future.delayed(const Duration(
                                                  microseconds: 100))
                                              .whenComplete(() {
                                            context.read<Cart>().clearCart();
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    'customer_home'));
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    } else if (selected == 2) {
                      ('visa');
                      int payment = totalPrice.round();
                      int pay = payment * 100;
                      await makePayment(data, pay.toString());
                    } else if (selected == 3) {
                      ('paypal');
                    }
                  },
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wai..', progressBgColor: Colors.red);
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(dynamic data, String total) async {
    try {
      paymentIntentData = await createPaymentIntent(total, 'BAHT');
      await stripe.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              merchantDisplayName: 'PRASERT',
              merchantCountryCode: 'us'));
      await displayPaymentSheet(data);
    } catch (e) {
      print('exception:$e');
    }
  }

  displayPaymentSheet(dynamic data) async {
    try {
      await stripe
          .presentPaymentSheet(
              // ignore: deprecated_member_use
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((value) async {
        paymentIntentData = null;
        print('paid');

        showProgress();
        for (var item in context.read<Cart>().getItems) {
          CollectionReference orderRef = store.collection('orders');
          orderId = const Uuid().v4();
          await orderRef.doc().set({
            'cid': data['cid'],
            'custname': data['name'],
            'email': data['email'],
            'address': data['address'],
            'phone': data['phone'],
            'profileimage': data['profileImage'],
            'sid': item.suppId,
            'orderid': orderId,
            'proname': item.name,
            'orderimage': item.imagesUrl,
            'orderqty': item.qty,
            'orderprice': item.qty * item.price,
            'deliverystatus': 'preparing',
            'deliverydate': DateTime.now(),
            'paymentstatus': 'paid online',
            'orderreview': false,
          }).whenComplete(
            () async => await FirebaseFirestore.instance
                .runTransaction((transaction) async {
              DocumentReference rf = FirebaseFirestore.instance
                  .collection('products')
                  .doc(item.documentId);
              DocumentSnapshot spshot = await transaction.get(rf);
              transaction.update(rf, {'instock': spshot['instock'] - item.qty});
            }),
          );
        }
        await Future.delayed(const Duration(microseconds: 100))
            .whenComplete(() {
          context.read<Cart>().clearCart();
          Navigator.popUntil(context, ModalRoute.withName('customer_home'));
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntent(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }
}

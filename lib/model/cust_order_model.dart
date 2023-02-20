import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hub/service/globas_service.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:intl/intl.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.teal),
            borderRadius: BorderRadius.circular(5)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ),
                  child: Container(
                    height: 70,
                    width: 80,
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(
                      widget.order['orderimg'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order['ordername'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                '฿ ${widget.order['orderprice'] / widget.order['orderqty']}'),
                            Text(' x  ${widget.order['orderqty'].toString()}')
                          ],
                        ),
                        Text(
                            '฿ ${widget.order['orderprice'].toStringAsFixed(2)}')
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'See More ..',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.order['deliverystatus'],
                style: TextStyle(
                    color: widget.order['deliverystatus'] == 'shipping'
                        ? Colors.red
                        : widget.order['deliverystatus'] == 'delivered'
                            ? Colors.teal
                            : Colors.black),
              )
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.order['deliverystatus'] == 'delivered'
                      ? Colors.brown.withOpacity(0.2)
                      : Colors.teal.withOpacity(0.07),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${widget.order['custname']} '),
                    Text('Tel.: ${widget.order['phone']}'),
                    Text('Email: ${widget.order['email']}'),
                    Text('Address: ${widget.order['address']}'),
                    Row(
                      children: [
                        const Text('payment status: '),
                        Text(
                          widget.order['paymenystatus'],
                          style: const TextStyle(
                              color: Colors.purple, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('delivery status:  '),
                        Text(
                          widget.order['deliverystatus'],
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery Date: ') +
                                (DateFormat('dd-MM-yyyy').format(
                                        widget.order['deliverydate'].toDate()))
                                    .toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RatingBar.builder(
                                                initialRating: 1,
                                                minRating: 1,
                                                allowHalfRating: true,
                                                itemBuilder: (context, _) {
                                                  return const Icon(
                                                    Icons.star,
                                                    color: Colors.red,
                                                  );
                                                },
                                                onRatingUpdate: (value) {
                                                  rate = value;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 20,
                                                    ),
                                                    hintText:
                                                        'enter your review',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .teal)),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .deepOrange))),
                                                onChanged: (value) {
                                                  comment = value;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                    child: AuthButton(
                                                      width: 0.25,
                                                      name: 'cancel',
                                                      txtColor: Colors.teal,
                                                      press: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: AuthButton(
                                                        width: 0.25,
                                                        txtColor:
                                                            Colors.deepOrange,
                                                        press: () async {
                                                          CollectionReference
                                                              collRf = store
                                                                  .collection(
                                                                      'products')
                                                                  .doc(widget
                                                                          .order[
                                                                      'proid'])
                                                                  .collection(
                                                                      'reviews');
                                                          await collRf
                                                              .doc(auth
                                                                  .currentUser!
                                                                  .uid)
                                                              .set({
                                                            'name':
                                                                widget.order[
                                                                    'custname'],
                                                            'email': widget
                                                                .order['email'],
                                                            'rate': rate,
                                                            'comment': comment,
                                                            'profileimg': widget
                                                                    .order[
                                                                'profileimg'],
                                                          }).whenComplete(
                                                                  () async {
                                                            await store
                                                                .runTransaction(
                                                                    (transaction) async {
                                                              DocumentReference
                                                                  dRf =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'orders')
                                                                      .doc(widget
                                                                              .order[
                                                                          'orderid']);
                                                              transaction
                                                                  .update(dRf, {
                                                                'orderreview':
                                                                    true
                                                              });
                                                            });
                                                          });
                                                          await Future.delayed(
                                                                  const Duration(
                                                                      microseconds:
                                                                          100))
                                                              .whenComplete(() =>
                                                                  Navigator.pop(
                                                                      context));
                                                        },
                                                        name: 'Ok'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: const Text(
                              'Write Review',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ))
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? Row(
                            children: const [
                              Icon(
                                Icons.check,
                                color: Colors.teal,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.teal,
                                    fontSize: 16),
                              )
                            ],
                          )
                        : const Text('')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

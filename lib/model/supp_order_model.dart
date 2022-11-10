import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  const SupplierOrderModel({super.key, this.order});

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
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    height: 70,
                    width: 80,
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(
                      order['orderimg'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['ordername'],
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
                                '฿ ${order['orderprice'] / order['orderqty']}'),
                            Text(' x  ${order['orderqty'].toString()}')
                          ],
                        ),
                        Text('฿ ${order['orderprice']}')
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
              Text(order['deliverystatus'])
            ],
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.07),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  10,
                  10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${order['custname']}'),
                    Text('Phone No.: ${order['phone']}'),
                    Text('Email Address: ${order['email']}'),
                    Text('Address: ${order['address']}'),
                    Row(
                      children: [
                        const Text('Payment status: '),
                        Text(
                          order['paymenystatus'],
                          style: const TextStyle(
                              color: Colors.purple, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Delivery status:  '),
                        Text(
                          order['deliverystatus'],
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Order Date:  '),
                        Text(
                          DateFormat('dd-MM-yyyy  hh:mm')
                              .format(order['orderdate'].toDate())
                              .toString(),
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    order['deliverystatus'] == 'delivered'
                        ? const Text(
                            'This order has been already delivered',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          )
                        : Row(
                            children: [
                              const Text('Change Delivery Status To:  '),
                              order['deliverystatus'] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now()
                                                .add(const Duration(days: 365)),
                                            onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['orderid'])
                                              .update({
                                            'deliverystatus': 'shipping',
                                            'deliverydate': date
                                          });
                                        });
                                      },
                                      child: const Text(
                                        'shipping ?',
                                        style: TextStyle(fontSize: 16),
                                      ))
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order['orderid'])
                                            .update({
                                          'deliverystatus': 'delivered'
                                        });
                                      },
                                      child: const Text(
                                        'delivered ?',
                                        style: TextStyle(fontSize: 16),
                                      ))
                            ],
                          ),
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

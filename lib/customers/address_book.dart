import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/customers/add_address.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/service/global_service.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddressBook extends StatefulWidget {
  // final dynamic item;
  const AddressBook({
    super.key,
    // this.item,
  });

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  late String docId;

  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> addressStream = store
        .collection('customers')
        .doc(
          /*auth.currentUser!.uid*/ docId,
        )
        .collection('address')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppbarTitle(title: 'Address Book'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: addressStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'You have set \n\n an address yet !',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.acme(
                            color: Colors.blueGrey,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var customer = snapshot.data!.docs[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async =>
                                await store.runTransaction((transaction) async {
                              DocumentReference docRf = store
                                  .collection('customers')
                                  .doc(auth.currentUser!.uid)
                                  .collection('address')
                                  .doc(customer['addressid']);
                              transaction.delete(docRf);
                            }),
                            child: GestureDetector(
                              onTap: () async {
                                showprogress();
                                for (var item in snapshot.data!.docs) {
                                  await dfAddressFalse(item);
                                }
                                await dfAddressTrue(customer).whenComplete(
                                    () => updateProfile(customer));
                                Future.delayed(
                                        const Duration(microseconds: 100))
                                    .whenComplete(() => Navigator.pop(context));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: customer['default'] == true
                                      ? Colors.teal.shade100
                                      : Colors.grey.shade200,
                                  child: ListTile(
                                    trailing: customer['default'] == true
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.home,
                                              color: Colors.deepOrange,
                                            ),
                                          )
                                        : const SizedBox(),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${customer['firstname']}  ${customer['lastname']} ',
                                          style: const TextStyle(height: 2),
                                        ),
                                        Text("${customer['phone']}")
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'city/state: ${customer['city']}  ${customer['state']} ',
                                          style: const TextStyle(height: 2),
                                        ),
                                        Text(
                                            "country:  ${customer['country']}  ${customer['zipcode']}")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  })),
          TealButton(
            width: 0.7,
            name: 'Add New Address',
            txtColor: Colors.white,
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddAddress()));
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      )),
    );
  }

  Future dfAddressFalse(dynamic item) async {
    await store.runTransaction((transaction) async {
      DocumentReference dRf = store
          .collection('customers')
          .doc(/*auth.currentUser!.uid*/ docId)
          .collection('address')
          .doc(item.id);
      transaction.update(dRf, {'default': false});
    });
  }

  Future dfAddressTrue(QueryDocumentSnapshot<Object?> customer) async {
    await store.runTransaction(
      (transaction) async {
        DocumentReference dRf = store
            .collection('customers')
            .doc(/*auth.currentUser!.uid*/ docId)
            .collection('address')
            .doc(customer['addressid']);
        transaction.update(dRf, {'default': true});
      },
    );
  }

  Future updateProfile(QueryDocumentSnapshot<Object?> customer) async {
    await store.runTransaction(
      (transaction) async {
        DocumentReference dRf =
            store.collection('customers').doc(auth.currentUser!.uid);
        transaction.update(dRf, {
          'address':
              '${customer['country']}  ${customer['state']}  ${customer['city']}',
          'phone': customer['phone']
        });
      },
    );
  }

  void showprogress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait..', msgColor: Colors.red);
  }

  void hideprogress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.close();
  }
}

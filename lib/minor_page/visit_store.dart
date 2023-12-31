import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/minor_page/edit_store.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../model/product_model.dart';
import '../service/global_service.dart';
import '../widgets/appbar_widgets.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({super.key, required this.suppId});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  String customerId = '';

  List<String> subscriptionsList = [];

  checkUserSubcription() {
    store
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        subscriptionsList.add(doc['customerid']);
      }
    }).whenComplete(() {
      following =
          subscriptionsList.contains(context.read<IdProvider>().getData);
    });
  }

  @override
  void initState() {
    customerId = context.read<IdProvider>().getData;
    customerId == '' ? null : checkUserSubcription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference supplier =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> productsStream = store
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: supplier.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              leading: const AppBarBackButton(
                color: Colors.white,
              ),
              toolbarHeight: 100,
              flexibleSpace: data['coverimage'] == ''
                  ? Image.asset(
                      'images/inapp/themoon.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data['coverimage'],
                      fit: BoxFit.cover,
                    ),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: data['coverimage'] == ''
                              ? Colors.green
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: size.width * 0.46,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    data['storename'].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // data['sid'] == auth.currentUser!.uid
                          customerId == ''
                              ? Container(
                                  height: 35,
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.teal, width: 1.5),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditStore(
                                                    data: data,
                                                  )));
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('Edit'),
                                        Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 35,
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: following == true
                                              ? Colors.teal
                                              : Colors.red,
                                          width: 1.5),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: MaterialButton(
                                    onPressed: following == false
                                        ? () {
                                            subscribeToTopic();
                                          }
                                        : () {
                                            unsubscribeFromTopic();
                                          },
                                    child: following == true
                                        ? Text('Followed',
                                            style: GoogleFonts.aBeeZee(
                                                color: Colors.teal,
                                                fontSize: 16))
                                        : Text(
                                            'Follow',
                                            style: GoogleFonts.aBeeZee(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                  ),
                                )
                        ]),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: productsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                    'This category \n\n has no items yet !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ));
                }
                return SingleChildScrollView(
                  child: StaggeredGridView.countBuilder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductModel(
                        product: snapshot.data!.docs[index],
                      );
                    },
                    staggeredTileBuilder: (context) =>
                        const StaggeredTile.fit(1),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                size: 35,
              ),
              onPressed: () {},
            ),
          );
        }

        return const Center(
            child: CircularProgressIndicator(
          color: Colors.pinkAccent,
        ));
      },
    );
  }

  void subscribeToTopic() {
    messaging.subscribeToTopic("topic");
    String id = context.read<IdProvider>().getData;
    store
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .doc(id)
        .set({'customerid': id});
    setState(() {
      following = true;
    });
  }

  void unsubscribeFromTopic() {
    messaging.unsubscribeFromTopic("topic");
    String id = context.read<IdProvider>().getData;
    store
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .doc(id)
        .delete();

    setState(() {
      following = false;
    });
  }
}

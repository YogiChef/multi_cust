// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/widgets/alert_dialog.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import '../minor_page/visit_store.dart';
import '../servixe/globas_service.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  String? documentId;
  @override
  void initState() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        setState(() {
          documentId = user.uid;
        });
      } else {
        setState(() {
          documentId = null;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const AppbarTitle(title: "Stores"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
            stream: store.collection('suppliers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: documentId != null
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisitStore(
                                            suppId: snapshot.data!.docs[index]
                                                ['sid'],
                                          )));
                            }
                          : () {
                              LoginDialog.showLoginDialog(context);
                            },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 95,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 4,
                                    color: Colors.pinkAccent.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(25)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  snapshot.data!.docs[index]['storelogo'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              snapshot.data!.docs[index]['storename']
                                  .toLowerCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.acme(
                                  fontSize: 20,
                                  letterSpacing: 1.5,
                                  color: Colors.blueGrey.shade900),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text('No Stores'),
              );
            }),
      ),
    );
  }
}

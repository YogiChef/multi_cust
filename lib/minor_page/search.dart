import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/minor_page/product_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CupertinoSearchTextField(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              prefixInsets: const EdgeInsets.only(
                left: 10,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(30)),
              prefixIcon: const Icon(
                IconlyLight.search,
                size: 20,
              ),
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  searchInput = value;
                });
              },
            ),
          )),
      body: searchInput == ''
          ? Padding(
              padding: const EdgeInsets.only(bottom: 200),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          // border: Border.all(width: 1, color: Colors.red),
                          image: DecorationImage(
                            image: AssetImage('images/inapp/search.png'),
                          ),
                        ),
                      ),
                      Text(
                        'Search for\nany products',
                        // maxLines: 2,
                        style: GoogleFonts.lobster(fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final result = snapshot.data!.docs.where(
                  (e) => e['proname'.toLowerCase()]
                      .contains(searchInput.toLowerCase()),
                );
                return ListView(
                  children: result.map((e) => SearchModel(e: e)).toList(),
                );
              }),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: e['instock'] == 0
          ? null
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            prolist: e,
                          )));
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: e['instock'] == 0
                      ? Stack(
                          children: [
                            Image(
                              image: NetworkImage(e['proimage'][0]),
                              height: 60,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.black87.withOpacity(0.7),
                                child: Center(
                                  child: Text(
                                    'out of stock',
                                    style: GoogleFonts.righteous(
                                        fontSize: 12,
                                        color: Colors.red,
                                        backgroundColor:
                                            Colors.yellow.shade200),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 60,
                          width: 80,
                          child: Image(
                            image: NetworkImage(e['proimage'][0]),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                      e['proname'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      e['prodesc'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        e['instock'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                e['instock'] <= 10 ? Colors.red : Colors.grey),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

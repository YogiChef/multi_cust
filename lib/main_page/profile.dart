// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/auth/change_new_pass.dart';
import 'package:hub/customers/address_book.dart';
import 'package:hub/customers/customer_orders.dart';
import 'package:hub/main_page/cart.dart';
import 'package:hub/providers/auth_repo.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:provider/provider.dart';
import '../customers/wishlist.dart';
import '../service/global_service.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';

class ProfilePage extends StatefulWidget {
  // final String documentId;
  const ProfilePage({
    Key? key,
    // required this.documentId,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late Future<String> documentId;
  String? docId;
  CollectionReference customers = store.collection('customers');
  // CollectionReference anonymous = store.collection('anonymous');

  clearUserId() {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: documentId,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Material(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            case ConnectionState.done:
              return docId != '' ? userScaffold() : noUserScaffold();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
          }
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget userScaffold() {
    return FutureBuilder<DocumentSnapshot>(
      future:
          // auth.currentUser!.isAnonymous
          // ? anonymous.doc(docId).get()
          // :
          customers.doc(docId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot>? snapshot) {
        if (snapshot!.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.red.shade900,
                    Colors.blueGrey.shade100
                  ])),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                        centerTitle: true,
                        pinned: true,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        expandedHeight: 140,
                        automaticallyImplyLeading: false,
                        flexibleSpace:
                            LayoutBuilder(builder: (context, constraints) {
                          return FlexibleSpaceBar(
                              centerTitle: true,
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity:
                                    constraints.biggest.height <= 120 ? 1 : 0,
                                child: Text(
                                  'Account',
                                  style: GoogleFonts.acme(
                                      color: Colors.teal, fontSize: 24),
                                ),
                              ),
                              background: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  Colors.red.shade900,
                                  Colors.white
                                ])),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, left: 30),
                                  child: Row(
                                    children: [
                                      data['profileImage'] == ''
                                          ? const CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  'images/inapp/guest.jpg'))
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  data['profileImage']),
                                            ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Text(
                                            data['name'] == ''
                                                ? 'guest'.toUpperCase()
                                                : data['name'].toUpperCase(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.yellowAccent),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        })),
                    SliverToBoxAdapter(
                      child: Column(children: [
                        Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          .23,
                                      child: Center(
                                        child: Text(
                                          'Cart',
                                          style: GoogleFonts.acme(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CartPage(
                                                    back: AppBarBackButton(),
                                                  )));
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade900,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          bottomLeft: Radius.circular(0))),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          .23,
                                      child: Center(
                                        child: Text(
                                          'Orders',
                                          style: GoogleFonts.acme(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CustomerOrders()));
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.purple[900],
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          .23,
                                      child: Center(
                                        child: Text(
                                          'Wishlist',
                                          style: GoogleFonts.acme(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WishlistPage()));
                                    },
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          color: Colors.grey.shade300,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 150,
                                child: Image(
                                    image: AssetImage(
                                        'images/inapp/shopshub.png')),
                              ),
                              const ProfileHeaderLabel(
                                headerLabel: ' Account Info. ',
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    children: [
                                      RepeatedListTile(
                                        title: 'Email',
                                        subTitle: data['email'] == ''
                                            ? 'example@gmail.com'
                                            : data['email'],
                                        icon: Icons.email,
                                      ),
                                      tealDivider(),
                                      RepeatedListTile(
                                        title: 'Phone No.',
                                        subTitle: data['phone'] == ''
                                            ? '+66111111'
                                            : data['phone'],
                                        icon: Icons.phone,
                                      ),
                                      tealDivider(),
                                      RepeatedListTile(
                                        title: 'Address',
                                        subTitle: userAddress(data),
                                        icon: Icons.location_pin,
                                        press: auth.currentUser!.isAnonymous
                                            ? null
                                            : () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddressBook()));
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const ProfileHeaderLabel(
                                  headerLabel: ' Account Setting '),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    children: [
                                      RepeatedListTile(
                                        title: 'Edit Profile',
                                        icon: Icons.edit,
                                        press: () {},
                                      ),
                                      tealDivider(),
                                      RepeatedListTile(
                                        title: 'Change Password',
                                        icon: Icons.lock,
                                        press: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ChangeNewPassword()));
                                        },
                                      ),
                                      tealDivider(),
                                      RepeatedListTile(
                                        title: 'Log Out',
                                        icon: Icons.logout,
                                        press: () async {
                                          MyAlertDialog.showMyDialog(
                                              contant:
                                                  'Are you sure to log out ',
                                              context: context,
                                              tabNo: () {
                                                Navigator.pop(context);
                                              },
                                              tabYes: () async {
                                                await auth.signOut();
                                                await clearUserId();
                                                // final SharedPreferences pref =
                                                //     await _prefs;
                                                // pref.setString('custId', '');

                                                await Future.delayed(
                                                        const Duration(
                                                            microseconds: 100))
                                                    .whenComplete(() => Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            'customer_login'));
                                              },
                                              title: 'Log Out');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.pinkAccent,
          ),
        );
      },
    );
  }

  Widget tealDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.teal,
        thickness: 1,
      ),
    );
  }

  String userAddress(dynamic data) {
    if (/*auth.currentUser!.isAnonymous == true*/ docId == '') {
      return 'example 143 M. 1 Buengkan 38170';
    } else if (/*auth.currentUser!.isAnonymous == false*/ docId != '' &&
        data['address'] == '') {
      return data['address'];
    }
    return data['address'];
  }

  Widget noUserScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.teal, Colors.blueGrey.shade100])),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  expandedHeight: 140,
                  automaticallyImplyLeading: false,
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    return FlexibleSpaceBar(
                        centerTitle: true,
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: constraints.biggest.height <= 120 ? 1 : 0,
                          child: Text(
                            'Account',
                            style: GoogleFonts.acme(
                                color: Colors.teal, fontSize: 24),
                          ),
                        ),
                        background: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Colors.teal,
                            Colors.blueGrey.shade100
                          ])),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25, left: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('images/inapp/guest.jpg')),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                      'guest'.toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.yellowAccent),
                                    ),
                                  ),
                                ),
                                TealButton(
                                  height: 35,
                                  width: 0.25,
                                  name: 'login',
                                  txtColor: Colors.white,
                                  press: () {
                                    Navigator.pushReplacementNamed(
                                        context, 'customer_login');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ));
                  })),
              SliverToBoxAdapter(
                child: Column(children: [
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .23,
                                child: Center(
                                  child: Text(
                                    'Cart',
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                logInDialog();
                              },
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    bottomLeft: Radius.circular(0))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .23,
                                child: Center(
                                  child: Text(
                                    'Orders',
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                logInDialog();
                              },
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .23,
                                child: Center(
                                  child: Text(
                                    'Wishlist',
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                logInDialog();
                              },
                            ),
                          )
                        ]),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                          child: Image(
                              image: AssetImage('images/inapp/shopshub.png')),
                        ),
                        const ProfileHeaderLabel(
                          headerLabel: ' Account Info. ',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            height: 260,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                const RepeatedListTile(
                                  title: 'Email',
                                  subTitle: 'example@gmail.com',
                                  icon: Icons.email,
                                ),
                                tealDivider(),
                                const RepeatedListTile(
                                  title: 'Phone No.',
                                  subTitle: '+66111111',
                                  icon: Icons.phone,
                                ),
                                tealDivider(),
                                RepeatedListTile(
                                  title: 'Address',
                                  subTitle: 'example : New Jersey - USA',
                                  icon: Icons.location_pin,
                                  press: () {
                                    logInDialog();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const ProfileHeaderLabel(
                            headerLabel: ' Account Setting '),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            height: 260,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                RepeatedListTile(
                                  title: 'Edit Profile',
                                  icon: Icons.edit,
                                  press: () {},
                                ),
                                tealDivider(),
                                RepeatedListTile(
                                  title: 'Change Password',
                                  icon: Icons.lock,
                                  press: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangeNewPassword()));
                                  },
                                ),
                                tealDivider(),
                                RepeatedListTile(
                                  title: 'Log Out',
                                  icon: Icons.logout,
                                  press: () async {
                                    MyAlertDialog.showMyDialog(
                                        contant: 'Are you sure to log out ?',
                                        context: context,
                                        tabNo: () {
                                          Navigator.pop(context);
                                        },
                                        tabYes: () async {
                                          await AuthRepo.logOut();
                                          await clearUserId();
                                          // final SharedPreferences pref =
                                          //     await _prefs;
                                          // pref.setString('custId', '');
                                          await Future.delayed(const Duration(
                                                  microseconds: 100))
                                              .whenComplete(() => Navigator
                                                  .pushReplacementNamed(context,
                                                      'customer_login'));
                                        },
                                        title: 'Log Out');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }

  void logInDialog() {
    showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
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
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'customer_login');
                  },
                )
              ],
            ));
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback? press;

  const RepeatedListTile({
    Key? key,
    required this.title,
    this.subTitle = '',
    required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
                color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

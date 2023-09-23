import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hub/main_page/cart.dart';
import 'package:hub/main_page/category.dart';
import 'package:hub/main_page/profile.dart';
import 'package:hub/main_page/store.dart';
import 'package:hub/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'home_page.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int? selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomePage(),
    const CategoryPage(),
    const StoresPage(),
    const CartPage(),
    const ProfilePage(
        // documentId: auth.currentUser!.uid,
        ),
  ];

  @override
  void initState() {
    context.read<Cart>().loadCartItemProvider();
    context.read<Wish>().loadWishlistProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[selectedIndex!],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex!,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(IconlyLight.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(IconlyLight.search), label: 'Category'),
          const BottomNavigationBarItem(
              icon: Icon(IconlyLight.category), label: 'Stores'),
          BottomNavigationBarItem(
              icon: badges.Badge(
                  showBadge:
                      context.read<Cart>().getItems.isEmpty ? false : true,
                  badgeContent: Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: const Icon(IconlyLight.bag)),
              label: 'Cart'),
          const BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

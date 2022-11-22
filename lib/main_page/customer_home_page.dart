import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
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
              icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: 'Category'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shop_outlined), label: 'Stores'),
          BottomNavigationBarItem(
              icon: Badge(
                  showBadge:
                      context.read<Cart>().getItems.isEmpty ? false : true,
                  badgeContent: Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined)),
              label: 'Cart'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
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

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';
import '../model/wish_model.dart';
import '../providers/wish_provider.dart';
import '../widgets/alert_dialog.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({
    super.key,
  });

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: const AppBarBackButton(),
            title: const AppbarTitle(title: 'Wishlise'),
            actions: [
              context.watch<Wish>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                            context: context,
                            title: 'Clear Wishlist',
                            contant: 'Are you sure to clear Wishlist ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Wish>().clearWishList();
                              Navigator.pop(context);
                            });
                      },
                      icon: const Icon(
                        IconlyLight.delete,
                        color: Colors.black54,
                      ))
            ],
          ),
          body: context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishItems()
              : const EmptyWishCart(),
        ),
      ),
    );
  }
}

class EmptyWishCart extends StatelessWidget {
  const EmptyWishCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your Wishlist Is Empty !',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
              return WishlistModel(product: product);
            });
      },
    );
  }
}

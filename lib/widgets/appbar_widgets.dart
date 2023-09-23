import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../minor_page/search.dart';

class AppBarBackButton extends StatelessWidget {
  final Color color;
  const AppBarBackButton({
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: color,
          size: 20,
        ));
  }
}

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.acme(
        color: Colors.black,
        fontSize: 28,
      ),
    );
  }
}

class RedBarBackButton extends StatelessWidget {
  const RedBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.white,
        ));
  }
}

class SearchIputWidget extends StatelessWidget {
  const SearchIputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: SizedBox(
        height: 35,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: TextField(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                hintText: 'Search For Products',
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: const Icon(CupertinoIcons.search)),
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'search');
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueGrey,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: const [
            Icon(
              Icons.search,
              size: 24,
              color: Colors.grey,
            ),
            Text(
              'Search',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

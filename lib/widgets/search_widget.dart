
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter/material.dart';


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
        width: MediaQuery.of(context).size.width * 0.77,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueGrey,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: const Row(
          children: [
            Icon(
              IconlyLight.search,
              size: 20,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10,
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
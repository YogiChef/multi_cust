import 'package:flutter/material.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import '../categories/accessories_categ.dart';
import '../categories/bags_categ.dart';
import '../categories/beauty_categ.dart';
import '../categories/electonics_categ.dart';
import '../categories/homegarden_categ.dart';
import '../categories/kids_categ.dart';
import '../categories/men_categ.dart';
import '../categories/shoes_categ.dart';
import '../categories/women_categ.dart';

List<ItemsData> items = [
  ItemsData(label: 'Men'),
  ItemsData(label: 'Women'),
  ItemsData(label: 'Shoes'),
  ItemsData(label: 'Electronics'),
  ItemsData(label: 'Accessories'),
  ItemsData(label: 'Home & Garden'),
  ItemsData(label: 'Beauty'),
  ItemsData(label: 'Kids'),
  ItemsData(label: 'Bags'),
];

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      // title: AnimatedTextKit(
      //   animatedTexts: [
      //     ColorizeAnimatedText('Ecommerce',
      //         textStyle:
      //             GoogleFonts.acme(fontSize: 36, fontWeight: FontWeight.bold),
      //         colors: textColor),
      //     ColorizeAnimatedText('Salehub',
      //         textStyle:
      //             GoogleFonts.acme(fontSize: 36, fontWeight: FontWeight.bold),
      //         colors: textColor)
      //   ],
      //   isRepeatingAnimation: true,
      //   repeatForever: true,
      // ),
      // backgroundColor: Colors.white,
      // centerTitle: true,
      // toolbarHeight: 30,
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => const SearchPage()));
      //     },
      //     icon: const Icon(
      //       Icons.search,
      //       size: 30,
      //       color: Colors.deepOrange,
      //     ),
      //   )
      // ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const SearchWidget(),
            const SizedBox(
              height: 10,
            ),
            sideNavigator(size),
            const Divider(
              thickness: 3,
              color: Colors.teal,
            ),
            categView(size),
          ],
        ),
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.05,
      width: size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.jumpToPage(index);
                // _pageController.animateToPage(index,
                //     duration: const Duration(milliseconds: 1000),
                //     curve: Curves.easeInCirc);
                // for (var element in items) {
                //   element.isSelected = false;
                // }
                // setState(() {
                //   items[index].isSelected = true;
                // });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                    child: Text(
                  items[index].label,
                  style: items[index].isSelected == true
                      ? const TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)
                      : const TextStyle(color: Colors.grey),
                )),
              ),
            );
          }),
    );
  }

  Widget categView(Size size) {
    return Container(
      height: size.height * 0.78,
      width: size.width,
      color: Colors.white10,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          WomenCategory(),
          ShoesCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          HomeGardenCategory(),
          BeautyCategory(),
          KidsCategory(),
          BagsCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}

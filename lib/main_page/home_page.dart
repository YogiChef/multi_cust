import 'package:flutter/material.dart';
import 'package:hub/gallery/accessories_gallery.dart';
import 'package:hub/gallery/bags_gallery.dart';
import 'package:hub/gallery/beauty_gallery.dart';
import 'package:hub/gallery/electronics_gallery.dart';
import 'package:hub/gallery/home&garden_gallery.dart';
import 'package:hub/gallery/kids_gallery.dart';
import 'package:hub/gallery/men_gallery.dart';
import 'package:hub/gallery/shoes_gallery.dart';
import 'package:hub/gallery/women_gallery.dart';
import 'package:hub/widgets/appbar_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 9,
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                const SearchWidget(),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                  child: const TabBar(
                    labelPadding: EdgeInsets.only(right: 20),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.teal,
                    labelColor: Colors.teal,
                    indicatorWeight: 4,
                    dividerHeight: 0,
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 12,
                    ),
                    tabs: [
                      Tab(
                        child: RepeatedTab(
                          label: 'Men',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Women',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Shoes',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Electronics',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Accessories',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Home & Garden',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Beauty',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Kids',
                        ),
                      ),
                      Tab(
                        child: RepeatedTab(
                          label: 'Bage',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const TabBarView(
                    children: [
                      MenGallery(),
                      WomenGallery(),
                      ShoesGallery(),
                      ElectronicGallery(),
                      AccessoriesGallery(),
                      HomeAndGardenGallery(),
                      BeautyGallery(),
                      KidsGallery(),
                      BagsGallery(),
                    ],
                  ),
                ),
              ],
            )
          ]))
        ],
      ),
      //   child: Scaffold(
      //     backgroundColor: Colors.grey.shade100,
      //     appBar: AppBar(
      //       title: const SearchWidget(),
      //       // title: AnimatedTextKit(
      //       //   animatedTexts: [
      //       //     ColorizeAnimatedText('Ecommerce',
      //       //         textStyle: GoogleFonts.acme(
      //       //             fontSize: 36, fontWeight: FontWeight.bold),
      //       //         colors: textColor),
      //       //     ColorizeAnimatedText('Salehub',
      //       //         textStyle: GoogleFonts.acme(
      //       //             fontSize: 36, fontWeight: FontWeight.bold),
      //       //         colors: textColor)
      //       //   ],
      //       //   isRepeatingAnimation: true,
      //       //   repeatForever: true,
      //       // ),
      //       backgroundColor: Colors.white,
      //       centerTitle: true,
      //       // actions: [
      //       //   IconButton(
      //       //     onPressed: () {
      //       //       Navigator.push(
      //       //           context,
      //       //           MaterialPageRoute(
      //       //               builder: (context) => const SearchPage()));
      //       //     },
      //       //     icon: const Icon(
      //       //       Icons.search,
      //       //       size: 30,
      //       //       color: Colors.deepOrange,
      //       //     ),
      //       //   )
      //       // ],
      //       // toolbarHeight: 30,
      //       elevation: 0,
      //       bottom: const TabBar(
      //         isScrollable: true,
      //         indicatorColor: Colors.teal,
      //         labelColor: Colors.teal,
      //         indicatorWeight: 4,
      //         unselectedLabelColor: Colors.grey,
      //         unselectedLabelStyle: TextStyle(
      //           fontSize: 12,
      //         ),
      //         tabs: [
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Men',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Women',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Shoes',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Electronics',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Accessories',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Home & Garden',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Beauty',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Kids',
      //             ),
      //           ),
      //           Tab(
      //             child: RepeatedTab(
      //               label: 'Bage',
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     body: const TabBarView(
      //       children: [
      //         MenGallery(),
      //         WomenGallery(),
      //         ShoesGallery(),
      //         ElectronicGallery(),
      //         AccessoriesGallery(),
      //         HomeAndGardenGallery(),
      //         BeautyGallery(),
      //         KidsGallery(),
      //         BagsGallery(),
      //       ],
      //     ),
      //   ),
      // ),
    ));
  }
}



class RepeatedTab extends StatelessWidget {
  const RepeatedTab({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }
}

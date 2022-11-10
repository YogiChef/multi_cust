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

import '../widgets/fakesearch.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const FakeSearch(),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            indicatorWeight: 4,
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
        body: const TabBarView(
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
    );
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

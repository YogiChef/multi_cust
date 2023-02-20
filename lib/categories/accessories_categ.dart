import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class AccessoriesCategory extends StatelessWidget {
  const AccessoriesCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: SizedBox(
              height: size.height * 0.8,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const CategHeaderLabel(
                  //   headerLabel: 'Accessories',
                  // ),
                  SizedBox(
                    height: size.height * 0.68,
                    child: GridView.count(
                      mainAxisSpacing: 60,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(
                        accessories.length - 1,
                        (index) => SubcategModel(
                          mainCategName: 'accessories',
                          subCategName: accessories[index + 1],
                          assetName: 'images/accessories/accessories$index.jpg',
                          subctegLabel: accessories[index + 1],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              size: size,
              maincategName: 'accessories',
            ),
          ),
        ],
      ),
    );
  }
}

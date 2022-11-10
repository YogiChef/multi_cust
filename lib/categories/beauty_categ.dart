import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class BeautyCategory extends StatelessWidget {
  const BeautyCategory({Key? key}) : super(key: key);

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
                  const CategHeaderLabel(
                    headerLabel: 'Beauty',
                  ),
                  SizedBox(
                    height: size.height * 0.68,
                    child: GridView.count(
                      mainAxisSpacing: 60,
                      crossAxisSpacing: 5,
                      crossAxisCount: 2,
                      children: List.generate(
                        beauty.length - 1,
                        (index) => SubcategModel(
                          mainCategName: 'beauty',
                          subCategName: beauty[index + 1],
                          assetName: 'images/beauty/beauty$index.jpg',
                          subctegLabel: beauty[index + 1],
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
                maincategName: 'beauty',
              ))
        ],
      ),
    );
  }
}

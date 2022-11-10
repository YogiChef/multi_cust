import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class WomenCategory extends StatelessWidget {
  const WomenCategory({Key? key}) : super(key: key);

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
                  //   headerLabel: 'women',
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: size.height * 0.7,
                      child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        crossAxisCount: 3,
                        children: List.generate(
                          women.length - 1,
                          (index) => SubcategModel(
                            mainCategName: 'women',
                            subCategName: women[index + 1],
                            assetName: 'images/women/women$index.jpg',
                            subctegLabel: women[index + 1],
                          ),
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
                maincategName: 'women',
              ))
        ],
      ),
    );
  }
}

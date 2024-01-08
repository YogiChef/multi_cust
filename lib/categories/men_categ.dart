import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

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
                  //   headerLabel: 'men',
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: size.height * 0.68,
                      child: GridView.count(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 5,
                        crossAxisCount: 3,
                        children: List.generate(
                          men.length - 1,
                          (index) => SubcategModel(
                            mainCategName: 'men',
                            subCategName: men[index + 1],
                            assetName: 'images/men/men$index.jpg',
                            subctegLabel: men[index + 1],
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
                maincategName: 'men',
              ))
        ],
      ),
    );
  }
}

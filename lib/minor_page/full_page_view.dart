import 'package:flutter/material.dart';

class FullPageView extends StatefulWidget {
  final List<dynamic> imgList;
  const FullPageView({super.key, required this.imgList});

  @override
  State<FullPageView> createState() => _FullPageViewState();
}

class _FullPageViewState extends State<FullPageView> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: size.height * 0.7,
                  child: PageView(
                    onPageChanged: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    controller: _controller,
                    children: imges(),
                  ),
                ),
                Positioned(
                    top: 20,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Center(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          )),
                    )),
                Positioned(
                  bottom: 5,
                  left: size.width * 0.45,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      ('${index + 1}') +
                          ('/') +
                          (widget.imgList.length.toString()),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.2,
              child: imageView(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> imges() {
    return List.generate(
        widget.imgList.length,
        (index) => InteractiveViewer(
              transformationController: TransformationController(),
              child: Image.network(
                widget.imgList[index].toString(),
                fit: BoxFit.cover,
              ),
            ));
  }

  ListView imageView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imgList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          _controller.jumpToPage(index);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 4, 20),
          width: 120,
          decoration: BoxDecoration(
              border:
                  Border.all(width: 3, color: Colors.black.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.network(
              widget.imgList[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class Sliderer extends StatelessWidget {


  var sliderIndex = 0.obs;

  Sliderer({Key? key}) : super(key: key);
   List<String> imageList=[

"assets/1.png",
"assets/2.png",
"assets/3.png",
"assets/4.png",
"assets/5.png",
   ];
  @override
  Widget build(BuildContext context) {

    return Column(children: [
      Container(
        // color: Colors.black,
        height: 160,
        width: double.infinity,
        child: CarouselSlider.builder(
          itemCount: imageList.length,
          itemBuilder: (context, index, realIndex) => Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              '${imageList[index]}',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          options: CarouselOptions(
            autoPlay: true,
            height: 160,
            aspectRatio: 338 / 250,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            onPageChanged: (index, reason) {
              sliderIndex.value = index;
            },
          ),
        ),
      ),
      // Container(
      //
      //   child: Obx(
      //         () => Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         for (int i = 0; i < imageList.length; i++)
      //           Padding(
      //             padding: const EdgeInsets.only(right: 2),
      //             child: Container(
      //               height: i == searchControllerIm.sliderIndex.value
      //                   ? 6
      //                   : 6,
      //               width: i == searchControllerIm.sliderIndex.value
      //                   ? 15
      //                   : 6,
      //               decoration: BoxDecoration(
      //                 color: i == searchControllerIm.sliderIndex.value
      //                     ? AppColor.accent_color
      //                     : Colors.grey,
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //             ),
      //           ),
      //       ],
      //     ),
      //   ),
      // ),
    ],);
  }
}

// import 'package:flutter/material.dart';
//
// import 'package:carousel_slider/carousel_slider.dart';
// class MySlider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         CarouselSlider(
//           items: [
//
//             //1st Image of Slider
//             Container(
//               margin: EdgeInsets.all(6.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/papa3.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//
//             //2nd Image of Slider
//             Container(
//               margin: EdgeInsets.all(6.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/papa4.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//
//             //3rd Image of Slider
//             Container(
//               margin: EdgeInsets.all(6.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/papa4.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//
//             //4th Image of Slider
//
//           ],
//
//           //Slider Container properties
//           options: CarouselOptions(
//             height: 180.0,
//             enlargeCenterPage: true,
//             autoPlay: true,
//             aspectRatio: 16 / 9,
//             autoPlayCurve: Curves.fastOutSlowIn,
//             enableInfiniteScroll: true,
//             autoPlayAnimationDuration: Duration(milliseconds: 800),
//             viewportFraction: 0.8,
//           ),
//         ),
//       ],
//     );
//
//
//   }
// }
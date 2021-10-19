import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Container(

        // width: 350.w,
        // height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/beyond-meat-mcdonalds.png"),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF961F).withOpacity(0.7),
                kPrimaryColor.withOpacity(0.7),
              ],
            ),
          ),
          // child: Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //
          //     children: <Widget>[
          //       Spacer(),
          //
          //
          //     /*  Expanded(
          //         child: SvgPicture.asset("assets/icons/macdonalds.svg"),
          //       ),*/
          //       Expanded(
          //         child: RichText(
          //           text: TextSpan(
          //             style: TextStyle(color: Colors.white),
          //             children: [
          //               TextSpan(
          //                 text: "Get Discount of \n",
          //                 style: TextStyle(fontSize: 16),
          //               ),
          //               TextSpan(
          //                 text: "30% \n",
          //                 style: TextStyle(
          //                   fontSize: 43,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               TextSpan(
          //                 text:
          //                     "at Papa's on your first order & Instant cashback",
          //                 style: TextStyle(fontSize: 10),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
